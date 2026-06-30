import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
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
