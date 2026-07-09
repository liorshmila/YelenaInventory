class BranchModel {
  /// Local Drift identifier retained while employees still use local storage.
  final int id;
  final String? remoteId;
  final String? branchCode;
  final String name;

  const BranchModel({
    required this.id,
    this.remoteId,
    this.branchCode,
    required this.name,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as int,
      remoteId: json['remote_id'] as String?,
      branchCode: json['branch_code'] as String?,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remote_id': remoteId,
      'branch_code': branchCode,
      'name': name,
    };
  }

  BranchModel copyWith({
    int? id,
    String? remoteId,
    String? branchCode,
    String? name,
  }) {
    return BranchModel(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      branchCode: branchCode ?? this.branchCode,
      name: name ?? this.name,
    );
  }
}
