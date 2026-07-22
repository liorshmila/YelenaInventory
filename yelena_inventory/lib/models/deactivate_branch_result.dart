enum DeactivateBranchResult {
  deactivated('deactivated'),
  alreadyInactive('alreadyInactive'),
  branchNotFound('branchNotFound'),
  unauthorized('unauthorized'),
  operationFailed('operationFailed');

  final String code;

  const DeactivateBranchResult(this.code);

  static DeactivateBranchResult parse(String value) {
    final normalized = value.trim();

    for (final result in DeactivateBranchResult.values) {
      if (result.code == normalized) {
        return result;
      }
    }

    throw FormatException('Unknown deactivate branch result: $value');
  }
}
