import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasource/local/inventory_local_data_source.dart';
import '../data/datasource/remote/inventory_remote_data_source.dart';
import '../database/app_database.dart';
import '../models/add_role_assignment_request.dart';
import '../models/add_role_assignment_result.dart';
import '../models/area_model.dart';
import '../models/branch_model.dart';
import '../models/create_employee_request.dart';
import '../models/create_employee_result.dart';
import '../models/deactivate_employee_request.dart';
import '../models/deactivate_employee_result.dart';
import '../models/end_role_assignment_request.dart';
import '../models/end_role_assignment_result.dart';
import '../models/employee_directory_entry_model.dart';
import '../models/employee_model.dart';
import '../models/inventory_count_model.dart';
import '../models/product_model.dart';
import '../models/replace_role_assignment_request.dart';
import '../models/replace_role_assignment_result.dart';
import '../models/role_assignment_model.dart';
import '../models/role_model.dart';
import '../services/product_image_storage.dart';
import 'audit_repository.dart';

class InventoryRepository {
  final InventoryLocalDataSource localDataSource;
  final InventoryRemoteDataSource remoteDataSource;
  final AuditRepository auditRepository;
  final ProductImageStorage productImageStorage;

  InventoryRepository({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.auditRepository,
    required this.productImageStorage,
  });

  // ==========================================
  // Initialization
  // ==========================================

  Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final defaultBranchInitialized =
        preferences.getBool('default_branch_initialized') ?? false;
    final defaultEmployeesInitialized =
        preferences.getBool('default_employees_initialized') ?? false;

    if (defaultBranchInitialized) {
      final branches = await localDataSource.getBranches();

      if (branches.isEmpty) {
        return;
      }

      if (!defaultEmployeesInitialized) {
        await _ensureDefaultEmployees(branches.first.id);
        await preferences.setBool('default_employees_initialized', true);
      }

      return;
    }

    final defaultBranch = await _ensureDefaultBranch();
    await preferences.setBool('default_branch_initialized', true);

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

  Future<int> branchEmployeeCount(int branchId) async {
    final employees = await localDataSource.getEmployeesForBranch(branchId);

    return employees.length;
  }

  Future<List<EmployeeModel>> getEmployeeManagementEmployeesForBranch(
    BranchModel branch,
  ) async {
    final remoteBranchId = _requireRemoteBranchId(branch);
    final employees = await remoteDataSource.getEmployeesForBranch(
      branchId: remoteBranchId,
    );

    return employees.map(_mapRemoteEmployee).toList(growable: false);
  }

  Future<List<EmployeeModel>> getCompanyEmployees() async {
    final employees = await remoteDataSource.getCompanyEmployees();

    return employees.map(_mapRemoteEmployee).toList(growable: false);
  }

  Future<List<AreaModel>> getActiveAreas() async {
    final areas = await remoteDataSource.getActiveAreas();

    return areas
        .map((area) => AreaModel(id: area.id, name: area.name))
        .toList(growable: false);
  }

  Future<List<EmployeeDirectoryEntryModel>> getEmployeeDirectory() async {
    final employees = await getCompanyEmployees();
    final employeeIds = employees.map((employee) => employee.id).toSet();
    final now = DateTime.now().toUtc();
    final assignments = await remoteDataSource.getRoleAssignmentsForEmployees(
      employeeIds: employeeIds,
    );
    final effectiveAssignments = assignments
        .where((assignment) => assignment.isEffectiveAt(now))
        .toList(growable: false);

    final directBranchIds = <String>{};
    final areaIds = <String>{};
    final scopedBranchIds = <String>{};
    final scopedAreaIds = <String>{};
    var needsAllActiveBranches = false;

    for (final assignment in assignments) {
      final branchId = assignment.branchId?.trim();
      if (branchId != null && branchId.isNotEmpty) {
        scopedBranchIds.add(branchId);
      }

      final areaId = assignment.areaId?.trim();
      if (areaId != null && areaId.isNotEmpty) {
        scopedAreaIds.add(areaId);
      }
    }

    for (final assignment in effectiveAssignments) {
      switch (assignment.role.role) {
        case RoleCode.developer:
        case RoleCode.systemManager:
          needsAllActiveBranches = true;
          break;
        case RoleCode.areaManager:
          final areaId = assignment.areaId?.trim();
          if (areaId != null && areaId.isNotEmpty) {
            areaIds.add(areaId);
          }
          break;
        case RoleCode.branchManager:
        case RoleCode.deputyBranchManager:
        case RoleCode.storeEmployee:
        case RoleCode.viewer:
          final branchId = assignment.branchId?.trim();
          if (branchId != null && branchId.isNotEmpty) {
            directBranchIds.add(branchId);
          }
          break;
      }
    }

    final areas = await remoteDataSource.getAreasByIds(scopedAreaIds);
    final areasById = {
      for (final area in areas)
        area.id: AreaModel(id: area.id, name: area.name),
    };

    final scopedBranches = await remoteDataSource.getBranchesByIds(
      scopedBranchIds,
    );
    final directActiveBranches = await remoteDataSource.getActiveBranchesByIds(
      directBranchIds,
    );
    final areaBranches = await remoteDataSource.getActiveBranchesForAreaIds(
      areaIds,
    );
    final allBranches = needsAllActiveBranches
        ? await remoteDataSource.getActiveBranches()
        : const <RemoteBranch>[];

    final remoteBranchesById = <String, RemoteBranch>{};
    for (final branch in scopedBranches) {
      remoteBranchesById[branch.id] = branch;
    }
    for (final branch in directActiveBranches) {
      remoteBranchesById[branch.id] = branch;
    }
    for (final branch in areaBranches) {
      remoteBranchesById[branch.id] = branch;
    }
    for (final branch in allBranches) {
      remoteBranchesById[branch.id] = branch;
    }

    final branchModels = await _mapRemoteBranchesToModels(
      remoteBranchesById.values,
    );
    final branchesByRemoteId = {
      for (final branch in branchModels)
        if (branch.remoteId != null) branch.remoteId!: branch,
    };
    final activeBranchesByRemoteId = <String, BranchModel>{};
    for (final branch in directActiveBranches) {
      final branchModel = branchesByRemoteId[branch.id];
      if (branchModel != null) {
        activeBranchesByRemoteId[branch.id] = branchModel;
      }
    }
    for (final branch in areaBranches) {
      final branchModel = branchesByRemoteId[branch.id];
      if (branchModel != null) {
        activeBranchesByRemoteId[branch.id] = branchModel;
      }
    }
    for (final branch in allBranches) {
      final branchModel = branchesByRemoteId[branch.id];
      if (branchModel != null) {
        activeBranchesByRemoteId[branch.id] = branchModel;
      }
    }
    final branchIdsByAreaId = <String, Set<String>>{};
    for (final branch in areaBranches) {
      final areaId = branch.areaId?.trim();
      if (areaId == null || areaId.isEmpty) {
        continue;
      }

      branchIdsByAreaId.putIfAbsent(areaId, () => <String>{}).add(branch.id);
    }

    final assignmentsByEmployeeId = <String, List<RoleAssignmentModel>>{};
    for (final assignment in assignments) {
      assignmentsByEmployeeId
          .putIfAbsent(assignment.employeeId, () => <RoleAssignmentModel>[])
          .add(assignment);
    }

    return employees
        .map((employee) {
          final employeeAssignments =
              assignmentsByEmployeeId[employee.id] ??
              const <RoleAssignmentModel>[];
          final roleDetails = <EmployeeRoleAssignmentDetailModel>[];
          final roleHistory = <EmployeeRoleAssignmentDetailModel>[];
          final accessibleBranchesById = <String, BranchModel>{};
          final accessibleAreasById = <String, AreaModel>{};

          for (final assignment in employeeAssignments) {
            final branch = assignment.branchId == null
                ? null
                : branchesByRemoteId[assignment.branchId];
            final area = assignment.areaId == null
                ? null
                : areasById[assignment.areaId];
            final detail = EmployeeRoleAssignmentDetailModel(
              assignment: assignment,
              branch: branch,
              area: area,
            );

            if (!assignment.isEffectiveAt(now)) {
              roleHistory.add(detail);
              continue;
            }

            roleDetails.add(detail);

            switch (assignment.role.role) {
              case RoleCode.developer:
              case RoleCode.systemManager:
                accessibleBranchesById.addAll(activeBranchesByRemoteId);
                break;
              case RoleCode.areaManager:
                if (area != null) {
                  accessibleAreasById[area.id] = area;
                }
                final areaBranchIds = assignment.areaId == null
                    ? const <String>{}
                    : branchIdsByAreaId[assignment.areaId] ?? const <String>{};
                for (final branchId in areaBranchIds) {
                  final areaBranch = activeBranchesByRemoteId[branchId];
                  if (areaBranch != null) {
                    accessibleBranchesById[branchId] = areaBranch;
                  }
                }
                break;
              case RoleCode.branchManager:
              case RoleCode.deputyBranchManager:
              case RoleCode.storeEmployee:
              case RoleCode.viewer:
                final activeBranch = assignment.branchId == null
                    ? null
                    : activeBranchesByRemoteId[assignment.branchId];
                if (activeBranch != null && activeBranch.remoteId != null) {
                  accessibleBranchesById[activeBranch.remoteId!] = activeBranch;
                }
                break;
            }
          }

          final accessibleBranches = accessibleBranchesById.values.toList()
            ..sort(
              (first, second) =>
                  first.name.toLowerCase().compareTo(second.name.toLowerCase()),
            );
          final accessibleAreas = accessibleAreasById.values.toList()
            ..sort(
              (first, second) =>
                  first.name.toLowerCase().compareTo(second.name.toLowerCase()),
            );

          return EmployeeDirectoryEntryModel(
            employee: employee,
            effectiveRoles: roleDetails,
            roleHistory: roleHistory,
            accessibleBranches: accessibleBranches,
            accessibleAreas: accessibleAreas,
          );
        })
        .where(
          (entry) => !entry.effectiveRoles.any(
            (detail) => detail.assignment.role.role == RoleCode.developer,
          ),
        )
        .toList(growable: false);
  }

  Future<EmployeeModel?> getEmployeeByAuthUserId(String authUserId) async {
    final employee = await remoteDataSource.getEmployeeByAuthUserId(authUserId);

    return employee == null ? null : _mapRemoteEmployee(employee);
  }

  Future<List<RoleAssignmentModel>> getEffectiveRoleAssignmentsForEmployee({
    required String employeeId,
    DateTime? evaluationTimeUtc,
  }) {
    return remoteDataSource.getEffectiveRoleAssignmentsForEmployee(
      employeeId: employeeId,
      evaluationTimeUtc: evaluationTimeUtc,
    );
  }

  Future<List<BranchModel>> getAccessibleBranchesForAssignments(
    Iterable<RoleAssignmentModel> assignments,
  ) async {
    final branchIds = <String>{};
    final areaIds = <String>{};
    var canAccessAllBranches = false;

    for (final assignment in assignments) {
      switch (assignment.role.role) {
        case RoleCode.developer:
        case RoleCode.systemManager:
          canAccessAllBranches = true;
          break;
        case RoleCode.areaManager:
          final areaId = assignment.areaId?.trim();
          if (areaId != null && areaId.isNotEmpty) {
            areaIds.add(areaId);
          }
          break;
        case RoleCode.branchManager:
        case RoleCode.deputyBranchManager:
        case RoleCode.storeEmployee:
        case RoleCode.viewer:
          final branchId = assignment.branchId?.trim();
          if (branchId != null && branchId.isNotEmpty) {
            branchIds.add(branchId);
          }
          break;
      }
    }

    if (canAccessAllBranches) {
      return getBranches();
    }

    final accessibleRemoteBranchesById = <String, RemoteBranch>{};

    for (final branch in await remoteDataSource.getActiveBranchesByIds(
      branchIds,
    )) {
      accessibleRemoteBranchesById[branch.id] = branch;
    }

    for (final branch in await remoteDataSource.getActiveBranchesForAreaIds(
      areaIds,
    )) {
      accessibleRemoteBranchesById[branch.id] = branch;
    }

    return _mapRemoteBranchesToModels(accessibleRemoteBranchesById.values);
  }

  Future<List<BranchModel>> getActiveBranchesForAreaIds(
    Set<String> areaIds,
  ) async {
    final branches = await remoteDataSource.getActiveBranchesForAreaIds(
      areaIds,
    );

    return _mapRemoteBranchesToModels(branches);
  }

  Future<CreateEmployeeResult> createEmployeeWithFirstRoleAssignment(
    CreateEmployeeRequest request,
  ) async {
    _validateCreateEmployeeRequest(request);

    return remoteDataSource.createEmployeeWithFirstRoleAssignment(
      name: request.name,
      phone: request.phone,
      roleCode: request.role.code,
      areaId: request.areaId,
      branchId: request.branchId,
      validFrom: request.validFrom,
      validUntil: request.validUntil,
    );
  }

  Future<AddRoleAssignmentResult> addEmployeeRoleAssignment(
    AddRoleAssignmentRequest request,
  ) {
    _validateAddRoleAssignmentRequest(request);

    return remoteDataSource.addEmployeeRoleAssignment(
      targetEmployeeId: request.targetEmployeeId,
      roleCode: request.roleCode.code,
      areaId: request.areaId,
      branchId: request.branchId,
      validFrom: request.validFrom,
      validUntil: request.validUntil,
    );
  }

  Future<EndRoleAssignmentResult> endEmployeeRoleAssignment(
    EndRoleAssignmentRequest request,
  ) {
    _validateEndRoleAssignmentRequest(request);

    return remoteDataSource.endEmployeeRoleAssignment(
      roleAssignmentId: request.roleAssignmentId,
    );
  }

  Future<ReplaceRoleAssignmentResult> replaceEmployeeRoleAssignment(
    ReplaceRoleAssignmentRequest request,
  ) {
    _validateReplaceRoleAssignmentRequest(request);

    return remoteDataSource.replaceEmployeeRoleAssignment(
      roleAssignmentId: request.roleAssignmentId,
      roleCode: request.roleCode.code,
      areaId: request.areaId,
      branchId: request.branchId,
      validUntil: request.validUntil,
    );
  }

  Future<bool> employeeManagementNameExistsInBranch({
    required String fullName,
    required BranchModel branch,
    String? excludeEmployeeId,
  }) async {
    final normalizedName = _normalizeEmployeeName(fullName);
    final employees = await remoteDataSource.getEmployeesForBranch(
      branchId: _requireRemoteBranchId(branch),
    );

    return employees.any((employee) {
      if (excludeEmployeeId != null && employee.id == excludeEmployeeId) {
        return false;
      }

      return _normalizeEmployeeName(employee.name) == normalizedName;
    });
  }

  Future<void> addEmployeeForManagement({
    required String firstName,
    required String lastName,
    required String phone,
    required BranchModel branch,
  }) async {
    throw StateError(
      'Employee Management is temporarily unavailable until '
      'role_assignments management is implemented.',
    );
  }

  Future<void> updateEmployeeForManagement({
    required EmployeeModel employee,
    required String name,
    required String phone,
  }) async {
    _requireUuid(employee.id, 'employee id');

    final trimmedName = name.trim();
    final trimmedPhone = phone.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Employee name is empty.');
    }

    if (trimmedPhone.isEmpty) {
      throw ArgumentError.value(phone, 'phone', 'Employee phone is empty.');
    }

    try {
      await remoteDataSource.updateEmployee(
        id: employee.id,
        name: trimmedName,
        phone: trimmedPhone,
      );
    } on PostgrestException catch (error) {
      if (_isUniqueConflictForColumn(error, 'phone')) {
        throw StateError('Employee phone already exists.');
      }

      rethrow;
    }
  }

  Future<DeactivateEmployeeResult> deactivateEmployeeForManagement(
    DeactivateEmployeeRequest request,
  ) {
    _requireUuid(request.targetEmployeeId, 'target employee id');

    return remoteDataSource.deactivateEmployeeForManagement(
      targetEmployeeId: request.targetEmployeeId,
    );
  }

  Future<int> branchEmployeeCountForManagement(BranchModel branch) async {
    return remoteDataSource.countActiveEmployeesForBranch(
      _requireRemoteBranchId(branch),
    );
  }

  Future<List<EmployeeModel>> getEmployeeSelectionEmployeesForBranch(
    BranchModel branch,
  ) {
    return getEmployeeManagementEmployeesForBranch(branch);
  }

  // ==========================================
  // Branches
  // ==========================================

  Future<List<BranchModel>> getBranches() async {
    final remoteBranches = await remoteDataSource.getActiveBranches();

    return _mapRemoteBranchesToModels(remoteBranches);
  }

  Future<List<BranchModel>> _mapRemoteBranchesToModels(
    Iterable<RemoteBranch> remoteBranches,
  ) async {
    final localBranches = await localDataSource.getBranches();
    final localByCode = {
      for (final branch in localBranches)
        if (branch.branchCode != null)
          branch.branchCode!.trim().toLowerCase(): branch,
    };
    final legacyLocalByName = {
      for (final branch in localBranches)
        if (branch.branchCode == null) branch.name.trim().toLowerCase(): branch,
    };
    final result = <BranchModel>[];

    for (final remoteBranch in remoteBranches) {
      final normalizedCode = remoteBranch.branchCode.trim().toLowerCase();
      final normalizedName = remoteBranch.name.trim().toLowerCase();
      var localBranch = localByCode[normalizedCode];

      if (localBranch == null) {
        final legacyBranch = legacyLocalByName.remove(normalizedName);
        if (legacyBranch != null) {
          await localDataSource.updateBranchMetadata(
            id: legacyBranch.id,
            name: remoteBranch.name.trim(),
            branchCode: remoteBranch.branchCode,
          );
          localBranch = legacyBranch.copyWith(
            name: remoteBranch.name.trim(),
            branchCode: Value(remoteBranch.branchCode),
          );
        }
      }

      if (localBranch == null) {
        final localId = await localDataSource.insertBranch(
          BranchesCompanion.insert(
            name: remoteBranch.name.trim(),
            branchCode: Value(remoteBranch.branchCode),
          ),
        );
        localBranch = Branche(
          id: localId,
          name: remoteBranch.name.trim(),
          branchCode: remoteBranch.branchCode,
          active: true,
        );
      } else if (localBranch.name != remoteBranch.name) {
        await localDataSource.updateBranchMetadata(
          id: localBranch.id,
          name: remoteBranch.name.trim(),
          branchCode: remoteBranch.branchCode,
        );
        localBranch = localBranch.copyWith(name: remoteBranch.name.trim());
      }

      localByCode[normalizedCode] = localBranch;
      result.add(
        BranchModel(
          id: localBranch.id,
          remoteId: remoteBranch.id,
          branchCode: remoteBranch.branchCode,
          name: remoteBranch.name,
        ),
      );
    }

    return result;
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
    await remoteDataSource.createBranch(name: branchName);

    await auditRepository.logAction(
      action: 'BranchCreated',
      entityType: 'Branch',
      description: 'Branch $branchName created.',
      branchName: branchName,
    );
  }

  Future<void> updateBranch({
    required BranchModel branch,
    required String name,
  }) async {
    final remoteId = branch.remoteId?.trim();
    if (remoteId == null || remoteId.isEmpty) {
      throw StateError('Branch is missing its Supabase id.');
    }

    final branchName = name.trim();
    await remoteDataSource.updateBranch(id: remoteId, name: branchName);

    await auditRepository.logAction(
      action: 'BranchUpdated',
      entityType: 'Branch',
      description: 'Branch $branchName updated.',
      branchName: branchName,
    );
  }

  Future<void> deleteBranch(BranchModel branch) async {
    final remoteId = branch.remoteId?.trim();
    if (remoteId == null || remoteId.isEmpty) {
      throw StateError('Branch is missing its Supabase id.');
    }

    final branchName = branch.name;
    final employees = await localDataSource.getEmployeesForBranch(branch.id);

    await remoteDataSource.deactivateBranch(remoteId);

    for (final employee in employees) {
      await localDataSource.deleteEmployee(employee.id);
    }

    await auditRepository.logAction(
      action: 'BranchDeleted',
      entityType: 'Branch',
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
    final itemsBeforeDelete = await localDataSource.getInventory();
    final deletedItem = itemsBeforeDelete
        .where((item) => item.id == id)
        .firstOrNull;

    await localDataSource.deleteInventory(id);

    if (deletedItem == null) {
      return;
    }

    final remainingItems = await localDataSource.getInventory();
    final deletedBarcode = deletedItem.barcode.trim();
    final barcodeStillUsed = remainingItems.any(
      (item) => item.barcode.trim() == deletedBarcode,
    );

    if (!barcodeStillUsed) {
      await deleteProductImage(deletedBarcode);
    }
  }

  Future<void> updateQuantity({required int id, required int quantity}) async {
    await localDataSource.updateQuantity(id: id, quantity: quantity);
  }

  Future<void> updateInventoryRecord({
    required int id,
    required int quantity,
  }) async {
    await localDataSource.updateQuantity(id: id, quantity: quantity);
  }

  Future<int> totalProducts() async {
    final items = await getInventory();

    return items.length;
  }

  Future<ProductModel> getOrCreateProductForBarcode(String barcode) async {
    final normalizedBarcode = barcode.trim();

    if (normalizedBarcode.isEmpty) {
      throw StateError('Barcode is required.');
    }

    debugPrint('Product resolution started for barcode $normalizedBarcode.');
    final existing = await remoteDataSource.getProductByBarcode(
      barcode: normalizedBarcode,
      includeInactive: true,
    );

    if (existing != null) {
      debugPrint(
        'Product resolution found product ${existing.id}, '
        'active=${existing.isActive}.',
      );
      final activeProduct = existing.isActive
          ? existing
          : await remoteDataSource.reactivateProduct(id: existing.id);

      if (!existing.isActive) {
        debugPrint('Product ${existing.id} reactivated.');
      }

      return _mapRemoteProduct(activeProduct);
    }

    try {
      debugPrint('Product resolution creating product.');
      final product = await remoteDataSource.createProduct(
        barcode: normalizedBarcode,
      );
      debugPrint('Product resolution created product ${product.id}.');

      return _mapRemoteProduct(product);
    } on PostgrestException catch (error) {
      if (!_isUniqueConflictForColumn(error, 'barcode')) {
        rethrow;
      }

      final product = await remoteDataSource.getProductByBarcode(
        barcode: normalizedBarcode,
        includeInactive: true,
      );

      if (product == null) {
        throw StateError(
          'Product was created by another device but not found.',
        );
      }

      debugPrint(
        'Product resolution recovered product ${product.id} '
        'after barcode conflict.',
      );
      final activeProduct = product.isActive
          ? product
          : await remoteDataSource.reactivateProduct(id: product.id);

      return _mapRemoteProduct(activeProduct);
    }
  }

  Future<List<InventoryCountModel>> getOperationalInventoryForBranch(
    BranchModel branch,
  ) async {
    final rows = await remoteDataSource.getInventoryCountsForBranch(
      _requireRemoteBranchId(branch),
    );

    return rows.map(_mapRemoteInventoryCount).toList(growable: false);
  }

  Future<void> saveOperationalInventory({
    required BranchModel branch,
    required EmployeeModel employee,
    required String barcode,
    required int quantity,
  }) async {
    final branchId = _requireRemoteBranchId(branch);
    _requireUuid(employee.id, 'Employee');

    if (!employee.isActive) {
      throw StateError('Employee is inactive.');
    }

    final hasBranchAccess = await remoteDataSource
        .employeeHasEffectiveBranchAccess(
          employeeId: employee.id,
          branchId: branchId,
        );

    if (!hasBranchAccess) {
      throw StateError('Employee is not assigned to the selected branch.');
    }

    final product = await getOrCreateProductForBarcode(barcode);
    debugPrint(
      'Inventory count insert starting for product ${product.id}, '
      'branch $branchId, employee ${employee.id}.',
    );
    final inventoryId = await remoteDataSource.createInventoryCount(
      productId: product.id,
      branchId: branchId,
      employeeId: employee.id,
      quantity: quantity,
    );
    debugPrint('Inventory count insert completed with id $inventoryId.');

    await auditRepository.logAction(
      action: 'InventorySaved',
      entityType: 'Inventory',
      description:
          'Inventory count saved for barcode ${product.barcode}, '
          'quantity $quantity.',
      employeeName: employee.name,
      branchName: branch.name,
    );

    if (inventoryId.trim().isEmpty) {
      throw StateError('Inventory count was not created.');
    }
  }

  Future<void> updateOperationalInventoryRecord({
    required String id,
    required int quantity,
  }) async {
    _requireUuid(id, 'Inventory count');

    await remoteDataSource.updateInventoryCountQuantity(
      id: id,
      quantity: quantity,
    );
  }

  Future<void> deleteOperationalInventoryRecord(String id) async {
    _requireUuid(id, 'Inventory count');

    await remoteDataSource.deleteInventoryCount(id);
  }

  // ==========================================
  // Product images
  // ==========================================

  Future<ProductImage?> getProductImageForBarcode(String barcode) async {
    final product = await remoteDataSource.getProductByBarcode(
      barcode: barcode.trim(),
      includeInactive: true,
    );
    final imagePath = product?.imagePath?.trim();

    if (product == null ||
        imagePath == null ||
        imagePath.isEmpty ||
        !_isRemoteProductImagePath(imagePath)) {
      return null;
    }

    return ProductImage(
      id: 0,
      barcode: product.barcode,
      imagePath: imagePath,
      updatedAt: DateTime.now(),
    );
  }

  Future<void> saveProductImage({
    required String barcode,
    required XFile source,
  }) async {
    final sourceBytes = await source.readAsBytes();

    return saveProductImageBytes(barcode: barcode, sourceBytes: sourceBytes);
  }

  Future<void> saveProductImageBytes({
    required String barcode,
    required Uint8List sourceBytes,
  }) async {
    final normalizedBarcode = barcode.trim();
    debugPrint(
      'Product image save requested for barcode $normalizedBarcode, '
      'sourceBytesLength=${sourceBytes.length}.',
    );

    if (sourceBytes.isEmpty) {
      throw StateError('Product image source bytes are empty.');
    }

    final product = await getOrCreateProductForBarcode(normalizedBarcode);
    final compressedBytes = productImageStorage.compressedJpegBytes(
      sourceBytes,
    );

    debugPrint(
      'Product image compressed for product ${product.id}, '
      'compressedBytesLength=${compressedBytes.length}.',
    );

    if (compressedBytes.isEmpty) {
      throw StateError('Compressed product image bytes are empty.');
    }

    debugPrint('Storage upload starting for product ${product.id}.');
    final imagePath = await remoteDataSource.uploadProductImage(
      productId: product.id,
      bytes: compressedBytes,
    );
    debugPrint('Storage upload completed for product ${product.id}.');

    debugPrint('Product image_path update starting for product ${product.id}.');
    await remoteDataSource.updateProductImagePath(
      id: product.id,
      imagePath: imagePath,
    );
    debugPrint(
      'Product image_path update completed for product ${product.id}.',
    );
  }

  Future<void> deleteProductImage(String barcode) async {
    final normalizedBarcode = barcode.trim();
    final product = await remoteDataSource.getProductByBarcode(
      barcode: normalizedBarcode,
      includeInactive: true,
    );
    final imagePath = product?.imagePath?.trim();

    if (product == null || imagePath == null || imagePath.isEmpty) {
      return;
    }

    await remoteDataSource.deleteProductImage(imagePath);
    await remoteDataSource.updateProductImagePath(
      id: product.id,
      imagePath: null,
    );
  }

  Future<Uint8List?> readProductImageBytes(String imagePath) {
    if (!_isRemoteProductImagePath(imagePath)) {
      return Future.value(null);
    }

    return remoteDataSource.downloadProductImage(imagePath);
  }

  ProductModel _mapRemoteProduct(RemoteProduct product) {
    return ProductModel(
      id: product.id,
      barcode: product.barcode,
      name: product.name,
      notes: product.notes,
      imagePath: product.imagePath,
      isActive: product.isActive,
    );
  }

  InventoryCountModel _mapRemoteInventoryCount(RemoteInventoryCount count) {
    return InventoryCountModel(
      id: count.id,
      productId: count.productId,
      barcode: count.barcode,
      productName: count.productName,
      productImagePath: count.productImagePath,
      branchId: count.branchId,
      branchName: count.branchName,
      employeeId: count.employeeId,
      employeeName: count.employeeName,
      quantity: count.quantity,
      countedAt: count.countedAt,
    );
  }

  String _employeeFullName({
    required String firstName,
    required String lastName,
  }) {
    return '${firstName.trim()} ${lastName.trim()}'.trim();
  }

  EmployeeModel _mapRemoteEmployee(RemoteEmployee employee) {
    return EmployeeModel(
      id: employee.id,
      employeeCode: employee.employeeCode,
      name: employee.name,
      phone: employee.phone,
      authUserId: employee.authUserId,
      isActive: employee.isActive,
    );
  }

  String _normalizeEmployeeName(String name) {
    return name.trim().toLowerCase();
  }

  String _requireRemoteBranchId(BranchModel branch) {
    final remoteId = branch.remoteId?.trim();

    if (remoteId == null || remoteId.isEmpty) {
      throw StateError('Branch is missing its Supabase id.');
    }

    return remoteId;
  }

  void _requireUuid(String value, String label) {
    if (value.trim().isEmpty) {
      throw StateError('$label is missing its Supabase id.');
    }
  }

  void _validateCreateEmployeeRequest(CreateEmployeeRequest request) {
    final name = request.name.trim();
    final phone = request.phone.trim();

    if (name.isEmpty) {
      throw ArgumentError.value(
        request.name,
        'name',
        'Employee name is empty.',
      );
    }

    if (phone.isEmpty) {
      throw ArgumentError.value(
        request.phone,
        'phone',
        'Employee phone is empty.',
      );
    }

    if (!request.access.canAssignRole(request.role)) {
      throw StateError('The selected role is not assignable by this session.');
    }

    switch (request.role) {
      case RoleCode.developer:
        throw StateError('Developer cannot be assigned through this workflow.');
      case RoleCode.systemManager:
        if (request.areaId != null || request.branchId != null) {
          throw StateError('System Manager must use global scope.');
        }
        break;
      case RoleCode.areaManager:
        final areaId = request.areaId;
        if (areaId == null || areaId.trim().isEmpty) {
          throw StateError('Area Manager requires an area scope.');
        }
        if (request.branchId != null || !request.access.canUseArea(areaId)) {
          throw StateError('Area scope is not allowed.');
        }
        break;
      case RoleCode.branchManager:
      case RoleCode.deputyBranchManager:
      case RoleCode.storeEmployee:
      case RoleCode.viewer:
        final branchId = request.branchId;
        if (branchId == null || branchId.trim().isEmpty) {
          throw StateError('Branch-scoped role requires a branch scope.');
        }
        if (request.areaId != null || !request.access.canUseBranch(branchId)) {
          throw StateError('Branch scope is not allowed.');
        }
        break;
    }

    if (request.role == RoleCode.deputyBranchManager) {
      final validFrom = request.validFrom;
      final validUntil = request.validUntil;

      if (validFrom == null || validUntil == null) {
        throw StateError('Deputy Branch Manager requires validity dates.');
      }

      if (!validUntil.isAfter(validFrom)) {
        throw StateError('Deputy validity end must be after start.');
      }
    } else if (request.validFrom != null || request.validUntil != null) {
      throw StateError('Validity dates are only supported for Deputy role.');
    }
  }

  void _validateAddRoleAssignmentRequest(AddRoleAssignmentRequest request) {
    _requireUuid(request.targetEmployeeId, 'target employee id');

    switch (request.roleCode) {
      case RoleCode.developer:
        throw StateError('Developer cannot be assigned through this workflow.');
      case RoleCode.systemManager:
        if (request.areaId != null || request.branchId != null) {
          throw StateError('System Manager must use global scope.');
        }
        break;
      case RoleCode.areaManager:
        final areaId = request.areaId;
        if (areaId == null || areaId.trim().isEmpty) {
          throw StateError('Area Manager requires an area scope.');
        }
        if (request.branchId != null) {
          throw StateError('Area Manager cannot use branch scope.');
        }
        break;
      case RoleCode.branchManager:
      case RoleCode.deputyBranchManager:
      case RoleCode.storeEmployee:
      case RoleCode.viewer:
        final branchId = request.branchId;
        if (branchId == null || branchId.trim().isEmpty) {
          throw StateError('Branch-scoped role requires a branch scope.');
        }
        if (request.areaId != null) {
          throw StateError('Branch-scoped role cannot use area scope.');
        }
        break;
    }

    if (request.roleCode == RoleCode.deputyBranchManager) {
      final validFrom = request.validFrom;
      final validUntil = request.validUntil;

      if (validFrom == null || validUntil == null) {
        throw StateError('Deputy Branch Manager requires validity dates.');
      }

      if (!validUntil.isAfter(validFrom)) {
        throw StateError('Deputy validity end must be after start.');
      }
    } else if (request.validFrom != null || request.validUntil != null) {
      throw StateError('Validity dates are only supported for Deputy role.');
    }
  }

  void _validateEndRoleAssignmentRequest(EndRoleAssignmentRequest request) {
    _requireUuid(request.roleAssignmentId, 'role assignment id');
  }

  void _validateReplaceRoleAssignmentRequest(
    ReplaceRoleAssignmentRequest request,
  ) {
    _requireUuid(request.roleAssignmentId, 'role assignment id');

    switch (request.roleCode) {
      case RoleCode.developer:
        throw StateError('Developer assignments cannot be managed here.');
      case RoleCode.systemManager:
        if (request.areaId != null || request.branchId != null) {
          throw StateError('System Manager cannot use area or branch scope.');
        }
        break;
      case RoleCode.areaManager:
        final areaId = request.areaId;
        if (areaId == null || areaId.trim().isEmpty) {
          throw StateError('Area Manager requires an area scope.');
        }
        if (request.branchId != null) {
          throw StateError('Area Manager cannot use branch scope.');
        }
        break;
      case RoleCode.branchManager:
      case RoleCode.deputyBranchManager:
      case RoleCode.storeEmployee:
      case RoleCode.viewer:
        final branchId = request.branchId;
        if (branchId == null || branchId.trim().isEmpty) {
          throw StateError('Branch-scoped role requires a branch scope.');
        }
        if (request.areaId != null) {
          throw StateError('Branch-scoped role cannot use area scope.');
        }
        break;
    }

    if (request.roleCode == RoleCode.deputyBranchManager) {
      if (request.validUntil == null) {
        throw StateError('Deputy Branch Manager requires validity end date.');
      }
    } else if (request.validUntil != null) {
      throw StateError('Validity is only supported for Deputy role.');
    }
  }

  bool _isUniqueConflictForColumn(PostgrestException error, String columnName) {
    if (error.code != '23505') {
      return false;
    }

    final details = error.details?.toString() ?? '';
    final text = [
      error.message,
      details,
      error.hint ?? '',
    ].join(' ').toLowerCase();

    return text.contains(columnName.toLowerCase());
  }

  bool _isRemoteProductImagePath(String imagePath) {
    final path = imagePath.trim();

    return path.isNotEmpty &&
        path.endsWith('.jpg') &&
        !path.contains('\\') &&
        !path.contains('/') &&
        !path.contains(':') &&
        !path.startsWith('yelena_inventory_product_image_');
  }

  Future<String> _branchName(int? branchId) async {
    if (branchId == null) {
      return 'Unknown branch';
    }

    final branch = await localDataSource.getBranchById(branchId);

    return branch?.name ?? 'Branch #$branchId';
  }
}
