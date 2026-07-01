import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/branch_model.dart';
import '../providers/branch_provider.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/section_title.dart';
import 'employee_selection_screen.dart';
import 'settings_screen.dart';

class BranchSelectionScreen extends ConsumerWidget {
  const BranchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _confirmExit(context);
      },
      child: AppFrame(
        title: 'Yelena Inventory',
        leadingWidth: 96,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              _confirmExit(context);
            },
            icon: const Icon(Icons.exit_to_app_outlined),
            label: const Text('Exit'),
          ),
        ),
        child: branchesAsync.when(
          loading: () => const LoadingView(message: 'טוען סניפים...'),
          error: (error, stack) => ErrorView(
            message: 'לא הצלחנו לטעון את רשימת הסניפים.',
            onRetry: () {
              ref.invalidate(branchesProvider);
            },
          ),
          data: (branches) {
            if (branches.isEmpty) {
              return const EmptyState(
                icon: Icons.business_outlined,
                message: 'אין סניפים להצגה',
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: SectionTitle(
                        title: 'בחר סניף',
                        subtitle: 'בחר את הסניף שבו מתבצעת ספירת המלאי.',
                        icon: Icons.storefront,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Settings',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: AppScrollbar(
                    builder: (controller) {
                      return ListView.builder(
                        controller: controller,
                        itemCount: branches.length,
                        itemBuilder: (context, index) {
                          final branch = branches[index];

                          return _BranchTile(
                            branch: branch,
                            onTap: () {
                              ref
                                  .read(selectedBranchProvider.notifier)
                                  .selectBranch(branch);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const EmployeeSelectionScreen(),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmExit(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Exit application?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }
}

class _BranchTile extends StatelessWidget {
  final BranchModel branch;
  final VoidCallback onTap;

  const _BranchTile({required this.branch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      onTap: onTap,
      child: ListTile(
        leading: const Icon(Icons.business),
        title: Text(
          branch.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
