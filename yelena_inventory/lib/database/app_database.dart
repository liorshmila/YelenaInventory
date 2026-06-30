import 'package:drift/drift.dart';

import 'connection/connection.dart';
import 'tables/branches.dart';
import 'tables/employees.dart';
import 'tables/inventory_counts.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Branches, Employees, InventoryCounts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  // ---------- Employees ----------

  Future<List<Employee>> getEmployees() {
    return select(employees).get();
  }

  Future<List<Employee>> getEmployeesForBranch(int branchId) {
    return (select(employees)
          ..where((tbl) => tbl.branchId.equals(branchId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<void> insertEmployee(EmployeesCompanion employee) {
    return into(employees).insert(employee);
  }

  Future<void> updateEmployee({
    required int id,
    required String name,
    required int branchId,
  }) {
    return (update(employees)..where((tbl) => tbl.id.equals(id))).write(
      EmployeesCompanion(name: Value(name), branchId: Value(branchId)),
    );
  }

  Future<void> deleteEmployee(int id) {
    return (delete(employees)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ---------- Branches ----------

  Future<List<Branche>> getBranches() {
    return select(branches).get();
  }

  Future<void> insertBranch(BranchesCompanion branch) {
    return into(branches).insert(branch);
  }

  Future<void> updateBranchName({required int id, required String name}) {
    return (update(branches)..where((tbl) => tbl.id.equals(id))).write(
      BranchesCompanion(name: Value(name)),
    );
  }

  Future<void> deleteBranch(int id) {
    return (delete(branches)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ---------- Inventory ----------

  Future<List<InventoryCount>> getInventory() {
    return select(inventoryCounts).get();
  }

  Future<void> insertInventory(InventoryCountsCompanion row) {
    return into(inventoryCounts).insert(row);
  }
}
