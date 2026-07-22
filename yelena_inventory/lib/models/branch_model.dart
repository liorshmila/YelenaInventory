class BranchModel {
  /// Local Drift identifier retained while employees still use local storage.
  final int id;
  final String? remoteId;
  final String? branchCode;
  final String? areaId;
  final String name;

  const BranchModel({
    required this.id,
    this.remoteId,
    this.branchCode,
    this.areaId,
    required this.name,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as int,
      remoteId: json['remote_id'] as String?,
      branchCode: json['branch_code'] as String?,
      areaId: json['area_id'] as String?,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remote_id': remoteId,
      'branch_code': branchCode,
      'area_id': areaId,
      'name': name,
    };
  }

  BranchModel copyWith({
    int? id,
    String? remoteId,
    String? branchCode,
    String? areaId,
    String? name,
  }) {
    return BranchModel(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      branchCode: branchCode ?? this.branchCode,
      areaId: areaId ?? this.areaId,
      name: name ?? this.name,
    );
  }
}
