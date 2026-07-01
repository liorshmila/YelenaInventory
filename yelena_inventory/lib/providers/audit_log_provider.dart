import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import 'repository_provider.dart';

final auditLogsProvider = FutureProvider<List<AuditLog>>((ref) async {
  final repository = ref.watch(auditRepositoryProvider);

  return repository.getLogs();
});
