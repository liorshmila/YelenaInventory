import 'package:drift/drift.dart';

import '../../../database/app_database.dart';

abstract interface class InventoryLocalDataSource {
  Future<List<Employee>> getEmployees();

  Future<List<Employee>> getEmployeesForBranch(int branchId);

  Future<Employee?> getEmployeeById(int id);

  Future<int> insertEmployee(EmployeesCompanion employee);

  Future<void> updateEmployee({
    required int id,
    required String name,
    required int branchId,
  });

  Future<int> deleteEmployee(int id);

  Future<List<Branche>> getBranches();

  Future<Branche?> getBranchById(int id);

  Future<int> insertBranch(BranchesCompanion branch);

  Future<void> updateBranchName({required int id, required String name});

  Future<void> deleteBranch(int id);

  Future<List<InventoryCount>> getInventory();

  Future<int> insertInventory(InventoryCountsCompanion row);

  Future<void> deleteInventory(int id);

  Future<void> updateQuantity({required int id, required int quantity});

  Future<ProductImage?> getProductImageForBarcode(String barcode);

  Future<void> upsertProductImage(ProductImagesCompanion row);

  Future<void> deleteProductImageForBarcode(String barcode);
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
  Future<Employee?> getEmployeeById(int id) {
    return _db.getEmployeeById(id);
  }

  @override
  Future<int> insertEmployee(EmployeesCompanion employee) {
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
  Future<int> deleteEmployee(int id) {
    return _db.deleteEmployee(id);
  }

  @override
  Future<List<Branche>> getBranches() {
    return _db.getBranches();
  }

  @override
  Future<Branche?> getBranchById(int id) {
    return _db.getBranchById(id);
  }

  @override
  Future<int> insertBranch(BranchesCompanion branch) {
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
  Future<int> insertInventory(InventoryCountsCompanion row) {
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

  @override
  Future<ProductImage?> getProductImageForBarcode(String barcode) {
    return _db.getProductImageForBarcode(barcode);
  }

  @override
  Future<void> upsertProductImage(ProductImagesCompanion row) {
    return _db.upsertProductImage(row);
  }

  @override
  Future<void> deleteProductImageForBarcode(String barcode) {
    return _db.deleteProductImageForBarcode(barcode);
  }
}
