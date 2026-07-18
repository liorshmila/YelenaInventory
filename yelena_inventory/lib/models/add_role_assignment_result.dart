enum AddRoleAssignmentResult {
  created('created'),
  assignmentNotFound('assignmentNotFound'),
  employeeNotFound('employeeNotFound'),
  employeeInactive('employeeInactive'),
  invalidRole('invalidRole'),
  invalidScope('invalidScope'),
  invalidValidity('invalidValidity'),
  duplicateAssignment('duplicateAssignment'),
  overlappingAssignment('overlappingAssignment'),
  unauthorized('unauthorized'),
  selfManagementNotAllowed('selfManagementNotAllowed'),
  protectedRole('protectedRole'),
  operationFailed('operationFailed');

  final String code;

  const AddRoleAssignmentResult(this.code);

  static AddRoleAssignmentResult parse(String value) {
    final normalized = value.trim();

    for (final result in AddRoleAssignmentResult.values) {
      if (result.code == normalized) {
        return result;
      }
    }

    throw FormatException('Unknown add role assignment result: $value');
  }
}
