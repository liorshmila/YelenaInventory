import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/branch_model.dart';
import '../repositories/branch_repository.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final branchRepositoryProvider = Provider<BranchRepository>((ref) {
  return BranchRepository(
    ref.read(apiServiceProvider),
  );
});

final branchesProvider =
    FutureProvider<List<BranchModel>>((ref) async {
  return ref.read(branchRepositoryProvider).getBranches();
});