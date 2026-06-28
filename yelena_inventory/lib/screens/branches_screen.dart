import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/branch_provider.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_state_views.dart';
import '../widgets/section_title.dart';

class BranchesScreen extends ConsumerWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);

    return AppFrame(
      child: branchesAsync.when(
        loading: () => const LoadingView(message: 'טוען סניפים...'),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(branchesProvider);
          },
        ),
        data: (branches) {
          if (branches.isEmpty) {
            return const EmptyState(
              icon: Icons.business_outlined,
              message: 'אין סניפים',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'סניפים',
                subtitle: 'רשימת הסניפים הזמינים במערכת.',
                icon: Icons.business,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(branchesProvider);
                    await ref.read(branchesProvider.future);
                  },
                  child: ListView.builder(
                    itemCount: branches.length,
                    itemBuilder: (context, index) {
                      final branch = branches[index];

                      return AppListCard(
                        child: ListTile(
                          leading: const Icon(Icons.business),
                          title: Text(
                            branch.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text('Id: ${branch.id}'),
                        ),
                      );
                    },
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
