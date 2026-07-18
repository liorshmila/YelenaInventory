class EmployeeModel {
  final String id;
  final String employeeCode;
  final String name;
  final String phone;
  final String? authUserId;
  final bool isActive;

  const EmployeeModel({
    required this.id,
    required this.employeeCode,
    required this.name,
    required this.phone,
    this.authUserId,
    required this.isActive,
  });
}
