enum EndRoleAssignmentResult {
  ended('ended'),
  alreadyEnded('alreadyEnded'),
  assignmentNotFound('assignmentNotFound'),
  employeeNotFound('employeeNotFound'),
  employeeInactive('employeeInactive'),
  invalidValidity('invalidValidity'),
  unauthorized('unauthorized'),
  selfManagementNotAllowed('selfManagementNotAllowed'),
  protectedRole('protectedRole'),
  operationFailed('operationFailed');

  final String code;

  const EndRoleAssignmentResult(this.code);

  static EndRoleAssignmentResult parse(String value) {
    final normalized = value.trim();

    for (final result in EndRoleAssignmentResult.values) {
      if (result.code == normalized) {
        return result;
      }
    }

    throw FormatException('Unknown end role assignment result: $value');
  }
}
