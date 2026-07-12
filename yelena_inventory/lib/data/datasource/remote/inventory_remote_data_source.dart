import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteBranch {
  final String id;
  final String branchCode;
  final String name;
  final bool isActive;

  const RemoteBranch({
    required this.id,
    required this.branchCode,
    required this.name,
    this.isActive = true,
  });

  factory RemoteBranch.fromJson(Map<String, dynamic> json) {
    return RemoteBranch(
      id: json['id'] as String,
      branchCode: json['branch_code'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class RemoteEmployee {
  final String id;
  final String employeeCode;
  final String name;
  final String phone;
  final bool isActive;
  final String branchId;
  final String membershipId;

  const RemoteEmployee({
    required this.id,
    required this.employeeCode,
    required this.name,
    required this.phone,
    required this.isActive,
    required this.branchId,
    required this.membershipId,
  });

  factory RemoteEmployee.fromMembershipJson(Map<String, dynamic> json) {
    final employee = json['employees'] as Map<String, dynamic>;

    return RemoteEmployee(
      id: employee['id'] as String,
      employeeCode: employee['employee_code'] as String,
      name: employee['name'] as String,
      phone: employee['phone'] as String,
      isActive: employee['is_active'] as bool? ?? true,
      branchId: json['branch_id'] as String,
      membershipId: json['id'] as String,
    );
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

  Future<RemoteBranch> createBranch({required String name});

  Future<RemoteBranch> updateBranch({required String id, required String name});

  Future<void> deactivateBranch(String id);

  Future<List<RemoteEmployee>> getEmployeesForBranch({
    required String branchId,
    bool includeInactiveEmployees = false,
    bool includeInactiveMemberships = false,
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

  Future<bool> employeeHasActiveBranchMembership({
    required String employeeId,
    required String branchId,
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
        .select('id, branch_code, name')
        .eq('is_active', true)
        .order('name');

    return rows.map(RemoteBranch.fromJson).toList(growable: false);
  }

  @override
  Future<RemoteBranch> createBranch({required String name}) async {
    const maxAttempts = 3;
    final branchName = name.trim();
    final normalizedName = _normalizeBranchName(branchName);
    final existingBranch = await _findBranchByNormalizedName(normalizedName);

    if (existingBranch != null) {
      if (existingBranch.isActive) {
        throw StateError('Branch name already exists.');
      }

      return _reactivateBranch(existingBranch.id);
    }

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      final branchCode = _nextBranchCode(await _fetchBranchCodes());

      try {
        final row = await _client
            .from('branches')
            .insert({'name': branchName, 'branch_code': branchCode})
            .select('id, branch_code, name')
            .single();

        return RemoteBranch.fromJson(row);
      } on PostgrestException catch (error) {
        if (_isBranchNameUniqueConflict(error)) {
          final conflictingBranch = await _findBranchByNormalizedName(
            normalizedName,
          );

          if (conflictingBranch != null && !conflictingBranch.isActive) {
            return _reactivateBranch(conflictingBranch.id);
          }

          throw StateError('Branch name already exists.');
        }

        final shouldRetry =
            attempt < maxAttempts && _isBranchCodeUniqueConflict(error);

        if (!shouldRetry) {
          if (_isBranchCodeUniqueConflict(error)) {
            throw StateError('Could not create a unique branch code.');
          }

          rethrow;
        }
      }
    }

    throw StateError('Could not create a unique branch code.');
  }

  @override
  Future<RemoteBranch> updateBranch({
    required String id,
    required String name,
  }) async {
    final row = await _client
        .from('branches')
        .update({'name': name.trim()})
        .eq('id', id)
        .select('id, branch_code, name')
        .single();

    return RemoteBranch.fromJson(row);
  }

  @override
  Future<void> deactivateBranch(String id) async {
    await _client
        .from('branches')
        .update({'is_active': false})
        .eq('id', id)
        .select('id')
        .single();
  }

  @override
  Future<List<RemoteEmployee>> getEmployeesForBranch({
    required String branchId,
    bool includeInactiveEmployees = false,
    bool includeInactiveMemberships = false,
  }) async {
    var query = _client
        .from('employee_branches')
        .select(
          'id, branch_id, is_active, '
          'employees!inner(id, employee_code, name, phone, is_active)',
        )
        .eq('branch_id', branchId);

    if (!includeInactiveMemberships) {
      query = query.eq('is_active', true);
    }

    if (!includeInactiveEmployees) {
      query = query.eq('employees.is_active', true);
    }

    final rows = await query;
    final employees = rows
        .map(RemoteEmployee.fromMembershipJson)
        .toList(growable: false);

    return [...employees]..sort(
      (first, second) =>
          first.name.toLowerCase().compareTo(second.name.toLowerCase()),
    );
  }

  @override
  Future<RemoteEmployee> createEmployee({
    required String name,
    required String phone,
    required String branchId,
  }) async {
    const maxAttempts = 3;
    final employeeName = name.trim();
    final employeePhone = phone.trim();

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      final employeeCode = _nextEmployeeCode(await _fetchEmployeeCodes());

      try {
        final employeeRow = await _client
            .from('employees')
            .insert({
              'employee_code': employeeCode,
              'name': employeeName,
              'phone': employeePhone,
              'is_active': true,
            })
            .select('id, employee_code, name, phone, is_active')
            .single();

        final employeeId = employeeRow['id'] as String;

        try {
          final membershipRow = await _client
              .from('employee_branches')
              .insert({
                'employee_id': employeeId,
                'branch_id': branchId,
                'is_active': true,
              })
              .select('id, branch_id')
              .single();

          return RemoteEmployee(
            id: employeeId,
            employeeCode: employeeRow['employee_code'] as String,
            name: employeeRow['name'] as String,
            phone: employeeRow['phone'] as String,
            isActive: employeeRow['is_active'] as bool? ?? true,
            branchId: membershipRow['branch_id'] as String,
            membershipId: membershipRow['id'] as String,
          );
        } catch (_) {
          await _safeDeactivateEmployee(employeeId);
          rethrow;
        }
      } on PostgrestException catch (error) {
        final shouldRetry =
            attempt < maxAttempts && _isEmployeeCodeUniqueConflict(error);

        if (!shouldRetry) {
          if (_isEmployeeCodeUniqueConflict(error)) {
            throw StateError('Could not create a unique employee code.');
          }

          rethrow;
        }
      }
    }

    throw StateError('Could not create a unique employee code.');
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
    final employeeRow = await _client
        .from('employees')
        .update({'name': name.trim(), 'phone': phone.trim(), 'is_active': true})
        .eq('id', employee.id)
        .select('id, employee_code, name, phone, is_active')
        .single();

    final membershipId = await _activateEmployeeMembership(
      employeeId: employee.id,
      branchId: branchId,
      fallbackMembershipId: employee.membershipId,
    );

    await _deactivateOtherEmployeeMemberships(
      employeeId: employee.id,
      activeBranchId: branchId,
    );

    return RemoteEmployee(
      id: employeeRow['id'] as String,
      employeeCode: employeeRow['employee_code'] as String,
      name: employeeRow['name'] as String,
      phone: employeeRow['phone'] as String,
      isActive: employeeRow['is_active'] as bool? ?? true,
      branchId: branchId,
      membershipId: membershipId,
    );
  }

  @override
  Future<void> moveEmployeeToBranch({
    required String employeeId,
    required String oldMembershipId,
    required String newBranchId,
  }) async {
    final membershipId = await _activateEmployeeMembership(
      employeeId: employeeId,
      branchId: newBranchId,
    );

    await _deactivateOtherEmployeeMemberships(
      employeeId: employeeId,
      activeBranchId: newBranchId,
    );

    if (oldMembershipId != membershipId) {
      await _client
          .from('employee_branches')
          .update({'is_active': false})
          .eq('id', oldMembershipId)
          .select('id')
          .single();
    }
  }

  @override
  Future<void> deactivateEmployee({required String employeeId}) async {
    await _client
        .from('employees')
        .update({'is_active': false})
        .eq('id', employeeId)
        .select('id')
        .single();

    await _client
        .from('employee_branches')
        .update({'is_active': false})
        .eq('employee_id', employeeId);
  }

  @override
  Future<int> countActiveEmployeesForBranch(String branchId) async {
    final rows = await _client
        .from('employee_branches')
        .select('id, employees!inner(id, is_active)')
        .eq('branch_id', branchId)
        .eq('is_active', true)
        .eq('employees.is_active', true);

    return rows.length;
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
  Future<bool> employeeHasActiveBranchMembership({
    required String employeeId,
    required String branchId,
  }) async {
    final rows = await _client
        .from('employee_branches')
        .select('id, employees!inner(id, is_active)')
        .eq('employee_id', employeeId)
        .eq('branch_id', branchId)
        .eq('is_active', true)
        .eq('employees.is_active', true)
        .limit(1);

    return rows.isNotEmpty;
  }

  Future<List<String>> _fetchBranchCodes() async {
    final rows = await _client.from('branches').select('branch_code');

    return rows
        .map((row) => row['branch_code'])
        .whereType<String>()
        .toList(growable: false);
  }

  Future<RemoteBranch?> _findBranchByNormalizedName(
    String normalizedName,
  ) async {
    final rows = await _client
        .from('branches')
        .select('id, branch_code, name, is_active');

    for (final row in rows) {
      final branch = RemoteBranch.fromJson(row);

      if (_normalizeBranchName(branch.name) == normalizedName) {
        return branch;
      }
    }

    return null;
  }

  Future<RemoteBranch> _reactivateBranch(String id) async {
    final row = await _client
        .from('branches')
        .update({'is_active': true})
        .eq('id', id)
        .select('id, branch_code, name, is_active')
        .single();

    return RemoteBranch.fromJson(row);
  }

  String _nextBranchCode(List<String> existingCodes) {
    final pattern = RegExp(r'^BR-(\d+)$');
    var highest = 0;

    for (final code in existingCodes) {
      final match = pattern.firstMatch(code.trim());

      if (match == null) {
        continue;
      }

      final suffix = int.tryParse(match.group(1)!);

      if (suffix != null && suffix > highest) {
        highest = suffix;
      }
    }

    final next = highest + 1;
    final padded = next.toString().padLeft(4, '0');

    return 'BR-$padded';
  }

  bool _isBranchCodeUniqueConflict(PostgrestException error) {
    return _isUniqueConflictForColumn(error, 'branch_code');
  }

  bool _isBranchNameUniqueConflict(PostgrestException error) {
    return _isUniqueConflictForColumn(error, 'name');
  }

  Future<List<String>> _fetchEmployeeCodes() async {
    final rows = await _client.from('employees').select('employee_code');

    return rows
        .map((row) => row['employee_code'])
        .whereType<String>()
        .toList(growable: false);
  }

  String _nextEmployeeCode(List<String> existingCodes) {
    final pattern = RegExp(r'^EMP-(\d+)$');
    var highest = 0;

    for (final code in existingCodes) {
      final match = pattern.firstMatch(code.trim());

      if (match == null) {
        continue;
      }

      final suffix = int.tryParse(match.group(1)!);

      if (suffix != null && suffix > highest) {
        highest = suffix;
      }
    }

    final next = highest + 1;
    final padded = next.toString().padLeft(4, '0');

    return 'EMP-$padded';
  }

  bool _isEmployeeCodeUniqueConflict(PostgrestException error) {
    return _isUniqueConflictForColumn(error, 'employee_code');
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

  String _normalizeBranchName(String name) {
    return name.trim().toLowerCase();
  }

  String _productImagePath(String productId) {
    return '$productId.jpg';
  }

  Future<String> _activateEmployeeMembership({
    required String employeeId,
    required String branchId,
    String? fallbackMembershipId,
  }) async {
    final existingRows = await _client
        .from('employee_branches')
        .select('id')
        .eq('employee_id', employeeId)
        .eq('branch_id', branchId)
        .limit(1);

    if (existingRows.isNotEmpty) {
      final membershipId = existingRows.first['id'] as String;
      await _client
          .from('employee_branches')
          .update({'is_active': true})
          .eq('id', membershipId)
          .select('id')
          .single();

      return membershipId;
    }

    if (fallbackMembershipId != null && fallbackMembershipId.isNotEmpty) {
      await _client
          .from('employee_branches')
          .update({'is_active': true, 'branch_id': branchId})
          .eq('id', fallbackMembershipId)
          .select('id')
          .single();

      return fallbackMembershipId;
    }

    final row = await _client
        .from('employee_branches')
        .insert({
          'employee_id': employeeId,
          'branch_id': branchId,
          'is_active': true,
        })
        .select('id')
        .single();

    return row['id'] as String;
  }

  Future<void> _deactivateOtherEmployeeMemberships({
    required String employeeId,
    required String activeBranchId,
  }) async {
    await _client
        .from('employee_branches')
        .update({'is_active': false})
        .eq('employee_id', employeeId)
        .neq('branch_id', activeBranchId);
  }

  Future<void> _safeDeactivateEmployee(String employeeId) async {
    try {
      await _client
          .from('employees')
          .update({'is_active': false})
          .eq('id', employeeId);
    } catch (_) {
      // The original membership failure is more important to preserve.
    }
  }
}
