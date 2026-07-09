import 'package:drift/drift.dart';

class Branches extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get branchCode => text().nullable()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();
}
