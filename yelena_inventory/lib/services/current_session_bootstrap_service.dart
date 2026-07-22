import 'package:flutter/foundation.dart';

import '../models/branch_model.dart';
import '../models/current_session_model.dart';
import '../models/employee_model.dart';
import '../models/role_assignment_model.dart';
import '../providers/current_session_provider.dart';
import '../repositories/inventory_repository.dart';
import 'current_branch_storage.dart';

class CurrentSessionBootstrapService {
  final InventoryRepository _repository;
  final CurrentBranchStorage _currentBranchStorage;
  final CurrentSessionController _sessionController;

  const CurrentSessionBootstrapService(
    this._repository,
    this._currentBranchStorage,
    this._sessionController,
  );

  Future<void> bootstrapForAuthenticatedUser(String authenticatedUserId) async {
    final normalizedAuthUserId = authenticatedUserId.trim();

    _sessionController.setLoading();

    if (normalizedAuthUserId.isEmpty) {
      debugPrint(
        'Current session bootstrap failed: authenticated user ID is empty.',
      );
      _sessionController.setError(
        errorCode: CurrentSessionErrorCode.sessionLoadFailed,
        authenticatedUserId: authenticatedUserId,
      );
      return;
    }

    EmployeeModel? employee;
    var activeRoleAssignments = <RoleAssignmentModel>[];
    var accessibleBranches = <BranchModel>[];

    try {
      employee = await _repository.getEmployeeByAuthUserId(
        normalizedAuthUserId,
      );

      if (employee == null) {
        debugPrint(
          'Current session bootstrap failed: no employee is linked to '
          'auth_user_id $normalizedAuthUserId.',
        );
        _sessionController.setError(
          errorCode: CurrentSessionErrorCode.employeeNotLinked,
          authenticatedUserId: normalizedAuthUserId,
        );
        return;
      }

      if (!employee.isActive) {
        _sessionController.setNoActivePermission(
          authenticatedUserId: normalizedAuthUserId,
          employee: employee,
        );
        return;
      }

      final evaluationTimeUtc = DateTime.now().toUtc();
      activeRoleAssignments = await _repository
          .getEffectiveRoleAssignmentsForEmployee(
            employeeId: employee.id,
            evaluationTimeUtc: evaluationTimeUtc,
          );

      accessibleBranches = await _repository
          .getAccessibleBranchesForAssignments(activeRoleAssignments);

      if (accessibleBranches.isEmpty) {
        _sessionController.setNoActivePermission(
          authenticatedUserId: normalizedAuthUserId,
          employee: employee,
          activeRoleAssignments: activeRoleAssignments,
        );
        return;
      }

      final currentBranch = accessibleBranches.first;
      final branchCode = currentBranch.branchCode?.trim();

      if (branchCode == null || branchCode.isEmpty) {
        debugPrint(
          'Current session bootstrap failed: first accessible branch '
          'is missing branch_code.',
        );
        _sessionController.setError(
          errorCode: CurrentSessionErrorCode.sessionLoadFailed,
          authenticatedUserId: normalizedAuthUserId,
          employee: employee,
          activeRoleAssignments: activeRoleAssignments,
          accessibleBranches: accessibleBranches,
        );
        return;
      }

      await _currentBranchStorage.saveLastBranchCode(branchCode);

      _sessionController.setReady(
        authenticatedUserId: normalizedAuthUserId,
        employee: employee,
        activeRoleAssignments: activeRoleAssignments,
        accessibleBranches: accessibleBranches,
        currentBranch: currentBranch,
      );
    } catch (error, stackTrace) {
      debugPrint('Current session bootstrap failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      _sessionController.setError(
        errorCode: CurrentSessionErrorCode.sessionLoadFailed,
        authenticatedUserId: normalizedAuthUserId,
        employee: employee,
        activeRoleAssignments: activeRoleAssignments,
        accessibleBranches: accessibleBranches,
      );
    }
  }
}
