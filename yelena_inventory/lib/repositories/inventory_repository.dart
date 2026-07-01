import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasource/local/inventory_local_data_source.dart';
import '../data/datasource/remote/inventory_remote_data_source.dart';
import '../database/app_database.dart';
import 'audit_repository.dart';

class InventoryRepository {
  final InventoryLocalDataSource localDataSource;
  final InventoryRemoteDataSource remoteDataSource;
  final AuditRepository auditRepository;

  InventoryRepository({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.auditRepository,
  });

  // ==========================================
  // Initialization
  // ==========================================

  Future<void> initialize() async {
    final defaultBranch = await _ensureDefaultBranch();
    final preferences = await SharedPreferences.getInstance();
    final defaultEmployeesInitialized =
        preferences.getBool('default_employees_initialized') ?? false;

    if (!defaultEmployeesInitialized) {
      await _ensureDefaultEmployees(defaultBranch.id);
      await preferences.setBool('default_employees_initialized', true);
    }
  }

  Future<Branche> _ensureDefaultBranch() async {
    final branches = await localDataSource.getBranches();
    const defaultBranchName = '\u05E0\u05EA\u05D9\u05D1\u05D5\u05EA';

    for (final branch in branches) {
      if (branch.name.trim() == defaultBranchName) {
        return branch;
      }
    }

    if (branches.isNotEmpty) {
      return branches.first;
    }

    final branchId = await localDataSource.insertBranch(
      BranchesCompanion.insert(name: defaultBranchName),
    );

    return Branche(id: branchId, name: defaultBranchName, active: true);
  }

  Future<void> _ensureDefaultEmployees(int defaultBranchId) async {
    final employees = await localDataSource.getEmployees();

    const names = [
      '\u05D9\u05DC\u05E0\u05D4',
      '\u05E9\u05E8\u05D9\u05EA',
      '\u05E0\u05D5\u05E4\u05E8',
      '\u05D0\u05EA\u05D9',
      '\u05DE\u05E9\u05D4',
    ];

    for (final name in names) {
      final existingEmployee = employees
          .where((employee) => employee.name.trim() == name)
          .firstOrNull;

      if (existingEmployee != null) {
        if (existingEmployee.branchId != defaultBranchId) {
          await localDataSource.updateEmployee(
            id: existingEmployee.id,
            name: existingEmployee.name,
            branchId: defaultBranchId,
          );
        }

        continue;
      }

      await localDataSource.insertEmployee(
        EmployeesCompanion.insert(name: name, branchId: defaultBranchId),
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
    final fullName = _employeeFullName(
      firstName: firstName,
      lastName: lastName,
    );
    final employeeId = await localDataSource.insertEmployee(
      EmployeesCompanion.insert(name: fullName, branchId: branchId),
    );
    final branchName = await _branchName(branchId);

    await auditRepository.logAction(
      action: 'EmployeeCreated',
      entityType: 'Employee',
      entityId: employeeId,
      description: 'Employee $fullName created in branch $branchName.',
      employeeName: fullName,
      branchName: branchName,
    );
  }

  Future<void> updateEmployee({
    required int id,
    required String firstName,
    required String lastName,
    required String phone,
    required int branchId,
  }) async {
    final fullName = _employeeFullName(
      firstName: firstName,
      lastName: lastName,
    );
    await localDataSource.updateEmployee(
      id: id,
      name: fullName,
      branchId: branchId,
    );
    final branchName = await _branchName(branchId);

    await auditRepository.logAction(
      action: 'EmployeeUpdated',
      entityType: 'Employee',
      entityId: id,
      description: 'Employee $fullName updated in branch $branchName.',
      employeeName: fullName,
      branchName: branchName,
    );
  }

  Future<void> deleteEmployee(int id) async {
    final employee = await localDataSource.getEmployeeById(id);
    final branchName = await _branchName(employee?.branchId);
    final deletedRows = await localDataSource.deleteEmployee(id);

    if (deletedRows == 0) {
      throw StateError('Employee was not deleted.');
    }

    await auditRepository.logAction(
      action: 'EmployeeDeleted',
      entityType: 'Employee',
      entityId: id,
      description: 'Employee ${employee?.name ?? '#$id'} deleted.',
      employeeName: employee?.name,
      branchName: branchName,
    );
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
    final branchName = name.trim();
    final branchId = await localDataSource.insertBranch(
      BranchesCompanion.insert(name: name.trim()),
    );

    await auditRepository.logAction(
      action: 'BranchCreated',
      entityType: 'Branch',
      entityId: branchId,
      description: 'Branch $branchName created.',
      branchName: branchName,
    );
  }

  Future<void> updateBranch({required int id, required String name}) async {
    final branchName = name.trim();
    await localDataSource.updateBranchName(id: id, name: branchName);

    await auditRepository.logAction(
      action: 'BranchUpdated',
      entityType: 'Branch',
      entityId: id,
      description: 'Branch $branchName updated.',
      branchName: branchName,
    );
  }

  Future<void> deleteBranch(int id) async {
    final branch = await localDataSource.getBranchById(id);
    final branchName = branch?.name ?? 'Branch #$id';
    await localDataSource.deleteBranch(id);

    await auditRepository.logAction(
      action: 'BranchDeleted',
      entityType: 'Branch',
      entityId: id,
      description: 'Branch $branchName deleted.',
      branchName: branchName,
    );
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
    final inventoryId = await localDataSource.insertInventory(
      InventoryCountsCompanion.insert(
        barcode: barcode,
        quantity: quantity,
        employeeId: employeeId,
        branchId: Value(1),
        countDate: DateTime.now(),
        note: Value(note),
      ),
    );
    final employee = await localDataSource.getEmployeeById(employeeId);
    final branchName = await _branchName(employee?.branchId);

    await auditRepository.logAction(
      action: 'InventorySaved',
      entityType: 'Inventory',
      entityId: inventoryId,
      description:
          'Inventory count saved for barcode $barcode, quantity $quantity.',
      employeeName: employee?.name,
      branchName: branchName,
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

  Future<String> _branchName(int? branchId) async {
    if (branchId == null) {
      return 'Unknown branch';
    }

    final branch = await localDataSource.getBranchById(branchId);

    return branch?.name ?? 'Branch #$branchId';
  }
}
