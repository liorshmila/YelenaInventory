import 'package:flutter_test/flutter_test.dart';
import 'package:yelena_inventory/models/role_assignment_model.dart';
import 'package:yelena_inventory/models/role_model.dart';

void main() {
  group('RoleAssignmentModel.statusAt', () {
    final now = DateTime.utc(2026, 7, 16, 12);

    test('returns effective for active assignment inside validity window', () {
      final assignment = _assignment(
        validFrom: now.subtract(const Duration(days: 1)),
        validUntil: now.add(const Duration(days: 1)),
      );

      expect(assignment.statusAt(now), RoleAssignmentStatus.effective);
      expect(assignment.isEffectiveAt(now), isTrue);
    });

    test('returns future before validFrom', () {
      final assignment = _assignment(
        validFrom: now.add(const Duration(days: 1)),
      );

      expect(assignment.statusAt(now), RoleAssignmentStatus.future);
    });

    test('returns expired after validUntil', () {
      final assignment = _assignment(
        validUntil: now.subtract(const Duration(days: 1)),
      );

      expect(assignment.statusAt(now), RoleAssignmentStatus.expired);
    });

    test('returns inactive when assignment is inactive', () {
      final assignment = _assignment(isActive: false);

      expect(assignment.statusAt(now), RoleAssignmentStatus.inactive);
    });
  });
}

RoleAssignmentModel _assignment({
  DateTime? validFrom,
  DateTime? validUntil,
  bool isActive = true,
}) {
  final now = DateTime.utc(2026);

  return RoleAssignmentModel(
    id: 'assignment-id',
    employeeId: 'employee-id',
    role: const RoleModel(RoleCode.storeEmployee),
    validFrom: validFrom,
    validUntil: validUntil,
    isActive: isActive,
    createdAt: now,
    updatedAt: now,
  );
}
