import 'area_model.dart';
import 'branch_model.dart';
import 'employee_model.dart';
import 'role_assignment_model.dart';

class EmployeeRoleAssignmentDetailModel {
  final RoleAssignmentModel assignment;
  final BranchModel? branch;
  final AreaModel? area;

  const EmployeeRoleAssignmentDetailModel({
    required this.assignment,
    this.branch,
    this.area,
  });
}

class EmployeeDirectoryEntryModel {
  final EmployeeModel employee;
  final List<EmployeeRoleAssignmentDetailModel> effectiveRoles;
  final List<EmployeeRoleAssignmentDetailModel> roleHistory;
  final List<BranchModel> accessibleBranches;
  final List<AreaModel> accessibleAreas;

  const EmployeeDirectoryEntryModel({
    required this.employee,
    required this.effectiveRoles,
    this.roleHistory = const [],
    required this.accessibleBranches,
    required this.accessibleAreas,
  });
}
