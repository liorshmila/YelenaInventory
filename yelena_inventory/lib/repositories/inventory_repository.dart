import 'package:drift/drift.dart';

import '../database/app_database.dart';

class InventoryRepository {
  final AppDatabase db;

  InventoryRepository(this.db);

  // ==========================================
  // Initialization
  // ==========================================

  Future<void> initialize() async {
    await _createDefaultBranch();
    await _createDefaultEmployees();
  }

  Future<void> _createDefaultBranch() async {
    final branches = await db.getBranches();

    if (branches.isEmpty) {
      await db.insertBranch(
        BranchesCompanion.insert(
          name: 'ראשי',
        ),
      );
    }
  }

  Future<void> _createDefaultEmployees() async {
    final employees = await db.getEmployees();

    if (employees.isNotEmpty) return;

    const names = [
      'ילנה',
      'שרית',
      'נופר',
      'אתי',
      'משה',
    ];

    for (final name in names) {
      await db.insertEmployee(
        EmployeesCompanion.insert(
          name: name,
          branchId: 1,
        ),
      );
    }
  }

  // ==========================================
  // Employees
  // ==========================================

  Future<List<Employee>> getEmployees() {
    return db.getEmployees();
  }

  // ==========================================
  // Branches
  // ==========================================

  Future<List<Branche>> getBranches() {
    return db.getBranches();
  }

  // ==========================================
  // Inventory
  // ==========================================

  Future<List<InventoryCount>> getInventory() {
    return db.getInventory();
  }

  Future<void> saveInventory({
  required String barcode,
  required int quantity,
  required int employeeId,
  String note = '',
  }) async {
  await db.insertInventory(
      InventoryCountsCompanion.insert(
      barcode: barcode,
      quantity: quantity,
      employeeId: employeeId,
      branchId: Value(1),
      countDate: DateTime.now(),
      note: Value(note),
      ),
  );
  }

  Future<void> deleteInventory(int id) async {
    await (db.delete(db.inventoryCounts)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<void> updateQuantity({
    required int id,
    required int quantity,
  }) async {
    await (db.update(db.inventoryCounts)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      InventoryCountsCompanion(
        quantity: Value(quantity),
      ),
    );
  }

  Future<int> totalProducts() async {
    final items = await getInventory();

    return items.length;
  }
}