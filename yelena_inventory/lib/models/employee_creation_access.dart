import 'area_model.dart';
import 'branch_model.dart';
import 'role_model.dart';

class EmployeeCreationAccess {
  final Set<RoleCode> assignableRoles;
  final List<AreaModel> allowedAreas;
  final List<BranchModel> allowedBranches;

  const EmployeeCreationAccess({
    required this.assignableRoles,
    this.allowedAreas = const [],
    this.allowedBranches = const [],
  });

  bool get canCreateEmployees => assignableRoles.isNotEmpty;

  bool canAssignRole(RoleCode role) {
    return assignableRoles.contains(role);
  }

  bool canUseArea(String areaId) {
    return allowedAreas.any((area) => area.id == areaId);
  }

  bool canUseBranch(String branchId) {
    return allowedBranches.any((branch) => branch.remoteId == branchId);
  }
}
