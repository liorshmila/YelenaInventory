import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/employee_directory_entry_model.dart';
import 'repository_provider.dart';

final employeeDirectoryProvider =
    FutureProvider<List<EmployeeDirectoryEntryModel>>((ref) async {
      final repository = ref.watch(inventoryRepositoryProvider);

      return repository.getEmployeeDirectory();
    });
