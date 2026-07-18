import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/branch_model.dart';
import '../models/current_session_model.dart';
import '../models/employee_model.dart';
import '../models/role_assignment_model.dart';
import '../services/current_branch_storage.dart';
import '../services/current_session_bootstrap_service.dart';
import 'repository_provider.dart';

final currentSessionProvider =
    NotifierProvider<CurrentSessionController, CurrentSessionModel>(
      CurrentSessionController.new,
    );

final currentEmployeeProvider = Provider<EmployeeModel?>((ref) {
  return ref.watch(currentSessionProvider).employee;
});

final currentBranchProvider = Provider<BranchModel?>((ref) {
  return ref.watch(currentSessionProvider).currentBranch;
});

final accessibleBranchesProvider = Provider<List<BranchModel>>((ref) {
  return ref.watch(currentSessionProvider).accessibleBranches;
});

final activeRoleAssignmentsProvider = Provider<List<RoleAssignmentModel>>((
  ref,
) {
  return ref.watch(currentSessionProvider).activeRoleAssignments;
});

final currentSessionStatusProvider = Provider<CurrentSessionStatus>((ref) {
  return ref.watch(currentSessionProvider).status;
});

final currentSessionBootstrapServiceProvider =
    Provider<CurrentSessionBootstrapService>((ref) {
      return CurrentSessionBootstrapService(
        ref.watch(inventoryRepositoryProvider),
        CurrentBranchStorage(),
        ref.read(currentSessionProvider.notifier),
      );
    });

class CurrentSessionController extends Notifier<CurrentSessionModel> {
  final CurrentBranchStorage _currentBranchStorage = CurrentBranchStorage();

  @override
  CurrentSessionModel build() {
    return CurrentSessionModel(status: CurrentSessionStatus.loading);
  }

  void setLoading() {
    state = CurrentSessionModel(status: CurrentSessionStatus.loading);
  }

  void setUnauthenticated() {
    state = CurrentSessionModel(status: CurrentSessionStatus.unauthenticated);
  }

  void setNoActivePermission({
    String? authenticatedUserId,
    EmployeeModel? employee,
    Iterable<RoleAssignmentModel> activeRoleAssignments = const [],
    Iterable<BranchModel> accessibleBranches = const [],
  }) {
    state = CurrentSessionModel(
      authenticatedUserId: authenticatedUserId,
      employee: employee,
      activeRoleAssignments: activeRoleAssignments,
      accessibleBranches: accessibleBranches,
      status: CurrentSessionStatus.noActivePermission,
    );
  }

  void setNeedsBranchSelection({
    String? authenticatedUserId,
    required EmployeeModel employee,
    required Iterable<RoleAssignmentModel> activeRoleAssignments,
    required Iterable<BranchModel> accessibleBranches,
  }) {
    state = CurrentSessionModel(
      authenticatedUserId: authenticatedUserId,
      employee: employee,
      activeRoleAssignments: activeRoleAssignments,
      accessibleBranches: accessibleBranches,
      status: CurrentSessionStatus.needsBranchSelection,
    );
  }

  void setReady({
    String? authenticatedUserId,
    required EmployeeModel employee,
    required Iterable<RoleAssignmentModel> activeRoleAssignments,
    required Iterable<BranchModel> accessibleBranches,
    required BranchModel currentBranch,
  }) {
    state = CurrentSessionModel(
      authenticatedUserId: authenticatedUserId,
      employee: employee,
      activeRoleAssignments: activeRoleAssignments,
      accessibleBranches: accessibleBranches,
      currentBranch: currentBranch,
      status: CurrentSessionStatus.ready,
    );
  }

  void setError({
    required CurrentSessionErrorCode errorCode,
    String? authenticatedUserId,
    EmployeeModel? employee,
    Iterable<RoleAssignmentModel> activeRoleAssignments = const [],
    Iterable<BranchModel> accessibleBranches = const [],
    BranchModel? currentBranch,
  }) {
    state = CurrentSessionModel(
      authenticatedUserId: authenticatedUserId,
      employee: employee,
      activeRoleAssignments: activeRoleAssignments,
      accessibleBranches: accessibleBranches,
      currentBranch: currentBranch,
      status: CurrentSessionStatus.error,
      errorCode: errorCode,
    );
  }

  Future<void> selectCurrentBranch(BranchModel branch) async {
    final branchCode = branch.branchCode?.trim();

    if (branchCode == null || branchCode.isEmpty) {
      throw StateError('Selected branch is missing a branch code.');
    }

    final accessibleBranch = _findAccessibleBranchByCode(branchCode);

    if (accessibleBranch == null) {
      throw StateError('Selected branch is not accessible.');
    }

    await _currentBranchStorage.saveLastBranchCode(branchCode);

    state = CurrentSessionModel(
      authenticatedUserId: state.authenticatedUserId,
      employee: state.employee,
      activeRoleAssignments: state.activeRoleAssignments,
      accessibleBranches: state.accessibleBranches,
      currentBranch: accessibleBranch,
      status: CurrentSessionStatus.ready,
    );
  }

  Future<void> clearSession() async {
    await _currentBranchStorage.clearLastBranchCode();
    setUnauthenticated();
  }

  BranchModel? _findAccessibleBranchByCode(String branchCode) {
    for (final branch in state.accessibleBranches) {
      if (branch.branchCode?.trim() == branchCode) {
        return branch;
      }
    }

    return null;
  }
}
