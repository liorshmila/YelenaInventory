import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import 'repository_provider.dart';

final employeesProvider =
    FutureProvider<List<Employee>>((ref) async {
  final repo = ref.watch(inventoryRepositoryProvider);

  await repo.initialize();

  return repo.getEmployees();
});