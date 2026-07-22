enum UpdateBranchResult {
  updated('updated'),
  nothingChanged('nothingChanged'),
  duplicateName('duplicateName'),
  invalidName('invalidName'),
  branchNotFound('branchNotFound'),
  unauthorized('unauthorized'),
  operationFailed('operationFailed');

  final String code;

  const UpdateBranchResult(this.code);

  static UpdateBranchResult parse(String value) {
    final normalized = value.trim();

    for (final result in UpdateBranchResult.values) {
      if (result.code == normalized) {
        return result;
      }
    }

    throw FormatException('Unknown update branch result: $value');
  }
}
