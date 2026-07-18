import 'area_model.dart';
import 'branch_model.dart';
import 'employee_directory_entry_model.dart';
import 'employee_model.dart';
import 'role_assignment_model.dart';
import 'role_model.dart';

class RoleAssignmentManagementAccess {
  final String? actorEmployeeId;
  final Set<RoleCode> assignableRoles;
  final List<AreaModel> allowedAreas;
  final List<BranchModel> allowedBranches;

  const RoleAssignmentManagementAccess({
    required this.actorEmployeeId,
    required this.assignableRoles,
    this.allowedAreas = const [],
    this.allowedBranches = const [],
  });

  const RoleAssignmentManagementAccess.none()
    : actorEmployeeId = null,
      assignableRoles = const {},
      allowedAreas = const [],
      allowedBranches = const [];

  bool get canAddRoleAssignments => assignableRoles.isNotEmpty;

  bool canAssignRole(RoleCode role) {
    return assignableRoles.contains(role);
  }

  bool canUseArea(String areaId) {
    return allowedAreas.any((area) => area.id == areaId);
  }

  bool canUseBranch(String branchId) {
    return allowedBranches.any((branch) => branch.remoteId == branchId);
  }

  bool canManageTarget(EmployeeDirectoryEntryModel target) {
    final actorId = actorEmployeeId;

    if (actorId == null || actorId == target.employee.id) {
      return false;
    }

    if (!target.employee.isActive) {
      return false;
    }

    return !target.hasEffectiveRole(RoleCode.developer);
  }

  bool canAddRoleToTarget(EmployeeDirectoryEntryModel target) {
    return canAddRoleAssignments && canManageTarget(target);
  }

  bool canEndRoleAssignment({
    required EmployeeDirectoryEntryModel target,
    required EmployeeRoleAssignmentDetailModel detail,
    required DateTime at,
  }) {
    if (!canManageTarget(target)) {
      return false;
    }

    final assignment = detail.assignment;
    final role = assignment.role.role;

    if (role == RoleCode.developer || !canAssignRole(role)) {
      return false;
    }

    if (assignment.employeeId == actorEmployeeId) {
      return false;
    }

    if (assignment.statusAt(at) != RoleAssignmentStatus.effective) {
      return false;
    }

    return switch (role) {
      RoleCode.developer => false,
      RoleCode.systemManager => true,
      RoleCode.areaManager => _canUseAssignmentArea(assignment.areaId),
      RoleCode.branchManager ||
      RoleCode.deputyBranchManager ||
      RoleCode.storeEmployee ||
      RoleCode.viewer => _canUseAssignmentBranch(assignment.branchId),
    };
  }

  bool _canUseAssignmentArea(String? areaId) {
    final value = areaId?.trim();

    return value != null && value.isNotEmpty && canUseArea(value);
  }

  bool _canUseAssignmentBranch(String? branchId) {
    final value = branchId?.trim();

    return value != null && value.isNotEmpty && canUseBranch(value);
  }
}

extension EmployeeDirectoryEntryRoleChecks on EmployeeDirectoryEntryModel {
  bool hasEffectiveRole(RoleCode role) {
    return effectiveRoles.any((detail) => detail.assignment.role.role == role);
  }
}

RoleAssignmentManagementAccess roleAssignmentManagementAccessForDeveloper({
  required EmployeeModel actor,
  required List<AreaModel> areas,
  required List<BranchModel> branches,
}) {
  return RoleAssignmentManagementAccess(
    actorEmployeeId: actor.id,
    assignableRoles: const {
      RoleCode.systemManager,
      RoleCode.areaManager,
      RoleCode.branchManager,
      RoleCode.deputyBranchManager,
      RoleCode.storeEmployee,
      RoleCode.viewer,
    },
    allowedAreas: areas,
    allowedBranches: branches,
  );
}

RoleAssignmentManagementAccess roleAssignmentManagementAccessForSystemManager({
  required EmployeeModel actor,
  required List<AreaModel> areas,
  required List<BranchModel> branches,
}) {
  return RoleAssignmentManagementAccess(
    actorEmployeeId: actor.id,
    assignableRoles: const {
      RoleCode.areaManager,
      RoleCode.branchManager,
      RoleCode.deputyBranchManager,
      RoleCode.storeEmployee,
      RoleCode.viewer,
    },
    allowedAreas: areas,
    allowedBranches: branches,
  );
}

RoleAssignmentManagementAccess roleAssignmentManagementAccessForAreaManager({
  required EmployeeModel actor,
  required List<AreaModel> areas,
  required List<BranchModel> branches,
}) {
  return RoleAssignmentManagementAccess(
    actorEmployeeId: actor.id,
    assignableRoles: const {
      RoleCode.branchManager,
      RoleCode.deputyBranchManager,
      RoleCode.storeEmployee,
      RoleCode.viewer,
    },
    allowedAreas: areas,
    allowedBranches: branches,
  );
}

RoleAssignmentManagementAccess roleAssignmentManagementAccessForBranchManager({
  required EmployeeModel actor,
  required BranchModel branch,
}) {
  return RoleAssignmentManagementAccess(
    actorEmployeeId: actor.id,
    assignableRoles: const {
      RoleCode.deputyBranchManager,
      RoleCode.storeEmployee,
      RoleCode.viewer,
    },
    allowedBranches: [branch],
  );
}
