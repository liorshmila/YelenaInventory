import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../providers/branch_provider.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/section_title.dart';

class BranchesScreen extends ConsumerWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);
    final strings = ref.watch(appStringsProvider);

    return AppFrame(
      child: branchesAsync.when(
        loading: () => LoadingView(message: strings.loadingBranches),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          retryLabel: strings.retry,
          onRetry: () {
            ref.invalidate(branchesProvider);
          },
        ),
        data: (branches) {
          if (branches.isEmpty) {
            return EmptyState(
              icon: Icons.business_outlined,
              message: strings.noBranchesFound,
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: strings.branches,
                subtitle: strings.chooseBranchSubtitle,
                icon: Icons.business,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: AppScrollbar(
                  builder: (controller) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(branchesProvider);
                        await ref.read(branchesProvider.future);
                      },
                      child: ListView.builder(
                        controller: controller,
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
                            ),
                          );
                        },
                      ),
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
