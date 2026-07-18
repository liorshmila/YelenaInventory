enum AppPermission {
  viewInventory,
  createInventoryCount,
  editOwnInventoryCount,
  deleteOwnInventoryCount,
  editAnyBranchInventoryCount,
  deleteAnyBranchInventoryCount,
  manageOwnProductImages,
  manageAnyBranchProductImages,
  manageEmployees,
  createEmployees,
  editEmployees,
  deactivateEmployees,
  reactivateEmployees,
  viewRolesAndPermissions,
  assignViewer,
  assignStoreEmployee,
  assignDeputyBranchManager,
  assignBranchManager,
  assignAreaManager,
  assignSystemManager,
  removeRoleAssignments,
  viewBranchAudit,
  viewAreaAudit,
  viewGlobalAudit,
  manageBranches,
  manageAreas,
  switchBranch,
}

class EffectivePermissions {
  final Set<AppPermission> permissions;

  const EffectivePermissions._(this.permissions);

  factory EffectivePermissions.empty() {
    return const EffectivePermissions._({});
  }

  factory EffectivePermissions.from(Iterable<AppPermission> permissions) {
    return EffectivePermissions._(Set.unmodifiable(permissions));
  }

  bool allows(AppPermission permission) {
    return permissions.contains(permission);
  }
}
