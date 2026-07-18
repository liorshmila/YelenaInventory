import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/current_session_model.dart';
import '../models/role_assignment_management_access.dart';
import '../models/role_model.dart';
import 'current_session_provider.dart';
import 'repository_provider.dart';

final roleAssignmentManagementAccessProvider =
    FutureProvider<RoleAssignmentManagementAccess>((ref) async {
      final session = ref.watch(currentSessionProvider);
      final actor = session.employee;

      if (session.status != CurrentSessionStatus.ready || actor == null) {
        return const RoleAssignmentManagementAccess.none();
      }

      final assignments = session.activeRoleAssignments;
      final repository = ref.watch(inventoryRepositoryProvider);

      if (assignments.any(
        (assignment) => assignment.role.role == RoleCode.developer,
      )) {
        return roleAssignmentManagementAccessForDeveloper(
          actor: actor,
          areas: await repository.getActiveAreas(),
          branches: await repository.getBranches(),
        );
      }

      if (assignments.any(
        (assignment) => assignment.role.role == RoleCode.systemManager,
      )) {
        return roleAssignmentManagementAccessForSystemManager(
          actor: actor,
          areas: await repository.getActiveAreas(),
          branches: await repository.getBranches(),
        );
      }

      final areaIds = assignments
          .where((assignment) => assignment.role.role == RoleCode.areaManager)
          .map((assignment) => assignment.areaId?.trim())
          .whereType<String>()
          .where((areaId) => areaId.isNotEmpty)
          .toSet();

      if (areaIds.isNotEmpty) {
        final allAreas = await repository.getActiveAreas();
        final allowedAreas = allAreas
            .where((area) => areaIds.contains(area.id))
            .toList(growable: false);
        final allowedBranches = await repository.getActiveBranchesForAreaIds(
          areaIds,
        );

        return roleAssignmentManagementAccessForAreaManager(
          actor: actor,
          areas: allowedAreas,
          branches: allowedBranches,
        );
      }

      final currentBranch = session.currentBranch;
      final currentBranchId = currentBranch?.remoteId;
      final canManageCurrentBranch =
          currentBranch != null &&
          currentBranchId != null &&
          assignments.any((assignment) {
            return assignment.role.role == RoleCode.branchManager &&
                assignment.branchId == currentBranchId;
          });

      if (canManageCurrentBranch) {
        return roleAssignmentManagementAccessForBranchManager(
          actor: actor,
          branch: currentBranch,
        );
      }

      return const RoleAssignmentManagementAccess.none();
    });
