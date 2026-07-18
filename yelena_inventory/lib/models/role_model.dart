enum RoleCode {
  developer('developer'),
  systemManager('system_manager'),
  areaManager('area_manager'),
  branchManager('branch_manager'),
  deputyBranchManager('deputy_branch_manager'),
  storeEmployee('store_employee'),
  viewer('viewer');

  final String code;

  const RoleCode(this.code);

  static RoleCode parse(String value) {
    final normalized = value.trim();

    for (final role in RoleCode.values) {
      if (role.code == normalized) {
        return role;
      }
    }

    throw FormatException('Unknown role code: $value');
  }
}

class RoleModel {
  final RoleCode role;

  const RoleModel(this.role);

  factory RoleModel.fromCode(String code) {
    return RoleModel(RoleCode.parse(code));
  }

  String get code => role.code;
}
