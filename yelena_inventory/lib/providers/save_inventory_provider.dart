import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'inventory_db_provider.dart';
import 'repository_provider.dart';

final saveInventoryProvider = Provider((ref) {
  return (String barcode, int quantity, int employeeId) async {
    final repo = ref.read(inventoryRepositoryProvider);

    await repo.saveInventory(
      barcode: barcode,
      quantity: quantity,
      employeeId: employeeId,
    );

    ref.invalidate(inventoryDbProvider);
  };
});
