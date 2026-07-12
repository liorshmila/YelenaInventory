class EmployeeModel {
  final String id;
  final String employeeCode;
  final String name;
  final String phone;
  final bool isActive;
  final String branchId;
  final String membershipId;

  const EmployeeModel({
    required this.id,
    required this.employeeCode,
    required this.name,
    required this.phone,
    required this.isActive,
    required this.branchId,
    required this.membershipId,
  });
}
