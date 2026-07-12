import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/branch_model.dart';
import 'repository_provider.dart';

final branchesProvider = FutureProvider<List<BranchModel>>((ref) async {
  final repo = ref.watch(inventoryRepositoryProvider);

  await repo.initialize();

  return repo.getBranches();
});

final branchRealtimeSubscriptionProvider = Provider<void>((ref) {
  final realtimeService = ref.watch(realtimeServiceProvider);
  final subscription = realtimeService.subscribeToTableChanges(
    channelName: 'public:branches',
    schema: 'public',
    table: 'branches',
    onChange: () {
      ref.invalidate(branchesProvider);
    },
  );

  ref.onDispose(() {
    unawaited(subscription.cancel());
  });
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
