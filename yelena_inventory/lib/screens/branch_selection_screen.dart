import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../models/branch_model.dart';
import '../providers/current_session_provider.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/section_title.dart';

class BranchSelectionScreen extends ConsumerWidget {
  const BranchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branches = ref.watch(accessibleBranchesProvider);
    final strings = ref.watch(appStringsProvider);

    return AppFrame(
      title: strings.appTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: strings.chooseBranch,
            subtitle: strings.chooseBranchSubtitle,
            icon: Icons.storefront,
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
                            onTap: () async {
                              await ref
                                  .read(currentSessionProvider.notifier)
                                  .selectCurrentBranch(branch);
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
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
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
