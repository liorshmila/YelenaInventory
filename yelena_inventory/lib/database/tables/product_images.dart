import 'package:drift/drift.dart';

class ProductImages extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get barcode => text().unique()();

  TextColumn get imagePath => text()();

  DateTimeColumn get updatedAt => dateTime()();
}
