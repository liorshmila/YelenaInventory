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

abstract interface class InventoryRemoteDataSource {
  Future<List<RemoteBranch>> getActiveBranches();

  Future<RemoteBranch> createBranch({required String name});

  Future<RemoteBranch> updateBranch({required String id, required String name});

  Future<void> deactivateBranch(String id);
}

class SupabaseInventoryRemoteDataSource implements InventoryRemoteDataSource {
  final SupabaseClient _client;

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
}
