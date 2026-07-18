import 'employee_creation_access.dart';
import 'role_model.dart';

class CreateEmployeeRequest {
  final String name;
  final String phone;
  final RoleCode role;
  final String? areaId;
  final String? branchId;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final EmployeeCreationAccess access;

  const CreateEmployeeRequest({
    required this.name,
    required this.phone,
    required this.role,
    this.areaId,
    this.branchId,
    this.validFrom,
    this.validUntil,
    required this.access,
  });
}
