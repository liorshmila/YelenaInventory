import '../models/branch_model.dart';
import '../services/api_service.dart';

class BranchRepository {
  final ApiService _api;

  BranchRepository(this._api);

  Future<List<BranchModel>> getBranches() {
    return _api.getBranches();
  }

  Future<BranchModel> addBranch(String name) {
    return _api.addBranch(name);
  }

  Future<BranchModel> updateBranch(BranchModel branch) {
    return _api.updateBranch(branch);
  }

  Future<void> deleteBranch(int id) {
    return _api.deleteBranch(id);
  }
}
