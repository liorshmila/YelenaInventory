import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/branches.dart';
import 'tables/employees.dart';
import 'tables/inventory_counts.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Branches,
    Employees,
    InventoryCounts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

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

  Future<void> insertInventory(
    InventoryCountsCompanion row,
  ) {
    return into(inventoryCounts).insert(row);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(dir.path, 'inventory.sqlite'),
    );

    return NativeDatabase(file);
  });
}