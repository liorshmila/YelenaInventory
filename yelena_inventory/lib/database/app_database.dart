import 'package:drift/drift.dart';

import 'connection/connection.dart';
import 'tables/audit_logs.dart';
import 'tables/branches.dart';
import 'tables/employees.dart';
import 'tables/inventory_counts.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Branches, Employees, InventoryCounts, AuditLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(auditLogs);
      }
    },
  );

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

  Future<Employee?> getEmployeeById(int id) {
    return (select(
      employees,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertEmployee(EmployeesCompanion employee) {
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

  Future<int> deleteEmployee(int id) {
    return (delete(employees)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ---------- Branches ----------

  Future<List<Branche>> getBranches() {
    return select(branches).get();
  }

  Future<Branche?> getBranchById(int id) {
    return (select(
      branches,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertBranch(BranchesCompanion branch) {
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

  Future<int> insertInventory(InventoryCountsCompanion row) {
    return into(inventoryCounts).insert(row);
  }

  // ---------- Audit Logs ----------

  Future<int> insertAuditLog(AuditLogsCompanion row) {
    return into(auditLogs).insert(row);
  }

  Future<List<AuditLog>> getAuditLogs() {
    return (select(
      auditLogs,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])).get();
  }

  Future<void> deleteAuditLogsBefore(DateTime cutoff) {
    return (delete(
      auditLogs,
    )..where((tbl) => tbl.timestamp.isSmallerThanValue(cutoff))).go();
  }
}
