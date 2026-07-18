enum CreateEmployeeResult {
  created('created'),
  duplicatePhone('duplicatePhone'),
  duplicateEmployeeCode('duplicateEmployeeCode'),
  invalidRole('invalidRole'),
  invalidScope('invalidScope'),
  unauthorized('unauthorized'),
  employeeCreationFailed('employeeCreationFailed'),
  assignmentCreationFailed('assignmentCreationFailed'),
  operationFailed('operationFailed');

  final String code;

  const CreateEmployeeResult(this.code);

  static CreateEmployeeResult parse(String value) {
    final normalized = value.trim();

    for (final result in CreateEmployeeResult.values) {
      if (result.code == normalized) {
        return result;
      }
    }

    throw FormatException('Unknown create employee result: $value');
  }
}
