import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/current_session_model.dart';
import '../models/employee_creation_access.dart';
import 'current_session_provider.dart';
import 'role_assignment_management_access_provider.dart';

final employeeCreationAccessProvider = FutureProvider<EmployeeCreationAccess>((
  ref,
) async {
  final session = ref.watch(currentSessionProvider);

  if (session.status != CurrentSessionStatus.ready ||
      session.employee == null) {
    return const EmployeeCreationAccess(assignableRoles: {});
  }

  final access = await ref.watch(roleAssignmentManagementAccessProvider.future);

  return EmployeeCreationAccess(
    assignableRoles: access.assignableRoles,
    allowedAreas: access.allowedAreas,
    allowedBranches: access.allowedBranches,
  );
});
