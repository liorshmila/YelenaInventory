import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../models/branch_model.dart';
import '../providers/branch_provider.dart';
import '../providers/repository_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/section_title.dart';

class BranchManagementScreen extends ConsumerWidget {
  const BranchManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);
    final strings = ref.watch(appStringsProvider);

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
                  SectionTitle(
                    title: strings.manageBranches,
                    subtitle: strings.manageBranchesSubtitle,
                    icon: Icons.business_outlined,
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: branches.isEmpty
                        ? EmptyState(
                            icon: Icons.business_outlined,
                            message: strings.noBranchesFound,
                          )
                        : AppScrollbar(
                            builder: (controller) {
                              return ListView.builder(
                                controller: controller,
                                padding: const EdgeInsets.only(bottom: 112),
                                itemCount: branches.length,
                                itemBuilder: (context, index) {
                                  final branch = branches[index];

                                  return _BranchManagementTile(
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
                                  );
                                },
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

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? strings.editBranch : strings.addBranch),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: strings.branchName,
                prefixIcon: const Icon(Icons.business_outlined),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return strings.branchNameRequired;
                }

                return null;
              },
              onFieldSubmitted: (_) async {
                await _saveBranch(
                  context: context,
                  dialogContext: dialogContext,
                  ref: ref,
                  formKey: formKey,
                  controller: controller,
                  branch: branch,
                );
              },
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
                );
              },
              child: Text(strings.save),
            ),
          ],
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
    BranchModel? branch,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.read(appStringsProvider).branchExists)),
      );
      return;
    }

    if (branch == null) {
      await repository.addBranch(name);
    } else {
      await repository.updateBranch(id: branch.id, name: name);
    }

    if (!context.mounted || !dialogContext.mounted) {
      return;
    }

    Navigator.pop(dialogContext, true);
  }

  Future<void> _confirmDeleteBranch({
    required BuildContext context,
    required WidgetRef ref,
    required BranchModel branch,
    required int branchesCount,
  }) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final employeeCount = await repository.branchEmployeeCount(branch.id);
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
      await repository.deleteBranch(branch.id);

      if (!context.mounted) {
        return;
      }

      await WidgetsBinding.instance.endOfFrame;

      if (!context.mounted) {
        return;
      }

      ref.invalidate(branchesProvider);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.branchDeleted)));
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.couldNotDeleteBranch)));
    }
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
