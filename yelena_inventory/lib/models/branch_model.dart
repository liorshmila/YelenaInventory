class BranchModel {
  final int id;
  final String name;

  const BranchModel({
    required this.id,
    required this.name,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  BranchModel copyWith({
    int? id,
    String? name,
  }) {
    return BranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}