import 'package:flutter/material.dart';

import '../models/branch_model.dart';
import '../theme/app_theme.dart';

class BranchViewSelector extends StatelessWidget {
  final List<BranchModel> branches;
  final BranchModel? selectedBranch;
  final bool allowAllBranches;
  final String allBranchesLabel;
  final String tooltip;
  final ValueChanged<BranchModel?> onSelected;

  const BranchViewSelector({
    super.key,
    required this.branches,
    required this.selectedBranch,
    required this.allowAllBranches,
    required this.allBranchesLabel,
    required this.tooltip,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final showAllBranches = allowAllBranches && branches.length > 1;
    final label = selectedBranch?.name ?? allBranchesLabel;

    return Center(
      child: PopupMenuButton<_BranchViewSelection>(
        tooltip: tooltip,
        onSelected: (selection) {
          onSelected(selection.branch);
        },
        itemBuilder: (context) {
          return [
            if (showAllBranches)
              CheckedPopupMenuItem<_BranchViewSelection>(
                value: const _BranchViewSelection.all(),
                checked: selectedBranch == null,
                child: Text(allBranchesLabel, overflow: TextOverflow.ellipsis),
              ),
            for (final branch in branches)
              CheckedPopupMenuItem<_BranchViewSelection>(
                value: _BranchViewSelection.branch(branch),
                checked: branch.remoteId == selectedBranch?.remoteId,
                child: Text(branch.name, overflow: TextOverflow.ellipsis),
              ),
          ];
        },
        child: Tooltip(
          message: tooltip,
          child: Material(
            color: AppTheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.storefront_outlined,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.expand_more,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BranchViewSelection {
  final BranchModel? branch;

  const _BranchViewSelection.all() : branch = null;

  const _BranchViewSelection.branch(this.branch);
}
