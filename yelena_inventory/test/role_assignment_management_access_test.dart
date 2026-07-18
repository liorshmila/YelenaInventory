import 'package:flutter_test/flutter_test.dart';
import 'package:yelena_inventory/models/branch_model.dart';
import 'package:yelena_inventory/models/employee_directory_entry_model.dart';
import 'package:yelena_inventory/models/employee_model.dart';
import 'package:yelena_inventory/models/role_assignment_management_access.dart';
import 'package:yelena_inventory/models/role_assignment_model.dart';
import 'package:yelena_inventory/models/role_model.dart';

void main() {
  group('RoleAssignmentManagementAccess', () {
    test('does not allow self-management', () {
      final actor = _employee('employee-1');
      final target = _entry(actor);
      final access = roleAssignmentManagementAccessForBranchManager(
        actor: actor,
        branch: const BranchModel(
          id: 1,
          remoteId: 'branch-1',
          branchCode: 'B001',
          name: 'Branch',
        ),
      );

      expect(access.canAddRoleToTarget(target), isFalse);
    });

    test(
      'does not allow managing an employee with an effective developer role',
      () {
        final actor = _employee('employee-1');
        final target = _entry(
          _employee('employee-2'),
          roles: [RoleCode.developer],
        );
        final access = roleAssignmentManagementAccessForSystemManager(
          actor: actor,
          areas: const [],
          branches: const [],
        );

        expect(access.canAddRoleToTarget(target), isFalse);
      },
    );

    test(
      'allows branch manager to end supported current-branch assignment',
      () {
        final actor = _employee('employee-1');
        final target = _entry(
          _employee('employee-2'),
          roles: [RoleCode.storeEmployee],
          branchId: 'branch-1',
        );
        final access = roleAssignmentManagementAccessForBranchManager(
          actor: actor,
          branch: const BranchModel(
            id: 1,
            remoteId: 'branch-1',
            branchCode: 'B001',
            name: 'Branch',
          ),
        );

        expect(
          access.canEndRoleAssignment(
            target: target,
            detail: target.effectiveRoles.single,
            at: DateTime.utc(2026, 7, 16),
          ),
          isTrue,
        );
      },
    );

    test('does not allow branch manager to end branch manager assignment', () {
      final actor = _employee('employee-1');
      final target = _entry(
        _employee('employee-2'),
        roles: [RoleCode.branchManager],
        branchId: 'branch-1',
      );
      final access = roleAssignmentManagementAccessForBranchManager(
        actor: actor,
        branch: const BranchModel(
          id: 1,
          remoteId: 'branch-1',
          branchCode: 'B001',
          name: 'Branch',
        ),
      );

      expect(
        access.canEndRoleAssignment(
          target: target,
          detail: target.effectiveRoles.single,
          at: DateTime.utc(2026, 7, 16),
        ),
        isFalse,
      );
    });
  });
}

EmployeeModel _employee(String id) {
  return EmployeeModel(
    id: id,
    employeeCode: 'EMP',
    name: 'Employee',
    phone: '054-1234567',
    isActive: true,
  );
}

EmployeeDirectoryEntryModel _entry(
  EmployeeModel employee, {
  List<RoleCode> roles = const [],
  String? branchId,
}) {
  final now = DateTime.utc(2026);

  return EmployeeDirectoryEntryModel(
    employee: employee,
    effectiveRoles: [
      for (final role in roles)
        EmployeeRoleAssignmentDetailModel(
          assignment: RoleAssignmentModel(
            id: 'assignment-${role.code}',
            employeeId: employee.id,
            role: RoleModel(role),
            branchId: branchId,
            isActive: true,
            createdAt: now,
            updatedAt: now,
          ),
        ),
    ],
    accessibleBranches: const [],
    accessibleAreas: const [],
  );
}
