import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../models/branch_model.dart';
import '../models/role_assignment_model.dart';
import '../models/role_model.dart';
import '../providers/current_session_provider.dart';

class CurrentUserHeader extends ConsumerWidget {
  final BranchModel? selectedBranch;

  const CurrentUserHeader({super.key, this.selectedBranch});

  static const Color _accent = Color(0xFF6D28D9);
  static const Color _accentBackground = Color(0xFFF5F0FF);
  static const Color _accentBorder = Color(0xFFE9D5FF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = ref.watch(currentEmployeeProvider);
    final assignments = ref.watch(activeRoleAssignmentsProvider);
    final strings = ref.watch(appStringsProvider);

    if (employee == null) {
      return const SizedBox.shrink();
    }

    final role = _displayRole(
      assignments: assignments,
      selectedBranch: selectedBranch,
    );

    return Material(
      color: _accentBackground,
      borderRadius: BorderRadius.circular(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _accentBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_circle_outlined,
                  color: _accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  employee.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (role != null) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _roleLabel(role, strings),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  RoleCode? _displayRole({
    required List<RoleAssignmentModel> assignments,
    required BranchModel? selectedBranch,
  }) {
    final now = DateTime.now().toUtc();
    final applicableRoles =
        assignments
            .where((assignment) => assignment.isEffectiveAt(now))
            .where(
              (assignment) => _appliesToContext(assignment, selectedBranch),
            )
            .map((assignment) => assignment.role.role)
            .toSet()
            .toList()
          ..sort(
            (first, second) => RoleCode.values
                .indexOf(first)
                .compareTo(RoleCode.values.indexOf(second)),
          );

    return applicableRoles.isEmpty ? null : applicableRoles.first;
  }

  bool _appliesToContext(
    RoleAssignmentModel assignment,
    BranchModel? selectedBranch,
  ) {
    if (selectedBranch == null) {
      return true;
    }

    final branchId = selectedBranch.remoteId;
    final areaId = selectedBranch.areaId;

    return switch (assignment.role.role) {
      RoleCode.developer || RoleCode.systemManager => true,
      RoleCode.areaManager =>
        areaId != null && assignment.areaId?.trim() == areaId,
      RoleCode.branchManager ||
      RoleCode.deputyBranchManager ||
      RoleCode.storeEmployee ||
      RoleCode.viewer => branchId != null && assignment.branchId == branchId,
    };
  }

  String _roleLabel(RoleCode role, AppStrings strings) {
    return switch (role) {
      RoleCode.developer => strings.roleDeveloper,
      RoleCode.systemManager => strings.roleSystemManager,
      RoleCode.areaManager => strings.roleAreaManager,
      RoleCode.branchManager => strings.roleBranchManager,
      RoleCode.deputyBranchManager => strings.roleDeputyBranchManager,
      RoleCode.storeEmployee => strings.roleStoreEmployee,
      RoleCode.viewer => strings.roleViewer,
    };
  }
}
