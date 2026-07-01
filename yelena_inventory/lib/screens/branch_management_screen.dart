import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return AppFrame(
      child: branchesAsync.when(
        loading: () => const LoadingView(message: 'Loading branches...'),
        error: (error, stack) => ErrorView(
          message: 'Could not load branches.',
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
                  const SectionTitle(
                    title: 'Manage Branches',
                    subtitle: 'Add, edit, or remove store branches.',
                    icon: Icons.business_outlined,
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: branches.isEmpty
                        ? EmptyStateWithAction(
                            icon: Icons.business_outlined,
                            message: 'No branches found',
                            actionLabel: 'Create first branch',
                            onPressed: () {
                              _showBranchDialog(context: context, ref: ref);
                            },
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

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Branch' : 'Add Branch'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Branch Name',
                prefixIcon: Icon(Icons.business_outlined),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Branch name is required.';
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
              child: const Text('Cancel'),
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
              child: const Text('Save'),
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
          content: Text(isEditing ? 'Branch updated.' : 'Branch created.'),
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
        const SnackBar(
          content: Text('A branch with this name already exists.'),
        ),
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
    if (branchesCount <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one branch must exist.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Branch'),
          content: Text('Delete branch "${branch.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(inventoryRepositoryProvider).deleteBranch(branch.id);

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
      ).showSnackBar(const SnackBar(content: Text('Branch deleted.')));
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete this branch.')),
      );
    }
  }
}

class _BranchManagementTile extends StatelessWidget {
  final BranchModel branch;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BranchManagementTile({
    required this.branch,
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
              tooltip: 'Edit',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: AppTheme.error),
            ),
          ],
        ),
      ),
    );
  }
}
