enum ReplaceRoleAssignmentResult {
  replaced('replaced'),
  unchanged('unchanged'),
  unauthorized('unauthorized'),
  assignmentNotFound('assignmentNotFound'),
  employeeNotFound('employeeNotFound'),
  employeeInactive('employeeInactive'),
  protectedRole('protectedRole'),
  alreadyEnded('alreadyEnded'),
  invalidRole('invalidRole'),
  invalidScope('invalidScope'),
  invalidValidity('invalidValidity'),
  duplicateAssignment('duplicateAssignment'),
  overlappingAssignment('overlappingAssignment'),
  operationFailed('operationFailed');

  final String code;

  const ReplaceRoleAssignmentResult(this.code);

  static ReplaceRoleAssignmentResult parse(String value) {
    final normalized = value.trim();

    for (final result in ReplaceRoleAssignmentResult.values) {
      if (result.code == normalized) {
        return result;
      }
    }

    throw FormatException('Unknown replace role assignment result: $value');
  }
}
