import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/branch_model.dart';
import '../providers/branch_provider.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_state_views.dart';
import '../widgets/section_title.dart';
import 'employee_selection_screen.dart';

class BranchSelectionScreen extends ConsumerWidget {
  const BranchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);

    return AppFrame(
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
              const SectionTitle(
                title: 'בחר סניף',
                subtitle: 'בחר את הסניף שבו מתבצעת ספירת המלאי.',
                icon: Icons.storefront,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
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
                            builder: (_) => const EmployeeSelectionScreen(),
                          ),
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
    );
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
        subtitle: Text('Id: ${branch.id}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
