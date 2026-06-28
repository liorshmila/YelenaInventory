import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

QueryExecutor createConnection() {
  return DatabaseConnection.delayed(_openWebConnection());
}

Future<DatabaseConnection> _openWebConnection() async {
  final result = await WasmDatabase.open(
    databaseName: 'inventory',
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.dart.js'),
  );

  return result.resolvedExecutor;
}
