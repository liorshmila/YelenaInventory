import 'role_model.dart';

class AddRoleAssignmentRequest {
  final String targetEmployeeId;
  final RoleCode roleCode;
  final String? areaId;
  final String? branchId;
  final DateTime? validFrom;
  final DateTime? validUntil;

  const AddRoleAssignmentRequest({
    required this.targetEmployeeId,
    required this.roleCode,
    this.areaId,
    this.branchId,
    this.validFrom,
    this.validUntil,
  });
}
