enum DeactivateEmployeeResult {
  deactivated('deactivated'),
  partiallyDeactivated('partiallyDeactivated'),
  nothingToDeactivate('nothingToDeactivate'),
  employeeNotFound('employeeNotFound'),
  employeeInactive('employeeInactive'),
  protectedRole('protectedRole'),
  selfManagementNotAllowed('selfManagementNotAllowed'),
  unauthorized('unauthorized'),
  operationFailed('operationFailed');

  final String code;

  const DeactivateEmployeeResult(this.code);

  static DeactivateEmployeeResult parse(String value) {
    final normalized = value.trim();

    for (final result in DeactivateEmployeeResult.values) {
      if (result.code == normalized) {
        return result;
      }
    }

    throw FormatException('Unknown deactivate employee result: $value');
  }
}
