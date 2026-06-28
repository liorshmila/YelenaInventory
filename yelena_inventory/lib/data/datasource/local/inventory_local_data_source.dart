import 'package:drift/drift.dart';

import '../../../database/app_database.dart';

abstract interface class InventoryLocalDataSource {
  Future<List<Employee>> getEmployees();

  Future<void> insertEmployee(EmployeesCompanion employee);

  Future<List<Branche>> getBranches();

  Future<void> insertBranch(BranchesCompanion branch);

  Future<List<InventoryCount>> getInventory();

  Future<void> insertInventory(InventoryCountsCompanion row);

  Future<void> deleteInventory(int id);

  Future<void> updateQuantity({required int id, required int quantity});
}

class DriftInventoryLocalDataSource implements InventoryLocalDataSource {
  final AppDatabase _db;

  DriftInventoryLocalDataSource(this._db);

  @override
  Future<List<Employee>> getEmployees() {
    return _db.getEmployees();
  }

  @override
  Future<void> insertEmployee(EmployeesCompanion employee) {
    return _db.insertEmployee(employee);
  }

  @override
  Future<List<Branche>> getBranches() {
    return _db.getBranches();
  }

  @override
  Future<void> insertBranch(BranchesCompanion branch) {
    return _db.insertBranch(branch);
  }

  @override
  Future<List<InventoryCount>> getInventory() {
    return _db.getInventory();
  }

  @override
  Future<void> insertInventory(InventoryCountsCompanion row) {
    return _db.insertInventory(row);
  }

  @override
  Future<void> deleteInventory(int id) async {
    await (_db.delete(
      _db.inventoryCounts,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> updateQuantity({required int id, required int quantity}) async {
    await (_db.update(_db.inventoryCounts)..where((tbl) => tbl.id.equals(id)))
        .write(InventoryCountsCompanion(quantity: Value(quantity)));
  }
}
