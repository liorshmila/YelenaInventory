import 'package:drift/drift.dart';

import '../../../database/app_database.dart';

abstract interface class InventoryLocalDataSource {
  Future<List<Employee>> getEmployees();

  Future<List<Employee>> getEmployeesForBranch(int branchId);

  Future<void> insertEmployee(EmployeesCompanion employee);

  Future<void> updateEmployee({
    required int id,
    required String name,
    required int branchId,
  });

  Future<void> deleteEmployee(int id);

  Future<List<Branche>> getBranches();

  Future<void> insertBranch(BranchesCompanion branch);

  Future<void> updateBranchName({required int id, required String name});

  Future<void> deleteBranch(int id);

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
  Future<List<Employee>> getEmployeesForBranch(int branchId) {
    return _db.getEmployeesForBranch(branchId);
  }

  @override
  Future<void> insertEmployee(EmployeesCompanion employee) {
    return _db.insertEmployee(employee);
  }

  @override
  Future<void> updateEmployee({
    required int id,
    required String name,
    required int branchId,
  }) {
    return _db.updateEmployee(id: id, name: name, branchId: branchId);
  }

  @override
  Future<void> deleteEmployee(int id) {
    return _db.deleteEmployee(id);
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
  Future<void> updateBranchName({required int id, required String name}) {
    return _db.updateBranchName(id: id, name: name);
  }

  @override
  Future<void> deleteBranch(int id) {
    return _db.deleteBranch(id);
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
