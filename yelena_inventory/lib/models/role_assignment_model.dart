import 'role_model.dart';

enum RoleAssignmentStatus { effective, future, expired, inactive }

class RoleAssignmentModel {
  final String id;
  final String employeeId;
  final RoleModel role;
  final String? areaId;
  final String? branchId;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RoleAssignmentModel({
    required this.id,
    required this.employeeId,
    required this.role,
    this.areaId,
    this.branchId,
    this.validFrom,
    this.validUntil,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  bool isEffectiveAt(DateTime value) {
    return statusAt(value) == RoleAssignmentStatus.effective;
  }

  RoleAssignmentStatus statusAt(DateTime value) {
    final startsAt = validFrom;
    final endsAt = validUntil;

    if (!isActive) {
      return RoleAssignmentStatus.inactive;
    }

    if (startsAt != null && value.isBefore(startsAt)) {
      return RoleAssignmentStatus.future;
    }

    if (endsAt != null && value.isAfter(endsAt)) {
      return RoleAssignmentStatus.expired;
    }

    return RoleAssignmentStatus.effective;
  }
}
