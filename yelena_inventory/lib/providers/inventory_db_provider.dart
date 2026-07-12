import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/branch_model.dart';
import '../models/inventory_count_model.dart';
import 'repository_provider.dart';

final inventoryDbProvider = FutureProvider<List<InventoryCount>>((ref) async {
  final repo = ref.watch(inventoryRepositoryProvider);

  return repo.getInventory();
});

final operationalInventoryProvider =
    FutureProvider.family<List<InventoryCountModel>, BranchModel>((
      ref,
      branch,
    ) async {
      final repo = ref.watch(inventoryRepositoryProvider);

      return repo.getOperationalInventoryForBranch(branch);
    });

final operationalInventoryRealtimeSubscriptionProvider = Provider<void>((ref) {
  final realtimeService = ref.watch(realtimeServiceProvider);
  final productSubscription = realtimeService.subscribeToTableChanges(
    channelName: 'public:products',
    schema: 'public',
    table: 'products',
    onChange: () {
      ref.invalidate(operationalInventoryProvider);
    },
  );
  final inventorySubscription = realtimeService.subscribeToTableChanges(
    channelName: 'public:inventory_counts',
    schema: 'public',
    table: 'inventory_counts',
    onChange: () {
      ref.invalidate(operationalInventoryProvider);
    },
  );

  ref.onDispose(() {
    unawaited(productSubscription.cancel());
    unawaited(inventorySubscription.cancel());
  });
});
