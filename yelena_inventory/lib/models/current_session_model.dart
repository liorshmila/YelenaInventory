import 'branch_model.dart';
import 'employee_model.dart';
import 'role_assignment_model.dart';

enum CurrentSessionStatus {
  loading,
  unauthenticated,
  needsBranchSelection,
  ready,
  noActivePermission,
  error,
}

enum CurrentSessionErrorCode {
  employeeNotLinked,
  employeeLinkingConflict,
  sessionLoadFailed,
}

class CurrentSessionModel {
  final String? authenticatedUserId;
  final EmployeeModel? employee;
  final List<RoleAssignmentModel> activeRoleAssignments;
  final List<BranchModel> accessibleBranches;
  final BranchModel? currentBranch;
  final CurrentSessionStatus status;
  final CurrentSessionErrorCode? errorCode;

  CurrentSessionModel({
    this.authenticatedUserId,
    this.employee,
    Iterable<RoleAssignmentModel> activeRoleAssignments = const [],
    Iterable<BranchModel> accessibleBranches = const [],
    this.currentBranch,
    required this.status,
    this.errorCode,
  }) : activeRoleAssignments = List.unmodifiable(activeRoleAssignments),
       accessibleBranches = List.unmodifiable(accessibleBranches) {
    assert(
      (status == CurrentSessionStatus.error) == (errorCode != null),
      'errorCode must be set only for error sessions.',
    );
  }
}
