import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/add_role_assignment_result.dart';
import '../../../models/create_branch_result.dart';
import '../../../models/create_employee_result.dart';
import '../../../models/deactivate_branch_result.dart';
import '../../../models/deactivate_employee_result.dart';
import '../../../models/end_role_assignment_result.dart';
import '../../../models/replace_role_assignment_result.dart';
import '../../../models/role_assignment_model.dart';
import '../../../models/role_model.dart';
import '../../../models/update_branch_result.dart';

class RemoteBranch {
  final String id;
  final String branchCode;
  final String name;
  final String? areaId;
  final bool isActive;

  const RemoteBranch({
    required this.id,
    required this.branchCode,
    required this.name,
    this.areaId,
    this.isActive = true,
  });

  factory RemoteBranch.fromJson(Map<String, dynamic> json) {
    return RemoteBranch(
      id: json['id'] as String,
      branchCode: json['branch_code'] as String,
      name: json['name'] as String,
      areaId: json['area_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class RemoteEmployee {
  final String id;
  final String employeeCode;
  final String name;
  final String phone;
  final String? authUserId;
  final bool isActive;

  const RemoteEmployee({
    required this.id,
    required this.employeeCode,
    required this.name,
    required this.phone,
    this.authUserId,
    required this.isActive,
  });

  factory RemoteEmployee.fromJson(Map<String, dynamic> json) {
    return RemoteEmployee(
      id: json['id'] as String,
      employeeCode: json['employee_code'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      authUserId: json['auth_user_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  factory RemoteEmployee.fromAssignmentJson(Map<String, dynamic> json) {
    return RemoteEmployee.fromJson(json['employees'] as Map<String, dynamic>);
  }
}

class RemoteArea {
  final String id;
  final String name;

  const RemoteArea({required this.id, required this.name});

  factory RemoteArea.fromJson(Map<String, dynamic> json) {
    return RemoteArea(id: json['id'] as String, name: json['name'] as String);
  }
}

class RemoteProduct {
  final String id;
  final String barcode;
  final String? name;
  final String? notes;
  final String? imagePath;
  final bool isActive;

  const RemoteProduct({
    required this.id,
    required this.barcode,
    this.name,
    this.notes,
    this.imagePath,
    required this.isActive,
  });

  factory RemoteProduct.fromJson(Map<String, dynamic> json) {
    return RemoteProduct(
      id: json['id'] as String,
      barcode: json['barcode'] as String,
      name: json['name'] as String?,
      notes: json['notes'] as String?,
      imagePath: json['image_path'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class RemoteInventoryCount {
  final String id;
  final String productId;
  final String barcode;
  final String? productName;
  final String? productImagePath;
  final String branchId;
  final String? branchName;
  final String? employeeId;
  final String? employeeName;
  final int quantity;
  final DateTime countedAt;

  const RemoteInventoryCount({
    required this.id,
    required this.productId,
    required this.barcode,
    this.productName,
    this.productImagePath,
    required this.branchId,
    this.branchName,
    this.employeeId,
    this.employeeName,
    required this.quantity,
    required this.countedAt,
  });

  factory RemoteInventoryCount.fromJson(Map<String, dynamic> json) {
    final product = json['products'] as Map<String, dynamic>;
    final branch = json['branches'] as Map<String, dynamic>?;
    final employee = json['employees'] as Map<String, dynamic>?;

    return RemoteInventoryCount(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      barcode: product['barcode'] as String,
      productName: product['name'] as String?,
      productImagePath: product['image_path'] as String?,
      branchId: json['branch_id'] as String,
      branchName: branch?['name'] as String?,
      employeeId: json['employee_id'] as String?,
      employeeName: employee?['name'] as String?,
      quantity: json['quantity'] as int,
      countedAt: DateTime.parse(json['counted_at'] as String),
    );
  }
}

abstract interface class InventoryRemoteDataSource {
  Future<List<RemoteBranch>> getActiveBranches();

  Future<CreateBranchResult> createBranch({required String name});

  Future<UpdateBranchResult> updateBranch({
    required String id,
    required String name,
    String? areaId,
  });

  Future<DeactivateBranchResult> deactivateBranch(String id);

  Future<List<RemoteEmployee>> getEmployeesForBranch({
    required String branchId,
    bool includeInactiveEmployees = false,
    bool includeInactiveMemberships = false,
  });

  Future<List<RemoteEmployee>> getCompanyEmployees();

  Future<RemoteEmployee?> getEmployeeByAuthUserId(String authUserId);

  Future<List<RoleAssignmentModel>> getEffectiveRoleAssignmentsForEmployee({
    required String employeeId,
    DateTime? evaluationTimeUtc,
  });

  Future<List<RoleAssignmentModel>> getEffectiveRoleAssignmentsForEmployees({
    required Set<String> employeeIds,
    DateTime? evaluationTimeUtc,
  });

  Future<List<RoleAssignmentModel>> getRoleAssignmentsForEmployees({
    required Set<String> employeeIds,
  });

  Future<List<RemoteBranch>> getBranchesByIds(Set<String> branchIds);

  Future<List<RemoteBranch>> getActiveBranchesByIds(Set<String> branchIds);

  Future<List<RemoteBranch>> getActiveBranchesForAreaIds(Set<String> areaIds);

  Future<List<RemoteArea>> getAreasByIds(Set<String> areaIds);

  Future<List<RemoteArea>> getActiveAreasByIds(Set<String> areaIds);

  Future<List<RemoteArea>> getActiveAreas();

  Future<CreateEmployeeResult> createEmployeeWithFirstRoleAssignment({
    required String name,
    required String phone,
    required String roleCode,
    String? areaId,
    String? branchId,
    DateTime? validFrom,
    DateTime? validUntil,
  });

  Future<AddRoleAssignmentResult> addEmployeeRoleAssignment({
    required String targetEmployeeId,
    required String roleCode,
    String? areaId,
    String? branchId,
    DateTime? validFrom,
    DateTime? validUntil,
  });

  Future<EndRoleAssignmentResult> endEmployeeRoleAssignment({
    required String roleAssignmentId,
  });

  Future<ReplaceRoleAssignmentResult> replaceEmployeeRoleAssignment({
    required String roleAssignmentId,
    required String roleCode,
    String? areaId,
    String? branchId,
    DateTime? validUntil,
  });

  Future<DeactivateEmployeeResult> deactivateEmployeeForManagement({
    required String targetEmployeeId,
  });

  Future<RemoteEmployee> createEmployee({
    required String name,
    required String phone,
    required String branchId,
  });

  Future<void> updateEmployee({
    required String id,
    required String name,
    required String phone,
  });

  Future<RemoteEmployee> reactivateEmployeeForBranch({
    required RemoteEmployee employee,
    required String name,
    required String phone,
    required String branchId,
  });

  Future<void> moveEmployeeToBranch({
    required String employeeId,
    required String oldMembershipId,
    required String newBranchId,
  });

  Future<void> deactivateEmployee({required String employeeId});

  Future<int> countActiveEmployeesForBranch(String branchId);

  Future<RemoteProduct?> getProductByBarcode({
    required String barcode,
    bool includeInactive = false,
  });

  Future<RemoteProduct> createProduct({required String barcode});

  Future<RemoteProduct> reactivateProduct({required String id});

  Future<void> updateProductImagePath({
    required String id,
    required String? imagePath,
  });

  Future<String> uploadProductImage({
    required String productId,
    required Uint8List bytes,
  });

  Future<Uint8List> downloadProductImage(String imagePath);

  Future<void> deleteProductImage(String imagePath);

  Future<List<RemoteInventoryCount>> getInventoryCountsForBranch(
    String branchId,
  );

  Future<String> createInventoryCount({
    required String productId,
    required String branchId,
    required String employeeId,
    required int quantity,
  });

  Future<void> updateInventoryCountQuantity({
    required String id,
    required int quantity,
  });

  Future<void> deleteInventoryCount(String id);

  Future<bool> employeeHasEffectiveBranchAccess({
    required String employeeId,
    required String branchId,
    DateTime? evaluationTimeUtc,
  });
}

class SupabaseInventoryRemoteDataSource implements InventoryRemoteDataSource {
  final SupabaseClient _client;
  static const String _productImagesBucket = 'product-images';

  SupabaseInventoryRemoteDataSource(this._client);

  @override
  Future<List<RemoteBranch>> getActiveBranches() async {
    final rows = await _client
        .from('branches')
        .select('id, branch_code, name, area_id')
        .eq('is_active', true)
        .order('name');

    return rows.map(RemoteBranch.fromJson).toList(growable: false);
  }

  @override
  Future<CreateBranchResult> createBranch({required String name}) async {
    final branchName = name.trim();

    final result = await _client.rpc(
      'create_branch',
      params: {'p_name': branchName},
    );

    return CreateBranchResult.parse(result as String);
  }

  @override
  Future<UpdateBranchResult> updateBranch({
    required String id,
    required String name,
    String? areaId,
  }) async {
    final result = await _client.rpc(
      'update_branch',
      params: {'p_branch_id': id, 'p_name': name.trim(), 'p_area_id': areaId},
    );

    return UpdateBranchResult.parse(result as String);
  }

  @override
  Future<DeactivateBranchResult> deactivateBranch(String id) async {
    final result = await _client.rpc(
      'deactivate_branch',
      params: {'p_branch_id': id},
    );

    return DeactivateBranchResult.parse(result as String);
  }

  @override
  Future<List<RemoteEmployee>> getEmployeesForBranch({
    required String branchId,
    bool includeInactiveEmployees = false,
    bool includeInactiveMemberships = false,
  }) async {
    final evaluationIso = DateTime.now().toUtc().toIso8601String();
    var query = _client
        .from('role_assignments')
        .select(
          'id, branch_id, is_active, '
          'employees!inner(id, employee_code, name, phone, auth_user_id, is_active)',
        )
        .eq('branch_id', branchId)
        .eq('is_active', true)
        .or('valid_from.is.null,valid_from.lte.$evaluationIso')
        .or('valid_until.is.null,valid_until.gte.$evaluationIso');

    if (!includeInactiveEmployees) {
      query = query.eq('employees.is_active', true);
    }

    final rows = await query;
    final employeesById = <String, RemoteEmployee>{};

    for (final row in rows) {
      final employee = RemoteEmployee.fromAssignmentJson(row);
      employeesById[employee.id] = employee;
    }

    final employees = employeesById.values.toList(growable: false);

    return [...employees]..sort(
      (first, second) =>
          first.name.toLowerCase().compareTo(second.name.toLowerCase()),
    );
  }

  @override
  Future<List<RemoteEmployee>> getCompanyEmployees() async {
    final rows = await _client
        .from('employees')
        .select('id, employee_code, name, phone, auth_user_id, is_active')
        .eq('is_active', true)
        .order('employee_code')
        .order('name');

    return rows.map(RemoteEmployee.fromJson).toList(growable: false);
  }

  @override
  Future<RemoteEmployee?> getEmployeeByAuthUserId(String authUserId) async {
    final rows = await _client
        .from('employees')
        .select('id, employee_code, name, phone, auth_user_id, is_active')
        .eq('auth_user_id', authUserId)
        .limit(1);

    if (rows.isEmpty) {
      return null;
    }

    return RemoteEmployee.fromJson(rows.first);
  }

  @override
  Future<List<RoleAssignmentModel>> getEffectiveRoleAssignmentsForEmployee({
    required String employeeId,
    DateTime? evaluationTimeUtc,
  }) async {
    final evaluationTime = (evaluationTimeUtc ?? DateTime.now()).toUtc();
    final evaluationIso = evaluationTime.toIso8601String();

    var query = _client
        .from('role_assignments')
        .select(
          'id, employee_id, area_id, branch_id, valid_from, valid_until, '
          'is_active, created_at, updated_at, roles!inner(code)',
        )
        .eq('employee_id', employeeId)
        .eq('is_active', true)
        .or('valid_from.is.null,valid_from.lte.$evaluationIso')
        .or('valid_until.is.null,valid_until.gte.$evaluationIso')
        .order('created_at')
        .order('id');

    final rows = await query;

    return rows.map(_roleAssignmentFromJson).toList(growable: false);
  }

  @override
  Future<List<RoleAssignmentModel>> getEffectiveRoleAssignmentsForEmployees({
    required Set<String> employeeIds,
    DateTime? evaluationTimeUtc,
  }) async {
    if (employeeIds.isEmpty) {
      return const [];
    }

    final evaluationTime = (evaluationTimeUtc ?? DateTime.now()).toUtc();
    final evaluationIso = evaluationTime.toIso8601String();

    final rows = await _client
        .from('role_assignments')
        .select(
          'id, employee_id, area_id, branch_id, valid_from, valid_until, '
          'is_active, created_at, updated_at, roles!inner(code)',
        )
        .inFilter('employee_id', employeeIds.toList()..sort())
        .eq('is_active', true)
        .or('valid_from.is.null,valid_from.lte.$evaluationIso')
        .or('valid_until.is.null,valid_until.gte.$evaluationIso')
        .order('employee_id')
        .order('created_at')
        .order('id');

    return rows.map(_roleAssignmentFromJson).toList(growable: false);
  }

  @override
  Future<List<RoleAssignmentModel>> getRoleAssignmentsForEmployees({
    required Set<String> employeeIds,
  }) async {
    if (employeeIds.isEmpty) {
      return const [];
    }

    final rows = await _client
        .from('role_assignments')
        .select(
          'id, employee_id, area_id, branch_id, valid_from, valid_until, '
          'is_active, created_at, updated_at, roles!inner(code)',
        )
        .inFilter('employee_id', employeeIds.toList()..sort())
        .order('employee_id')
        .order('created_at')
        .order('id');

    return rows.map(_roleAssignmentFromJson).toList(growable: false);
  }

  @override
  Future<List<RemoteBranch>> getBranchesByIds(Set<String> branchIds) async {
    if (branchIds.isEmpty) {
      return const [];
    }

    final rows = await _client
        .from('branches')
        .select('id, branch_code, name, area_id, is_active')
        .inFilter('id', branchIds.toList()..sort())
        .order('name');

    return rows.map(RemoteBranch.fromJson).toList(growable: false);
  }

  @override
  Future<List<RemoteBranch>> getActiveBranchesByIds(
    Set<String> branchIds,
  ) async {
    if (branchIds.isEmpty) {
      return const [];
    }

    final rows = await _client
        .from('branches')
        .select('id, branch_code, name, area_id')
        .inFilter('id', branchIds.toList()..sort())
        .eq('is_active', true)
        .order('name');

    return rows.map(RemoteBranch.fromJson).toList(growable: false);
  }

  @override
  Future<List<RemoteBranch>> getActiveBranchesForAreaIds(
    Set<String> areaIds,
  ) async {
    if (areaIds.isEmpty) {
      return const [];
    }

    final rows = await _client
        .from('branches')
        .select('id, branch_code, name, area_id')
        .inFilter('area_id', areaIds.toList()..sort())
        .eq('is_active', true)
        .order('name');

    return rows.map(RemoteBranch.fromJson).toList(growable: false);
  }

  @override
  Future<List<RemoteArea>> getAreasByIds(Set<String> areaIds) async {
    if (areaIds.isEmpty) {
      return const [];
    }

    final rows = await _client
        .from('areas')
        .select('id, name, is_active')
        .inFilter('id', areaIds.toList()..sort())
        .order('name');

    return rows.map(RemoteArea.fromJson).toList(growable: false);
  }

  @override
  Future<List<RemoteArea>> getActiveAreasByIds(Set<String> areaIds) async {
    if (areaIds.isEmpty) {
      return const [];
    }

    final rows = await _client
        .from('areas')
        .select('id, name')
        .inFilter('id', areaIds.toList()..sort())
        .eq('is_active', true)
        .order('name');

    return rows.map(RemoteArea.fromJson).toList(growable: false);
  }

  @override
  Future<List<RemoteArea>> getActiveAreas() async {
    final rows = await _client
        .from('areas')
        .select('id, name')
        .eq('is_active', true)
        .order('name');

    return rows.map(RemoteArea.fromJson).toList(growable: false);
  }

  @override
  Future<CreateEmployeeResult> createEmployeeWithFirstRoleAssignment({
    required String name,
    required String phone,
    required String roleCode,
    String? areaId,
    String? branchId,
    DateTime? validFrom,
    DateTime? validUntil,
  }) async {
    final result = await _client.rpc(
      'create_employee_with_first_role_assignment',
      params: {
        'p_name': name.trim(),
        'p_phone': phone.trim(),
        'p_role_code': roleCode.trim(),
        'p_area_id': areaId,
        'p_branch_id': branchId,
        'p_valid_from': validFrom?.toUtc().toIso8601String(),
        'p_valid_until': validUntil?.toUtc().toIso8601String(),
      },
    );

    return CreateEmployeeResult.parse(result as String);
  }

  @override
  Future<AddRoleAssignmentResult> addEmployeeRoleAssignment({
    required String targetEmployeeId,
    required String roleCode,
    String? areaId,
    String? branchId,
    DateTime? validFrom,
    DateTime? validUntil,
  }) async {
    final result = await _client.rpc(
      'add_employee_role_assignment',
      params: {
        'p_target_employee_id': targetEmployeeId.trim(),
        'p_role_code': roleCode.trim(),
        'p_area_id': areaId,
        'p_branch_id': branchId,
        'p_valid_from': validFrom?.toUtc().toIso8601String(),
        'p_valid_until': validUntil?.toUtc().toIso8601String(),
      },
    );

    return AddRoleAssignmentResult.parse(result as String);
  }

  @override
  Future<EndRoleAssignmentResult> endEmployeeRoleAssignment({
    required String roleAssignmentId,
  }) async {
    final result = await _client.rpc(
      'end_employee_role_assignment',
      params: {'p_role_assignment_id': roleAssignmentId.trim()},
    );

    return EndRoleAssignmentResult.parse(result as String);
  }

  @override
  Future<ReplaceRoleAssignmentResult> replaceEmployeeRoleAssignment({
    required String roleAssignmentId,
    required String roleCode,
    String? areaId,
    String? branchId,
    DateTime? validUntil,
  }) async {
    final result = await _client.rpc(
      'replace_employee_role_assignment',
      params: {
        'p_role_assignment_id': roleAssignmentId.trim(),
        'p_role_code': roleCode.trim(),
        'p_area_id': areaId,
        'p_branch_id': branchId,
        'p_valid_until': validUntil?.toUtc().toIso8601String(),
      },
    );

    return ReplaceRoleAssignmentResult.parse(result as String);
  }

  @override
  Future<DeactivateEmployeeResult> deactivateEmployeeForManagement({
    required String targetEmployeeId,
  }) async {
    final result = await _client.rpc(
      'deactivate_employee',
      params: {'p_target_employee_id': targetEmployeeId.trim()},
    );

    return DeactivateEmployeeResult.parse(result as String);
  }

  @override
  Future<RemoteEmployee> createEmployee({
    required String name,
    required String phone,
    required String branchId,
  }) async {
    throw UnsupportedError(
      'Employee management is moving to role_assignments and is not available '
      'through employee_branches.',
    );
  }

  @override
  Future<void> updateEmployee({
    required String id,
    required String name,
    required String phone,
  }) async {
    await _client
        .from('employees')
        .update({'name': name.trim(), 'phone': phone.trim()})
        .eq('id', id)
        .select('id')
        .single();
  }

  @override
  Future<RemoteEmployee> reactivateEmployeeForBranch({
    required RemoteEmployee employee,
    required String name,
    required String phone,
    required String branchId,
  }) async {
    throw UnsupportedError(
      'Employee reactivation must be implemented through role_assignments.',
    );
  }

  @override
  Future<void> moveEmployeeToBranch({
    required String employeeId,
    required String oldMembershipId,
    required String newBranchId,
  }) async {
    throw UnsupportedError(
      'Branch assignment must be implemented through role_assignments.',
    );
  }

  @override
  Future<void> deactivateEmployee({required String employeeId}) async {
    throw UnsupportedError(
      'Employee deactivation must be rebuilt for the role_assignments model.',
    );
  }

  @override
  Future<int> countActiveEmployeesForBranch(String branchId) async {
    final rows = await _client
        .from('role_assignments')
        .select('employee_id, employees!inner(id, is_active)')
        .eq('branch_id', branchId)
        .eq('is_active', true)
        .eq('employees.is_active', true);

    return rows
        .map((row) => row['employee_id'])
        .whereType<String>()
        .toSet()
        .length;
  }

  @override
  Future<RemoteProduct?> getProductByBarcode({
    required String barcode,
    bool includeInactive = false,
  }) async {
    var query = _client
        .from('products')
        .select('id, barcode, name, notes, image_path, is_active')
        .eq('barcode', barcode.trim());

    if (!includeInactive) {
      query = query.eq('is_active', true);
    }

    final rows = await query.limit(1);

    if (rows.isEmpty) {
      return null;
    }

    return RemoteProduct.fromJson(rows.first);
  }

  @override
  Future<RemoteProduct> createProduct({required String barcode}) async {
    final row = await _client
        .from('products')
        .insert({'barcode': barcode.trim()})
        .select('id, barcode, name, notes, image_path, is_active')
        .single();

    return RemoteProduct.fromJson(row);
  }

  @override
  Future<RemoteProduct> reactivateProduct({required String id}) async {
    final row = await _client
        .from('products')
        .update({'is_active': true})
        .eq('id', id)
        .select('id, barcode, name, notes, image_path, is_active')
        .single();

    return RemoteProduct.fromJson(row);
  }

  @override
  Future<void> updateProductImagePath({
    required String id,
    required String? imagePath,
  }) async {
    debugPrint(
      'Product image_path update start: productId=$id, imagePath=$imagePath.',
    );

    try {
      await _client
          .from('products')
          .update({'image_path': imagePath})
          .eq('id', id)
          .select('id')
          .single();

      debugPrint('Product image_path update success: productId=$id.');
    } on PostgrestException catch (error) {
      debugPrint(
        'Product image_path update failed: productId=$id, '
        'code=${error.code}, message=${error.message}, '
        'details=${error.details}, hint=${error.hint}.',
      );
      rethrow;
    } catch (error) {
      debugPrint(
        'Product image_path update failed: productId=$id, error=$error.',
      );
      rethrow;
    }
  }

  @override
  Future<String> uploadProductImage({
    required String productId,
    required Uint8List bytes,
  }) async {
    final imagePath = _productImagePath(productId);

    if (bytes.isEmpty) {
      throw StateError('Product image bytes are empty.');
    }

    debugPrint(
      'Storage upload start: bucket=$_productImagesBucket, '
      'objectPath=$imagePath, bytesLength=${bytes.length}, upsert=true.',
    );

    try {
      await _client.storage
          .from(_productImagesBucket)
          .uploadBinary(
            imagePath,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
              cacheControl: '3600',
            ),
          );

      debugPrint(
        'Storage upload success: bucket=$_productImagesBucket, '
        'objectPath=$imagePath.',
      );
    } on StorageException catch (error) {
      debugPrint(
        'Storage upload failed: bucket=$_productImagesBucket, '
        'objectPath=$imagePath, statusCode=${error.statusCode}, '
        'error=${error.error}, message=${error.message}.',
      );
      rethrow;
    } catch (error) {
      debugPrint(
        'Storage upload failed: bucket=$_productImagesBucket, '
        'objectPath=$imagePath, error=$error.',
      );
      rethrow;
    }

    return imagePath;
  }

  @override
  Future<Uint8List> downloadProductImage(String imagePath) {
    return _client.storage.from(_productImagesBucket).download(imagePath);
  }

  @override
  Future<void> deleteProductImage(String imagePath) async {
    await _client.storage.from(_productImagesBucket).remove([imagePath]);
  }

  @override
  Future<List<RemoteInventoryCount>> getInventoryCountsForBranch(
    String branchId,
  ) async {
    final rows = await _client
        .from('inventory_counts')
        .select(
          'id, product_id, branch_id, employee_id, quantity, counted_at, '
          'products!inner(id, barcode, name, image_path, is_active), '
          'branches!inner(id, name, is_active), '
          'employees(id, name)',
        )
        .eq('branch_id', branchId)
        .eq('products.is_active', true)
        .eq('branches.is_active', true)
        .order('counted_at', ascending: false)
        .order('created_at', ascending: false);

    return rows.map(RemoteInventoryCount.fromJson).toList(growable: false);
  }

  @override
  Future<String> createInventoryCount({
    required String productId,
    required String branchId,
    required String employeeId,
    required int quantity,
  }) async {
    final row = await _client
        .from('inventory_counts')
        .insert({
          'product_id': productId,
          'branch_id': branchId,
          'employee_id': employeeId,
          'quantity': quantity,
        })
        .select('id')
        .single();

    return row['id'] as String;
  }

  @override
  Future<void> updateInventoryCountQuantity({
    required String id,
    required int quantity,
  }) async {
    await _client
        .from('inventory_counts')
        .update({'quantity': quantity})
        .eq('id', id)
        .select('id')
        .single();
  }

  @override
  Future<void> deleteInventoryCount(String id) async {
    await _client.from('inventory_counts').delete().eq('id', id).select('id');
  }

  @override
  Future<bool> employeeHasEffectiveBranchAccess({
    required String employeeId,
    required String branchId,
    DateTime? evaluationTimeUtc,
  }) async {
    final assignments = await getEffectiveRoleAssignmentsForEmployee(
      employeeId: employeeId,
      evaluationTimeUtc: evaluationTimeUtc,
    );

    if (assignments.any(
      (assignment) =>
          assignment.role.role == RoleCode.developer ||
          assignment.role.role == RoleCode.systemManager ||
          assignment.branchId == branchId,
    )) {
      return true;
    }

    final areaIds = assignments
        .where((assignment) => assignment.role.role == RoleCode.areaManager)
        .map((assignment) => assignment.areaId)
        .whereType<String>()
        .toSet();

    if (areaIds.isEmpty) {
      return false;
    }

    final rows = await _client
        .from('branches')
        .select('id')
        .eq('id', branchId)
        .eq('is_active', true)
        .inFilter('area_id', areaIds.toList())
        .limit(1);

    return rows.isNotEmpty;
  }

  bool isProductBarcodeUniqueConflict(PostgrestException error) {
    return _isUniqueConflictForColumn(error, 'barcode');
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

  String _productImagePath(String productId) {
    return '$productId.jpg';
  }

  RoleAssignmentModel _roleAssignmentFromJson(Map<String, dynamic> json) {
    final roleJson = json['roles'] as Map<String, dynamic>;

    return RoleAssignmentModel(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      role: RoleModel.fromCode(roleJson['code'] as String),
      areaId: json['area_id'] as String?,
      branchId: json['branch_id'] as String?,
      validFrom: _parseNullableDateTime(json['valid_from']),
      validUntil: _parseNullableDateTime(json['valid_until']),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  DateTime? _parseNullableDateTime(Object? value) {
    if (value == null) {
      return null;
    }

    return DateTime.parse(value as String);
  }
}
