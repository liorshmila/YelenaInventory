import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../database/app_database.dart';
import '../localization/app_language.dart';
import '../providers/repository_provider.dart';
import '../repositories/inventory_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/app_text_field.dart';
import '../widgets/product_image_widgets.dart';
import '../widgets/section_title.dart';
import 'barcode_scanner_screen.dart';

class ScanScreen extends ConsumerStatefulWidget {
  final Employee employee;

  const ScanScreen({super.key, required this.employee});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final barcodeController = TextEditingController();
  final quantityController = TextEditingController();
  final barcodeFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();
  final imagePicker = ImagePicker();

  List<InventoryCount> inventory = [];
  ProductImage? currentProductImage;
  Uint8List? pendingProductImageBytes;
  String loadedImageBarcode = '';
  String? barcodeErrorText;
  String? quantityErrorText;
  bool saving = false;

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
    final repo = ref.read(inventoryRepositoryProvider);
    final data = await repo.getInventory();

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

    saving = true;
    setState(() {});

    try {
      await repo.saveInventory(
        barcode: barcode,
        quantity: quantity!,
        employeeId: widget.employee.id,
      );

      final pendingImageBytes = pendingProductImageBytes;

      if (pendingImageBytes != null) {
        await repo.saveProductImageBytes(
          barcode: barcode,
          sourceBytes: pendingImageBytes,
        );
      }

      barcodeController.clear();
      quantityController.clear();
      loadedImageBarcode = '';
      currentProductImage = null;
      pendingProductImageBytes = null;
      barcodeErrorText = null;
      quantityErrorText = null;

      await loadInventory();

      if (!mounted) return;

      barcodeFocusNode.requestFocus();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.savedSuccessfully)));
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
      await repo.deleteProductImage(barcode);
      pendingProductImageBytes = null;
      await _loadProductImageForBarcode(barcode);
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

  Future<void> _showEditInventoryDialog(InventoryCount item) async {
    final strings = ref.read(appStringsProvider);
    final repository = ref.read(inventoryRepositoryProvider);

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return _EditInventoryDialog(
          item: item,
          repository: repository,
          strings: strings,
          imagePicker: imagePicker,
        );
      },
    );

    if (saved == true && mounted) {
      await loadInventory();

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

    if (loading) {
      return AppFrame(child: LoadingView(message: strings.loadingInventory));
    }

    return AppFrame(
      child: AppScrollbar(
        builder: (controller) {
          return ListView(
            controller: controller,
            children: [
              SectionTitle(
                title: strings.scanProducts,
                subtitle: strings.employeeSubtitle(widget.employee.name),
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
              const SizedBox(height: 12),
              AppTextField(
                controller: quantityController,
                focusNode: quantityFocusNode,
                label: strings.quantity,
                icon: Icons.add_chart_outlined,
                keyboardType: TextInputType.number,
                errorText: quantityErrorText,
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
                            Text(item.countDate.toString().substring(0, 16)),
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
                              await repo.deleteInventory(item.id);
                              await loadInventory();
                              if (barcodeController.text.trim() ==
                                  item.barcode) {
                                await _loadProductImageForBarcode(item.barcode);
                              }

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(strings.inventoryRecordDeleted),
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
    );
  }
}

enum _ProductImageAction { camera, gallery, delete, cancel }

class _EditInventoryDialog extends StatefulWidget {
  final InventoryCount item;
  final InventoryRepository repository;
  final AppStrings strings;
  final ImagePicker imagePicker;

  const _EditInventoryDialog({
    required this.item,
    required this.repository,
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

    await widget.repository.updateInventoryRecord(
      id: widget.item.id,
      quantity: quantity,
    );

    final imageBytes = pendingImageBytes;

    if (imageBytes != null) {
      await widget.repository.saveProductImageBytes(
        barcode: widget.item.barcode,
        sourceBytes: imageBytes,
      );
    } else if (deleteImageRequested) {
      await widget.repository.deleteProductImage(widget.item.barcode);
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }
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
