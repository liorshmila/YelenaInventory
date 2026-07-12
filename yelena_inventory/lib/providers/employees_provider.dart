import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/branch_model.dart';
import '../models/employee_model.dart';
import 'branch_provider.dart';
import 'repository_provider.dart';

final employeesProvider = FutureProvider<List<Employee>>((ref) async {
  final repo = ref.watch(inventoryRepositoryProvider);
  final selectedBranch = ref.watch(selectedBranchProvider);

  await repo.initialize();

  if (selectedBranch == null) {
    return const [];
  }

  return repo.getEmployeesForBranch(selectedBranch.id);
});

final employeesForBranchProvider = FutureProvider.family<List<Employee>, int>((
  ref,
  branchId,
) async {
  final repo = ref.watch(inventoryRepositoryProvider);

  await repo.initialize();

  return repo.getEmployeesForBranch(branchId);
});

final employeeManagementEmployeesProvider =
    FutureProvider.family<List<EmployeeModel>, BranchModel>((
      ref,
      branch,
    ) async {
      final repo = ref.watch(inventoryRepositoryProvider);

      return repo.getEmployeeManagementEmployeesForBranch(branch);
    });

final employeeManagementRealtimeSubscriptionProvider = Provider<void>((ref) {
  final realtimeService = ref.watch(realtimeServiceProvider);
  final employeeSubscription = realtimeService.subscribeToTableChanges(
    channelName: 'public:employees',
    schema: 'public',
    table: 'employees',
    onChange: () {
      ref.invalidate(employeeManagementEmployeesProvider);
    },
  );
  final membershipSubscription = realtimeService.subscribeToTableChanges(
    channelName: 'public:employee_branches',
    schema: 'public',
    table: 'employee_branches',
    onChange: () {
      ref.invalidate(employeeManagementEmployeesProvider);
    },
  );

  ref.onDispose(() {
    unawaited(employeeSubscription.cancel());
    unawaited(membershipSubscription.cancel());
  });
});
