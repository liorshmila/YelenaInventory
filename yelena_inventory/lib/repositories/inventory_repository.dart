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
        BranchesCompanion.insert(name: 'נתיבות'),
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

  Future<List<Employee>> getEmployeesForBranch(int branchId) {
    return localDataSource.getEmployeesForBranch(branchId);
  }

  Future<bool> employeeNameExistsInBranch({
    required String fullName,
    required int branchId,
    int? excludeId,
  }) async {
    final normalizedName = fullName.trim().toLowerCase();
    final employees = await getEmployeesForBranch(branchId);

    return employees.any((employee) {
      if (excludeId != null && employee.id == excludeId) {
        return false;
      }

      return employee.name.trim().toLowerCase() == normalizedName;
    });
  }

  Future<void> addEmployee({
    required String firstName,
    required String lastName,
    required String phone,
    required int branchId,
  }) async {
    await localDataSource.insertEmployee(
      EmployeesCompanion.insert(
        name: _employeeFullName(firstName: firstName, lastName: lastName),
        branchId: branchId,
      ),
    );
  }

  Future<void> updateEmployee({
    required int id,
    required String firstName,
    required String lastName,
    required String phone,
    required int branchId,
  }) async {
    await localDataSource.updateEmployee(
      id: id,
      name: _employeeFullName(firstName: firstName, lastName: lastName),
      branchId: branchId,
    );
  }

  Future<void> deleteEmployee(int id) async {
    await localDataSource.deleteEmployee(id);
  }

  // ==========================================
  // Branches
  // ==========================================

  Future<List<Branche>> getBranches() {
    return localDataSource.getBranches();
  }

  Future<bool> branchNameExists(String name, {int? excludeId}) async {
    final normalizedName = name.trim().toLowerCase();
    final branches = await getBranches();

    return branches.any((branch) {
      if (excludeId != null && branch.id == excludeId) {
        return false;
      }

      return branch.name.trim().toLowerCase() == normalizedName;
    });
  }

  Future<void> addBranch(String name) async {
    await localDataSource.insertBranch(
      BranchesCompanion.insert(name: name.trim()),
    );
  }

  Future<void> updateBranch({required int id, required String name}) async {
    await localDataSource.updateBranchName(id: id, name: name.trim());
  }

  Future<void> deleteBranch(int id) async {
    await localDataSource.deleteBranch(id);
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

  String _employeeFullName({
    required String firstName,
    required String lastName,
  }) {
    return '${firstName.trim()} ${lastName.trim()}'.trim();
  }
}
