import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteBranch {
  final String id;
  final String branchCode;
  final String name;

  const RemoteBranch({
    required this.id,
    required this.branchCode,
    required this.name,
  });

  factory RemoteBranch.fromJson(Map<String, dynamic> json) {
    return RemoteBranch(
      id: json['id'] as String,
      branchCode: json['branch_code'] as String,
      name: json['name'] as String,
    );
  }
}

abstract interface class InventoryRemoteDataSource {
  Future<List<RemoteBranch>> getActiveBranches();
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
}
