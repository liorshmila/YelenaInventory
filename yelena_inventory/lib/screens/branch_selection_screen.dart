import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../models/branch_model.dart';
import '../providers/branch_provider.dart';
import '../services/app_exit_service.dart';
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
    final strings = ref.watch(appStringsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _confirmExit(context, strings);
      },
      child: AppFrame(
        title: strings.appTitle,
        leadingWidth: 96,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              _confirmExit(context, strings);
            },
            icon: const Icon(Icons.exit_to_app_outlined),
            label: Text(strings.exit),
          ),
        ),
        child: branchesAsync.when(
          loading: () => LoadingView(message: strings.loadingBranches),
          error: (error, stack) => ErrorView(
            message: strings.couldNotLoadBranches,
            onRetry: () {
              ref.invalidate(branchesProvider);
            },
          ),
          data: (branches) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SectionTitle(
                        title: strings.chooseBranch,
                        subtitle: strings.chooseBranchSubtitle,
                        icon: Icons.storefront,
                      ),
                    ),
                    IconButton(
                      tooltip: strings.settings,
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
                  child: branches.isEmpty
                      ? EmptyState(
                          icon: Icons.business_outlined,
                          message: strings.noBranchesCreated,
                        )
                      : AppScrollbar(
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

  Future<void> _confirmExit(BuildContext context, AppStrings strings) async {
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
