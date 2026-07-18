import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../database/app_database.dart';
import '../localization/app_language.dart';
import '../models/branch_model.dart';
import '../models/inventory_count_model.dart';
import '../providers/current_session_provider.dart';
import '../providers/global_loading_provider.dart';
import '../providers/inventory_db_provider.dart';
import '../providers/repository_provider.dart';
import '../repositories/inventory_repository.dart';
import '../services/app_exit_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_error_banner.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/app_text_field.dart';
import '../widgets/product_image_widgets.dart';
import '../widgets/section_title.dart';
import 'barcode_scanner_screen.dart';
import 'settings_screen.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final barcodeController = TextEditingController();
  final quantityController = TextEditingController();
  final barcodeFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();
  final imagePicker = ImagePicker();

  List<InventoryCountModel> inventory = [];
  ProductImage? currentProductImage;
  Uint8List? pendingProductImageBytes;
  String loadedImageBarcode = '';
  String? barcodeErrorText;
  String? quantityErrorText;
  bool saving = false;
  bool branchSwitching = false;
  String? branchSwitchError;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    barcodeController.addListener(_handleBarcodeChanged);
    quantityController.addListener(_handleQuantityChanged);
    loadInventory();
  }

  void _handleQuantityChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadInventory() async {
    final branch = ref.read(currentBranchProvider);

    if (branch == null) {
      if (!mounted) return;

      setState(() {
        inventory = [];
        loading = false;
      });
      return;
    }

    final repo = ref.read(inventoryRepositoryProvider);
    final data = await repo.getOperationalInventoryForBranch(branch);

    if (!mounted) return;

    setState(() {
      inventory = data;
      loading = false;
    });
  }

  void _handleBarcodeChanged() {
    final barcode = barcodeController.text.trim();

    if (barcode == loadedImageBarcode) {
      return;
    }

    pendingProductImageBytes = null;
    _loadProductImageForBarcode(barcode);
  }

  Future<void> _loadProductImageForBarcode(String barcode) async {
    loadedImageBarcode = barcode;

    if (barcode.isEmpty) {
      if (!mounted) return;

      setState(() {
        currentProductImage = null;
        pendingProductImageBytes = null;
      });
      return;
    }

    final repo = ref.read(inventoryRepositoryProvider);
    final image = await repo.getProductImageForBarcode(barcode);

    if (!mounted || barcodeController.text.trim() != barcode) {
      return;
    }

    setState(() {
      currentProductImage = image;
      pendingProductImageBytes = null;
    });
  }

  Future<void> saveProduct() async {
    if (saving) {
      return;
    }

    final strings = ref.read(appStringsProvider);
    final barcode = barcodeController.text.trim();
    final quantity = int.tryParse(quantityController.text.trim());

    setState(() {
      barcodeErrorText = barcode.isEmpty ? strings.barcodeRequired : null;
      quantityErrorText = quantity == null ? strings.quantityRequired : null;
    });

    if (barcodeErrorText != null || quantityErrorText != null) {
      return;
    }

    final repo = ref.read(inventoryRepositoryProvider);
    final branch = ref.read(currentBranchProvider);
    final employee = ref.read(currentEmployeeProvider);

    if (branch == null || employee == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.sessionLoadFailedBody)));
      return;
    }

    saving = true;
    setState(() {});

    var inventorySaved = false;
    var imageSaveFailed = false;

    try {
      await ref.read(globalLoadingProvider.notifier).runWithLoading<void>(
        () async {
          await repo.saveOperationalInventory(
            branch: branch,
            employee: employee,
            barcode: barcode,
            quantity: quantity!,
          );
          inventorySaved = true;

          final pendingImageBytes = pendingProductImageBytes;

          if (pendingImageBytes != null) {
            try {
              await repo.saveProductImageBytes(
                barcode: barcode,
                sourceBytes: pendingImageBytes,
              );
            } catch (error, stackTrace) {
              imageSaveFailed = true;
              debugPrint(
                'Product image save failed after inventory save: $error',
              );
              debugPrintStack(stackTrace: stackTrace);
            }
          }

          barcodeController.clear();
          quantityController.clear();
          loadedImageBarcode = '';
          currentProductImage = null;
          pendingProductImageBytes = null;
          barcodeErrorText = null;
          quantityErrorText = null;

          ref.invalidate(operationalInventoryProvider(branch));
          await loadInventory();

          if (!mounted) return;

          barcodeFocusNode.requestFocus();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                imageSaveFailed
                    ? strings.inventorySavedImageFailed
                    : strings.savedSuccessfully,
              ),
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('Could not save inventory: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            inventorySaved
                ? strings.inventorySavedImageFailed
                : strings.couldNotSaveInventory,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  Future<void> scanBarcode() async {
    final barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );

    if (!mounted || barcode == null || barcode.isEmpty) {
      return;
    }

    barcodeController.text = barcode;
    await _loadProductImageForBarcode(barcode);
    quantityFocusNode.requestFocus();
  }

  Future<void> showProductImageActions() async {
    final barcode = barcodeController.text.trim();

    if (barcode.isEmpty) {
      final strings = ref.read(appStringsProvider);
      setState(() {
        barcodeErrorText = strings.barcodeRequired;
      });
      return;
    }

    final action = await _showProductImageActionSheet(
      canDelete:
          currentProductImage != null || pendingProductImageBytes != null,
    );

    if (!mounted || action == null || action == _ProductImageAction.cancel) {
      return;
    }

    if (action == _ProductImageAction.delete) {
      final confirmed = await _confirmDeleteProductImage();

      if (confirmed != true || !mounted) {
        return;
      }

      if (currentProductImage == null) {
        setState(() {
          pendingProductImageBytes = null;
        });
        return;
      }

      final repo = ref.read(inventoryRepositoryProvider);
      await ref.read(globalLoadingProvider.notifier).runWithLoading<void>(
        () async {
          await repo.deleteProductImage(barcode);
          pendingProductImageBytes = null;
          await _loadProductImageForBarcode(barcode);
        },
      );
      return;
    }

    final source = action == _ProductImageAction.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxWidth: 800,
      imageQuality: 78,
    );

    if (!mounted || pickedImage == null) {
      return;
    }

    final previewBytes = await pickedImage.readAsBytes();

    if (!mounted || barcodeController.text.trim() != barcode) {
      return;
    }

    setState(() {
      pendingProductImageBytes = previewBytes;
    });
  }

  Future<_ProductImageAction?> _showProductImageActionSheet({
    required bool canDelete,
  }) {
    final strings = ref.read(appStringsProvider);

    return showModalBottomSheet<_ProductImageAction>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(strings.takePhoto),
                onTap: () {
                  Navigator.pop(context, _ProductImageAction.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(strings.chooseFromGallery),
                onTap: () {
                  Navigator.pop(context, _ProductImageAction.gallery);
                },
              ),
              if (canDelete)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: AppTheme.error,
                  ),
                  title: Text(strings.deleteProductImage),
                  onTap: () {
                    Navigator.pop(context, _ProductImageAction.delete);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.close),
                title: Text(strings.cancel),
                onTap: () {
                  Navigator.pop(context, _ProductImageAction.cancel);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> _confirmDeleteProductImage() {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(ref.read(appStringsProvider).deleteProductImageTitle),
          content: Text(ref.read(appStringsProvider).actionCannotBeUndone),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(ref.read(appStringsProvider).cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(ref.read(appStringsProvider).delete),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _confirmDeleteInventoryRecord() {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(ref.read(appStringsProvider).deleteInventoryRecordTitle),
          content: Text(ref.read(appStringsProvider).actionCannotBeUndone),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(ref.read(appStringsProvider).cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(ref.read(appStringsProvider).delete),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditInventoryDialog(InventoryCountModel item) async {
    final strings = ref.read(appStringsProvider);
    final repository = ref.read(inventoryRepositoryProvider);
    final branch = ref.read(currentBranchProvider);

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return _EditInventoryDialog(
          item: item,
          repository: repository,
          loadingController: ref.read(globalLoadingProvider.notifier),
          strings: strings,
          imagePicker: imagePicker,
        );
      },
    );

    if (saved == true && mounted && branch != null) {
      await loadInventory();
      ref.invalidate(operationalInventoryProvider(branch));

      if (barcodeController.text.trim() == item.barcode) {
        await _loadProductImageForBarcode(item.barcode);
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.savedSuccessfully)));
    }
  }

  Future<void> _confirmExit(AppStrings strings) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.exitApplication),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(strings.exit),
            ),
          ],
        );
      },
    );

    if (shouldExit == true) {
      await AppExitService.exitApplication();
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  Future<void> _switchCurrentBranch({
    required BranchModel previousBranch,
    required BranchModel selectedBranch,
  }) async {
    if (branchSwitching ||
        selectedBranch.branchCode == previousBranch.branchCode) {
      return;
    }

    setState(() {
      branchSwitching = true;
      branchSwitchError = null;
    });

    try {
      await ref
          .read(currentSessionProvider.notifier)
          .selectCurrentBranch(selectedBranch);

      if (!mounted) {
        return;
      }

      setState(() {
        barcodeController.clear();
        quantityController.clear();
        loadedImageBarcode = '';
        currentProductImage = null;
        pendingProductImageBytes = null;
        barcodeErrorText = null;
        quantityErrorText = null;
        inventory = [];
        loading = true;
      });

      ref.invalidate(operationalInventoryProvider(previousBranch));
      ref.invalidate(operationalInventoryProvider(selectedBranch));

      await loadInventory();

      if (!mounted) {
        return;
      }

      barcodeFocusNode.requestFocus();
    } catch (error, stackTrace) {
      debugPrint('Current branch switch failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      try {
        await ref
            .read(currentSessionProvider.notifier)
            .selectCurrentBranch(previousBranch);
      } catch (restoreError, restoreStackTrace) {
        debugPrint('Current branch restore failed: $restoreError');
        debugPrintStack(stackTrace: restoreStackTrace);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
        branchSwitchError = ref.read(appStringsProvider).branchSwitchFailed;
      });
    } finally {
      if (mounted) {
        setState(() {
          branchSwitching = false;
        });
      }
    }
  }

  @override
  void dispose() {
    barcodeController.removeListener(_handleBarcodeChanged);
    quantityController.removeListener(_handleQuantityChanged);
    barcodeController.dispose();
    quantityController.dispose();
    barcodeFocusNode.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final branch = ref.watch(currentBranchProvider);
    final employee = ref.watch(currentEmployeeProvider);
    final accessibleBranches = ref.watch(accessibleBranchesProvider);

    if (branch == null || employee == null) {
      return AppFrame(
        child: ErrorView(
          message: strings.sessionLoadFailedBody,
          retryLabel: strings.retry,
        ),
      );
    }

    ref.listen<AsyncValue<List<InventoryCountModel>>>(
      operationalInventoryProvider(branch),
      (previous, next) {
        next.whenData((data) {
          if (!mounted) {
            return;
          }

          setState(() {
            inventory = data;
            loading = false;
          });
        });
      },
    );
    ref.watch(operationalInventoryProvider(branch));

    if (loading) {
      return AppFrame(child: LoadingView(message: strings.loadingInventory));
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _confirmExit(strings);
      },
      child: AppFrame(
        showAppBar: false,
        headerLeading: IconButton(
          tooltip: strings.exit,
          onPressed: () {
            _confirmExit(strings);
          },
          icon: const Icon(Icons.exit_to_app_outlined),
        ),
        headerActions: [
          IconButton(
            tooltip: strings.settings,
            onPressed: _openSettings,
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
        child: AppScrollbar(
          builder: (controller) {
            return ListView(
              controller: controller,
              children: [
                if (accessibleBranches.length > 1) ...[
                  _ScanBranchSelector(
                    currentBranchName: branch.name,
                    branchSwitching: branchSwitching,
                    branches: accessibleBranches,
                    currentBranch: branch,
                    branchTooltip: strings.switchBranch,
                    onBranchSelected: (selectedBranch) {
                      _switchCurrentBranch(
                        previousBranch: branch,
                        selectedBranch: selectedBranch,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                if (branchSwitchError != null) ...[
                  AppErrorBanner(message: branchSwitchError!),
                  const SizedBox(height: 12),
                ],
                SectionTitle(
                  title: strings.scanProducts,
                  subtitle: strings.employeeSubtitle(employee.name),
                  icon: Icons.qr_code_scanner,
                ),
                const SizedBox(height: 18),
                Row(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Directionality(
                        textDirection: Directionality.of(context),
                        child: AppTextField(
                          controller: barcodeController,
                          focusNode: barcodeFocusNode,
                          label: strings.barcode,
                          icon: Icons.document_scanner_outlined,
                          keyboardType: TextInputType.number,
                          errorText: barcodeErrorText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 92,
                      height: 48,
                      child: FilledButton.tonal(
                        onPressed: scanBarcode,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.success.withValues(
                            alpha: 0.16,
                          ),
                          foregroundColor: AppTheme.success,
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Image.asset(
                          'assets/icons/scan_barcode.png',
                          width: 55,
                          height: 46,
                          fit: BoxFit.fill,
                          semanticLabel: strings.scanBarcode,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: quantityController,
                  focusNode: quantityFocusNode,
                  label: strings.quantity,
                  icon: Icons.add_chart_outlined,
                  keyboardType: TextInputType.number,
                  errorText: quantityErrorText,
                ),
                const SizedBox(height: 12),
                ProductImageSection(
                  image: currentProductImage,
                  previewBytes: pendingProductImageBytes,
                  barcode: barcodeController.text.trim(),
                  repository: ref.read(inventoryRepositoryProvider),
                  onAdd: showProductImageActions,
                  onReplace: showProductImageActions,
                  noImageLabel: strings.noProductImage,
                  addImageLabel: strings.addProductImage,
                  replaceImageLabel: strings.replaceProductImage,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: strings.save,
                  icon: Icons.save_outlined,
                  onPressed:
                      saving ||
                          barcodeController.text.trim().isEmpty ||
                          quantityController.text.trim().isEmpty
                      ? null
                      : saveProduct,
                ),
                const SizedBox(height: 18),
                _InventoryHeader(
                  label: strings.countedProducts(inventory.length),
                ),
                const SizedBox(height: 12),
                if (inventory.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: EmptyState(
                      icon: Icons.inventory_2_outlined,
                      message: strings.noInventoryItems,
                    ),
                  )
                else
                  ...inventory.map(
                    (item) => AppListCard(
                      child: ListTile(
                        leading: _InventoryProductImage(
                          barcode: item.barcode,
                          fallbackIcon: Icons.inventory_2_outlined,
                        ),
                        title: Text(
                          item.barcode,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${strings.quantity}: ${item.quantity}'),
                              Text(_formatInventoryTimestamp(item.countedAt)),
                            ],
                          ),
                        ),
                        trailing: Wrap(
                          spacing: 4,
                          children: [
                            IconButton(
                              tooltip: strings.edit,
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () {
                                _showEditInventoryDialog(item);
                              },
                            ),
                            IconButton(
                              tooltip: strings.delete,
                              icon: const Icon(
                                Icons.delete_outline,
                                color: AppTheme.error,
                              ),
                              onPressed: () async {
                                final confirmed =
                                    await _confirmDeleteInventoryRecord();

                                if (confirmed != true) {
                                  return;
                                }

                                final repo = ref.read(
                                  inventoryRepositoryProvider,
                                );
                                await ref
                                    .read(globalLoadingProvider.notifier)
                                    .runWithLoading<void>(() async {
                                      await repo
                                          .deleteOperationalInventoryRecord(
                                            item.id,
                                          );
                                      ref.invalidate(
                                        operationalInventoryProvider(branch),
                                      );
                                      await loadInventory();
                                      if (barcodeController.text.trim() ==
                                          item.barcode) {
                                        await _loadProductImageForBarcode(
                                          item.barcode,
                                        );
                                      }
                                    });

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      strings.inventoryRecordDeleted,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ScanBranchSelector extends StatelessWidget {
  final String currentBranchName;
  final bool branchSwitching;
  final List<BranchModel> branches;
  final BranchModel currentBranch;
  final String branchTooltip;
  final ValueChanged<BranchModel> onBranchSelected;

  const _ScanBranchSelector({
    required this.currentBranchName,
    required this.branchSwitching,
    required this.branches,
    required this.currentBranch,
    required this.branchTooltip,
    required this.onBranchSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: _CurrentBranchSwitcherButton(
          label: currentBranchName,
          tooltip: branchTooltip,
          branches: branches,
          currentBranch: currentBranch,
          enabled: !branchSwitching,
          onSelected: onBranchSelected,
        ),
      ),
    );
  }
}

class _CurrentBranchSwitcherButton extends StatelessWidget {
  final String label;
  final String tooltip;
  final List<BranchModel> branches;
  final BranchModel currentBranch;
  final bool enabled;
  final ValueChanged<BranchModel> onSelected;

  const _CurrentBranchSwitcherButton({
    required this.label,
    required this.tooltip,
    required this.branches,
    required this.currentBranch,
    required this.enabled,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BranchModel>(
      tooltip: tooltip,
      enabled: enabled,
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          for (final branch in branches)
            CheckedPopupMenuItem<BranchModel>(
              value: branch,
              checked: branch.branchCode == currentBranch.branchCode,
              child: Text(branch.name, overflow: TextOverflow.ellipsis),
            ),
        ];
      },
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: AppTheme.primary.withValues(alpha: enabled ? 0.08 : 0.04),
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.storefront_outlined,
                  size: 18,
                  color: enabled
                      ? AppTheme.primary
                      : AppTheme.primary.withValues(alpha: 0.45),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: enabled
                          ? AppTheme.primary
                          : AppTheme.primary.withValues(alpha: 0.45),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.expand_more,
                  size: 18,
                  color: enabled
                      ? AppTheme.primary
                      : AppTheme.primary.withValues(alpha: 0.45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _ProductImageAction { camera, gallery, delete, cancel }

class _EditInventoryDialog extends StatefulWidget {
  final InventoryCountModel item;
  final InventoryRepository repository;
  final GlobalLoadingController loadingController;
  final AppStrings strings;
  final ImagePicker imagePicker;

  const _EditInventoryDialog({
    required this.item,
    required this.repository,
    required this.loadingController,
    required this.strings,
    required this.imagePicker,
  });

  @override
  State<_EditInventoryDialog> createState() => _EditInventoryDialogState();
}

class _EditInventoryDialogState extends State<_EditInventoryDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController quantityController;

  ProductImage? currentImage;
  Uint8List? pendingImageBytes;
  bool deleteImageRequested = false;
  bool loadingImage = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
    _loadImage();
  }

  Future<void> _loadImage() async {
    final image = await widget.repository.getProductImageForBarcode(
      widget.item.barcode,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      currentImage = image;
      loadingImage = false;
    });
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;

    return AlertDialog(
      title: Text(strings.editInventoryRecord),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: widget.item.barcode,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: strings.barcode,
                  prefixIcon: const Icon(Icons.document_scanner_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: quantityController,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: strings.quantity,
                  prefixIcon: const Icon(Icons.add_chart_outlined),
                ),
                validator: (value) {
                  if (int.tryParse(value?.trim() ?? '') == null) {
                    return strings.quantityRequired;
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (loadingImage)
                const CircularProgressIndicator()
              else
                ProductImageSection(
                  image: deleteImageRequested ? null : currentImage,
                  previewBytes: pendingImageBytes,
                  barcode: widget.item.barcode,
                  repository: widget.repository,
                  onAdd: _showImageActions,
                  onReplace: _showImageActions,
                  noImageLabel: strings.noProductImage,
                  addImageLabel: strings.addProductImage,
                  replaceImageLabel: strings.replaceProductImage,
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving
              ? null
              : () {
                  Navigator.of(context).pop(false);
                },
          child: Text(strings.cancel),
        ),
        FilledButton(
          onPressed: saving ? null : _save,
          child: Text(strings.save),
        ),
      ],
    );
  }

  Future<void> _showImageActions() async {
    final strings = widget.strings;
    final action = await showModalBottomSheet<_ProductImageAction>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(strings.takePhoto),
                onTap: () {
                  Navigator.pop(context, _ProductImageAction.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(strings.chooseFromGallery),
                onTap: () {
                  Navigator.pop(context, _ProductImageAction.gallery);
                },
              ),
              if (currentImage != null || pendingImageBytes != null)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: AppTheme.error,
                  ),
                  title: Text(strings.deleteProductImage),
                  onTap: () {
                    Navigator.pop(context, _ProductImageAction.delete);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.close),
                title: Text(strings.cancel),
                onTap: () {
                  Navigator.pop(context, _ProductImageAction.cancel);
                },
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null || action == _ProductImageAction.cancel) {
      return;
    }

    if (action == _ProductImageAction.delete) {
      final confirmed = await _confirmDeleteProductImage();

      if (confirmed != true || !mounted) {
        return;
      }

      setState(() {
        pendingImageBytes = null;
        deleteImageRequested = true;
      });
      return;
    }

    final source = action == _ProductImageAction.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    final pickedImage = await widget.imagePicker.pickImage(
      source: source,
      maxWidth: 800,
      imageQuality: 78,
    );

    if (!mounted || pickedImage == null) {
      return;
    }

    final bytes = await pickedImage.readAsBytes();

    if (!mounted) {
      return;
    }

    setState(() {
      pendingImageBytes = bytes;
      deleteImageRequested = false;
    });
  }

  Future<bool?> _confirmDeleteProductImage() {
    final strings = widget.strings;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.deleteProductImageTitle),
          content: Text(strings.actionCannotBeUndone),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(strings.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(strings.delete),
            ),
          ],
        );
      },
    );
  }

  Future<void> _save() async {
    if (saving || !formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      saving = true;
    });

    final quantity = int.parse(quantityController.text.trim());
    var saved = false;

    try {
      await widget.loadingController.runWithLoading<void>(() async {
        final imageBytes = pendingImageBytes;

        if (imageBytes != null) {
          await widget.repository.saveProductImageBytes(
            barcode: widget.item.barcode,
            sourceBytes: imageBytes,
          );
        } else if (deleteImageRequested) {
          await widget.repository.deleteProductImage(widget.item.barcode);
        }

        await widget.repository.updateOperationalInventoryRecord(
          id: widget.item.id,
          quantity: quantity,
        );

        if (!mounted) {
          return;
        }

        saved = true;
        Navigator.of(context).pop(true);
      });
    } catch (error, stackTrace) {
      debugPrint('Could not save inventory edit: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.strings.couldNotSaveInventory)),
      );
    } finally {
      if (mounted && !saved) {
        setState(() {
          saving = false;
        });
      }
    }
  }
}

String _formatInventoryTimestamp(DateTime value) {
  return value.toLocal().toString().substring(0, 16);
}

class _InventoryProductImage extends ConsumerWidget {
  final String barcode;
  final IconData fallbackIcon;

  const _InventoryProductImage({
    required this.barcode,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(inventoryRepositoryProvider);

    return FutureBuilder<ProductImage?>(
      future: repository.getProductImageForBarcode(barcode),
      builder: (context, snapshot) {
        final image = snapshot.data;

        if (image == null) {
          return Icon(fallbackIcon);
        }

        return ProductImageThumbnail(
          imagePath: image.imagePath,
          repository: repository,
          size: 46,
        );
      },
    );
  }
}

class _InventoryHeader extends StatelessWidget {
  final String label;

  const _InventoryHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.fact_check_outlined, color: AppTheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
