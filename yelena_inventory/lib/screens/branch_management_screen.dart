import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../models/branch_model.dart';
import '../models/create_branch_result.dart';
import '../models/deactivate_branch_result.dart';
import '../models/update_branch_result.dart';
import '../providers/branch_provider.dart';
import '../providers/current_session_provider.dart';
import '../providers/global_loading_provider.dart';
import '../providers/repository_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/current_user_header.dart';
import '../widgets/section_title.dart';

class BranchManagementScreen extends ConsumerWidget {
  const BranchManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);
    final strings = ref.watch(appStringsProvider);
    final canManageBranches = ref.watch(canManageBranchesProvider);

    if (!canManageBranches) {
      return AppFrame(child: ErrorView(message: strings.unauthorized));
    }

    return AppFrame(
      child: branchesAsync.when(
        loading: () => LoadingView(message: strings.loadingBranches),
        error: (error, stack) => ErrorView(
          message: strings.couldNotLoadBranches,
          onRetry: () {
            ref.invalidate(branchesProvider);
          },
        ),
        data: (branches) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CurrentUserHeader(),
                  const SizedBox(height: 14),
                  Expanded(
                    child: AppScrollbar(
                      builder: (controller) {
                        return ListView(
                          controller: controller,
                          padding: const EdgeInsets.only(bottom: 112),
                          children: [
                            SectionTitle(
                              title: strings.manageBranches,
                              subtitle: strings.manageBranchesSubtitle,
                              icon: Icons.business_outlined,
                            ),
                            const SizedBox(height: 18),
                            if (branches.isEmpty)
                              EmptyState(
                                icon: Icons.business_outlined,
                                message: strings.noBranchesFound,
                              )
                            else
                              for (final branch in branches)
                                _BranchManagementTile(
                                  branch: branch,
                                  editLabel: strings.edit,
                                  deleteLabel: strings.delete,
                                  onEdit: () {
                                    _showBranchDialog(
                                      context: context,
                                      ref: ref,
                                      branch: branch,
                                    );
                                  },
                                  onDelete: () {
                                    _confirmDeleteBranch(
                                      context: context,
                                      ref: ref,
                                      branch: branch,
                                      branchesCount: branches.length,
                                    );
                                  },
                                ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    _showBranchDialog(context: context, ref: ref);
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showBranchDialog({
    required BuildContext context,
    required WidgetRef ref,
    BranchModel? branch,
  }) async {
    final controller = TextEditingController(text: branch?.name ?? '');
    final formKey = GlobalKey<FormState>();
    final isEditing = branch != null;
    final strings = ref.read(appStringsProvider);
    String? branchError;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            void showDuplicateNameError() {
              setDialogState(() {
                branchError = strings.branchExists;
              });
            }

            void showEditDuplicateNameError() {
              setDialogState(() {
                branchError = strings.branchNamePreviouslyUsed;
              });
            }

            void showBranchError(String message) {
              setDialogState(() {
                branchError = message;
              });
            }

            return AlertDialog(
              title: Text(isEditing ? strings.editBranch : strings.addBranch),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: strings.branchName,
                        prefixIcon: const Icon(Icons.business_outlined),
                        errorText: branchError,
                        errorMaxLines: 8,
                      ),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return strings.branchNameRequired;
                        }

                        return null;
                      },
                      onChanged: (_) {
                        if (branchError != null) {
                          setDialogState(() {
                            branchError = null;
                          });
                        }
                      },
                      onFieldSubmitted: (_) async {
                        await _saveBranch(
                          context: context,
                          dialogContext: dialogContext,
                          ref: ref,
                          formKey: formKey,
                          controller: controller,
                          branch: branch,
                          onDuplicateName: showDuplicateNameError,
                          onEditDuplicateName: showEditDuplicateNameError,
                          onBranchError: showBranchError,
                        );
                      },
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text(strings.cancel),
                ),
                FilledButton(
                  onPressed: () async {
                    await _saveBranch(
                      context: context,
                      dialogContext: dialogContext,
                      ref: ref,
                      formKey: formKey,
                      controller: controller,
                      branch: branch,
                      onDuplicateName: showDuplicateNameError,
                      onEditDuplicateName: showEditDuplicateNameError,
                      onBranchError: showBranchError,
                    );
                  },
                  child: Text(strings.save),
                ),
              ],
            );
          },
        );
      },
    );

    await WidgetsBinding.instance.endOfFrame;
    controller.dispose();

    if (saved == true && context.mounted) {
      ref.invalidate(branchesProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? strings.branchUpdated : strings.branchCreated,
          ),
        ),
      );
    }
  }

  Future<void> _saveBranch({
    required BuildContext context,
    required BuildContext dialogContext,
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    required TextEditingController controller,
    required VoidCallback onDuplicateName,
    required VoidCallback onEditDuplicateName,
    required ValueChanged<String> onBranchError,
    BranchModel? branch,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    await ref.read(globalLoadingProvider.notifier).runWithLoading<void>(
      () async {
        try {
          final repository = ref.read(inventoryRepositoryProvider);
          final name = controller.text.trim();
          final exists = await repository.branchNameExists(
            name,
            excludeId: branch?.id,
          );

          if (!context.mounted || !dialogContext.mounted) {
            return;
          }

          if (exists) {
            if (branch == null) {
              onDuplicateName();
            } else {
              onEditDuplicateName();
            }
            return;
          }

          if (branch == null) {
            final result = await repository.addBranch(name);
            if (result != CreateBranchResult.created &&
                result != CreateBranchResult.reactivated) {
              final strings = ref.read(appStringsProvider);
              onBranchError(_createBranchResultMessage(result, strings));
              return;
            }
          } else {
            final result = await repository.updateBranch(
              branch: branch,
              name: name,
            );
            if (result != UpdateBranchResult.updated &&
                result != UpdateBranchResult.nothingChanged) {
              final strings = ref.read(appStringsProvider);
              onBranchError(_updateBranchResultMessage(result, strings));
              return;
            }
          }
        } on StateError catch (error) {
          if (error.message == 'Branch name already exists.') {
            if (branch == null) {
              onDuplicateName();
            } else {
              onEditDuplicateName();
            }
            return;
          }

          debugPrint('Branch save failed: $error');
          if (context.mounted && dialogContext.mounted) {
            final strings = ref.read(appStringsProvider);
            onBranchError(strings.authOperationFailed);
          }
          return;
        } catch (error, stackTrace) {
          debugPrint('Branch save failed: $error');
          debugPrintStack(stackTrace: stackTrace);
          if (context.mounted && dialogContext.mounted) {
            final strings = ref.read(appStringsProvider);
            onBranchError(strings.authOperationFailed);
          }
          return;
        }

        if (!context.mounted || !dialogContext.mounted) {
          return;
        }

        Navigator.pop(dialogContext, true);
      },
    );
  }

  String _createBranchResultMessage(
    CreateBranchResult result,
    AppStrings strings,
  ) {
    return switch (result) {
      CreateBranchResult.created => '',
      CreateBranchResult.reactivated => '',
      CreateBranchResult.duplicateName => strings.branchExists,
      CreateBranchResult.invalidName => strings.branchNameRequired,
      CreateBranchResult.unauthorized => strings.unauthorized,
      CreateBranchResult.operationFailed => strings.authOperationFailed,
    };
  }

  String _updateBranchResultMessage(
    UpdateBranchResult result,
    AppStrings strings,
  ) {
    return switch (result) {
      UpdateBranchResult.updated => '',
      UpdateBranchResult.nothingChanged => '',
      UpdateBranchResult.duplicateName => strings.branchNamePreviouslyUsed,
      UpdateBranchResult.invalidName => strings.branchNameRequired,
      UpdateBranchResult.branchNotFound => strings.authOperationFailed,
      UpdateBranchResult.unauthorized => strings.unauthorized,
      UpdateBranchResult.operationFailed => strings.authOperationFailed,
    };
  }

  Future<void> _confirmDeleteBranch({
    required BuildContext context,
    required WidgetRef ref,
    required BranchModel branch,
    required int branchesCount,
  }) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final employeeCount = await ref
        .read(globalLoadingProvider.notifier)
        .runWithLoading<int>(
          () => repository.branchEmployeeCountForManagement(branch),
        );
    final isLastBranch = branchesCount <= 1;
    final strings = ref.read(appStringsProvider);

    if (!context.mounted) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final title = isLastBranch
            ? strings.deleteLastBranchTitle
            : strings.deleteBranchTitle;
        final message = isLastBranch
            ? employeeCount > 0
                  ? strings.lastBranchWithEmployeesWarning
                  : strings.lastBranchWarning
            : employeeCount > 0
            ? strings.branchHasEmployeesWarning
            : strings.deleteBranchMessage(branch.name);

        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      final result = await ref
          .read(globalLoadingProvider.notifier)
          .runWithLoading<DeactivateBranchResult>(
            () => repository.deleteBranch(branch),
          );

      if (!context.mounted) {
        return;
      }

      await WidgetsBinding.instance.endOfFrame;

      if (!context.mounted) {
        return;
      }

      ref.invalidate(branchesProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_deactivateBranchResultMessage(result, strings)),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Branch deactivate failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.couldNotDeleteBranch)));
    }
  }

  String _deactivateBranchResultMessage(
    DeactivateBranchResult result,
    AppStrings strings,
  ) {
    return switch (result) {
      DeactivateBranchResult.deactivated => strings.branchDeleted,
      DeactivateBranchResult.alreadyInactive => strings.branchAlreadyInactive,
      DeactivateBranchResult.branchNotFound => strings.couldNotDeleteBranch,
      DeactivateBranchResult.unauthorized => strings.unauthorized,
      DeactivateBranchResult.operationFailed => strings.couldNotDeleteBranch,
    };
  }
}

class _BranchManagementTile extends StatelessWidget {
  final BranchModel branch;
  final String editLabel;
  final String deleteLabel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BranchManagementTile({
    required this.branch,
    required this.editLabel,
    required this.deleteLabel,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      child: ListTile(
        leading: const Icon(Icons.business),
        title: Text(
          branch.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              tooltip: editLabel,
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: deleteLabel,
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: AppTheme.error),
            ),
          ],
        ),
      ),
    );
  }
}
