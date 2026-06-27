import 'package:drift/drift.dart';

class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get branchId => integer()();

  BoolColumn get active =>
      boolean().withDefault(const Constant(true))();
}