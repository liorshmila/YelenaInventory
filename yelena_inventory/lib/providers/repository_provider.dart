import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasource/local/inventory_local_data_source.dart';
import '../data/datasource/remote/inventory_remote_data_source.dart';
import '../database/app_database.dart';
import '../repositories/audit_repository.dart';
import '../repositories/inventory_repository.dart';
import '../services/product_image_storage.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  ref.onDispose(() {
    db.close();
  });

  return db;
});

final inventoryLocalDataSourceProvider = Provider<InventoryLocalDataSource>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);

  return DriftInventoryLocalDataSource(db);
});

final inventoryRemoteDataSourceProvider = Provider<InventoryRemoteDataSource>((
  ref,
) {
  return RestInventoryRemoteDataSource();
});

final auditRepositoryProvider = Provider<AuditRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);

  return AuditRepository(database: db);
});

final productImageStorageProvider = Provider<ProductImageStorage>((ref) {
  return ProductImageStorage();
});

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final localDataSource = ref.watch(inventoryLocalDataSourceProvider);

  final remoteDataSource = ref.watch(inventoryRemoteDataSourceProvider);

  final auditRepository = ref.watch(auditRepositoryProvider);
  final productImageStorage = ref.watch(productImageStorageProvider);

  return InventoryRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    auditRepository: auditRepository,
    productImageStorage: productImageStorage,
  );
});
