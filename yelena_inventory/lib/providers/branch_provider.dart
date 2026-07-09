import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/branch_model.dart';
import 'repository_provider.dart';

final branchesProvider = FutureProvider<List<BranchModel>>((ref) async {
  final repo = ref.watch(inventoryRepositoryProvider);

  await repo.initialize();

  return repo.getBranches();
});

final selectedBranchProvider =
    NotifierProvider<SelectedBranchNotifier, BranchModel?>(
      SelectedBranchNotifier.new,
    );

class SelectedBranchNotifier extends Notifier<BranchModel?> {
  @override
  BranchModel? build() {
    return null;
  }

  void selectBranch(BranchModel branch) {
    state = branch;
  }
}
