import 'package:drift/drift.dart';

import 'employees.dart';
import 'branches.dart';

class InventoryCounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get barcode => text()();

  IntColumn get quantity => integer()();

  IntColumn get employeeId =>
      integer().references(Employees, #id)();

  IntColumn get branchId =>
      integer()
          .references(Branches, #id)
          .withDefault(const Constant(1))();

  DateTimeColumn get countDate => dateTime()();

  TextColumn get note =>
      text().withDefault(const Constant(''))();

  BoolColumn get updatedToScanner =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get scannerUpdateDate =>
      dateTime().nullable()();
}