import 'package:drift/drift.dart';

import '../database/app_database.dart';

class AuditRepository {
  final AppDatabase database;

  AuditRepository({required this.database});

  Future<void> logAction({
    required String action,
    required String entityType,
    int? entityId,
    required String description,
    String? employeeName,
    required String branchName,
    String? deviceId,
    String syncStatus = 'LocalOnly',
  }) async {
    await database.insertAuditLog(
      AuditLogsCompanion.insert(
        timestamp: DateTime.now(),
        action: action,
        entityType: entityType,
        description: description,
        branchName: branchName,
        entityId: Value(entityId),
        employeeName: Value(employeeName),
        deviceId: Value(deviceId),
        syncStatus: Value(syncStatus),
      ),
    );
  }

  Future<List<AuditLog>> getLogs() {
    return database.getAuditLogs();
  }

  Future<void> deleteOldLogs({Duration maxAge = const Duration(days: 180)}) {
    return database.deleteAuditLogsBefore(DateTime.now().subtract(maxAge));
  }
}
