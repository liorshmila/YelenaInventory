import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../repositories/inventory_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final inventoryRepositoryProvider =
    Provider<InventoryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);

  return InventoryRepository(db);
});