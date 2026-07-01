import 'package:drift/drift.dart';

class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get timestamp => dateTime()();

  TextColumn get action => text()();

  TextColumn get entityType => text()();

  IntColumn get entityId => integer().nullable()();

  TextColumn get description => text()();

  TextColumn get employeeName => text().nullable()();

  TextColumn get branchName => text()();

  TextColumn get deviceId => text().nullable()();

  TextColumn get syncStatus =>
      text().withDefault(const Constant('LocalOnly'))();

  IntColumn get serverId => integer().nullable()();
}
