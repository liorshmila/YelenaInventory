import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import 'repository_provider.dart';

final inventoryDbProvider =
    FutureProvider<List<InventoryCount>>((ref) async {
  final repo = ref.watch(inventoryRepositoryProvider);

  return repo.getInventory();
});