import 'role_model.dart';

class ReplaceRoleAssignmentRequest {
  final String roleAssignmentId;
  final RoleCode roleCode;
  final String? areaId;
  final String? branchId;
  final DateTime? validUntil;

  const ReplaceRoleAssignmentRequest({
    required this.roleAssignmentId,
    required this.roleCode,
    this.areaId,
    this.branchId,
    this.validUntil,
  });
}
