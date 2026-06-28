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

  Future<void> insertEmployee(EmployeesCompanion employee) {
    return into(employees).insert(employee);
  }

  // ---------- Branches ----------

  Future<List<Branche>> getBranches() {
    return select(branches).get();
  }

  Future<void> insertBranch(BranchesCompanion branch) {
    return into(branches).insert(branch);
  }

  // ---------- Inventory ----------

  Future<List<InventoryCount>> getInventory() {
    return select(inventoryCounts).get();
  }

  Future<void> insertInventory(InventoryCountsCompanion row) {
    return into(inventoryCounts).insert(row);
  }
}
