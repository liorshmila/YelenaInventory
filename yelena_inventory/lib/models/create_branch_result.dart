enum CreateBranchResult {
  created('created'),
  reactivated('reactivated'),
  duplicateName('duplicateName'),
  invalidName('invalidName'),
  unauthorized('unauthorized'),
  operationFailed('operationFailed');

  final String code;

  const CreateBranchResult(this.code);

  static CreateBranchResult parse(String value) {
    final normalized = value.trim();

    for (final result in CreateBranchResult.values) {
      if (result.code == normalized) {
        return result;
      }
    }

    throw FormatException('Unknown create branch result: $value');
  }
}
