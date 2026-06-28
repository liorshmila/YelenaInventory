import 'package:drift/drift.dart';

import '../data/datasource/local/inventory_local_data_source.dart';
import '../data/datasource/remote/inventory_remote_data_source.dart';
import '../database/app_database.dart';

class InventoryRepository {
  final InventoryLocalDataSource localDataSource;
  final InventoryRemoteDataSource remoteDataSource;

  InventoryRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  // ==========================================
  // Initialization
  // ==========================================

  Future<void> initialize() async {
    await _createDefaultBranch();
    await _createDefaultEmployees();
  }

  Future<void> _createDefaultBranch() async {
    final branches = await localDataSource.getBranches();

    if (branches.isEmpty) {
      await localDataSource.insertBranch(
        BranchesCompanion.insert(name: 'ראשי'),
      );
    }
  }

  Future<void> _createDefaultEmployees() async {
    final employees = await localDataSource.getEmployees();

    if (employees.isNotEmpty) return;

    const names = ['ילנה', 'שרית', 'נופר', 'אתי', 'משה'];

    for (final name in names) {
      await localDataSource.insertEmployee(
        EmployeesCompanion.insert(name: name, branchId: 1),
      );
    }
  }

  // ==========================================
  // Employees
  // ==========================================

  Future<List<Employee>> getEmployees() {
    return localDataSource.getEmployees();
  }

  // ==========================================
  // Branches
  // ==========================================

  Future<List<Branche>> getBranches() {
    return localDataSource.getBranches();
  }

  // ==========================================
  // Inventory
  // ==========================================

  Future<List<InventoryCount>> getInventory() {
    return localDataSource.getInventory();
  }

  Future<void> saveInventory({
    required String barcode,
    required int quantity,
    required int employeeId,
    String note = '',
  }) async {
    await localDataSource.insertInventory(
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
    await localDataSource.deleteInventory(id);
  }

  Future<void> updateQuantity({required int id, required int quantity}) async {
    await localDataSource.updateQuantity(id: id, quantity: quantity);
  }

  Future<int> totalProducts() async {
    final items = await getInventory();

    return items.length;
  }
}
