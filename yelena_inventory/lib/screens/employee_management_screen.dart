import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../models/add_role_assignment_request.dart';
import '../models/add_role_assignment_result.dart';
import '../models/area_model.dart';
import '../models/branch_model.dart';
import '../models/create_employee_request.dart';
import '../models/create_employee_result.dart';
import '../models/deactivate_employee_request.dart';
import '../models/deactivate_employee_result.dart';
import '../models/end_role_assignment_request.dart';
import '../models/end_role_assignment_result.dart';
import '../models/employee_creation_access.dart';
import '../models/employee_directory_entry_model.dart';
import '../models/employee_model.dart';
import '../models/replace_role_assignment_request.dart';
import '../models/replace_role_assignment_result.dart';
import '../models/role_assignment_model.dart';
import '../models/role_assignment_management_access.dart';
import '../models/role_model.dart';
import '../providers/auth_provider.dart';
import '../providers/current_session_provider.dart';
import '../providers/employee_creation_access_provider.dart';
import '../providers/employee_management_provider.dart';
import '../providers/global_loading_provider.dart';
import '../providers/repository_provider.dart';
import '../providers/role_assignment_management_access_provider.dart';
import '../theme/app_theme.dart';
import '../utils/israeli_phone_input_formatter.dart';
import '../utils/israeli_phone_normalizer.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_error_banner.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/app_text_field.dart';
import '../widgets/branch_view_selector.dart';
import '../widgets/current_user_header.dart';
import '../widgets/section_title.dart';

class EmployeeManagementScreen extends ConsumerStatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  ConsumerState<EmployeeManagementScreen> createState() =>
      _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState
    extends ConsumerState<EmployeeManagementScreen> {
  String? selectedBranchId;

  @override
  Widget build(BuildContext context) {
    final directoryAsync = ref.watch(employeeDirectoryProvider);
    final creationAccessAsync = ref.watch(employeeCreationAccessProvider);
    final assignmentAccessAsync = ref.watch(
      roleAssignmentManagementAccessProvider,
    );
    final accessibleBranches = ref.watch(accessibleBranchesProvider);
    final strings = ref.watch(appStringsProvider);

    if (assignmentAccessAsync.isLoading) {
      return AppFrame(child: LoadingView(message: strings.loadingEmployees));
    }

    if (assignmentAccessAsync.hasError) {
      return AppFrame(
        child: ErrorView(
          message: strings.couldNotLoadEmployees,
          retryLabel: strings.retry,
          onRetry: () {
            ref.invalidate(roleAssignmentManagementAccessProvider);
          },
        ),
      );
    }

    if (!(assignmentAccessAsync.value?.canAddRoleAssignments ?? false)) {
      return AppFrame(child: ErrorView(message: strings.unauthorized));
    }

    return AppFrame(
      child: directoryAsync.when(
        loading: () => LoadingView(message: strings.loadingEmployees),
        error: (error, stack) => ErrorView(
          message: strings.couldNotLoadEmployees,
          retryLabel: strings.retry,
          onRetry: () {
            ref.invalidate(employeeDirectoryProvider);
          },
        ),
        data: (entries) {
          final creationAccess = creationAccessAsync.value;
          final canCreate = creationAccess?.canCreateEmployees ?? false;
          final selectedBranch = _selectedViewBranch(accessibleBranches);
          final visibleEntries = _filterVisibleEntries(
            entries: entries,
            selectedBranch: selectedBranch,
            accessibleBranches: accessibleBranches,
          );

          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CurrentUserHeader(selectedBranch: selectedBranch),
                  if (accessibleBranches.length > 1) ...[
                    const SizedBox(height: 12),
                    BranchViewSelector(
                      branches: accessibleBranches,
                      selectedBranch: selectedBranch,
                      allowAllBranches: true,
                      allBranchesLabel: strings.allBranches,
                      tooltip: strings.switchBranch,
                      onSelected: (branch) {
                        setState(() {
                          selectedBranchId = branch?.remoteId;
                        });
                      },
                    ),
                  ],
                  const SizedBox(height: 14),
                  Expanded(
                    child: AppScrollbar(
                      builder: (controller) {
                        return ListView(
                          controller: controller,
                          padding: EdgeInsets.only(bottom: canCreate ? 86 : 0),
                          children: [
                            SectionTitle(
                              title: strings.companyEmployees,
                              subtitle: strings.companyEmployeesSubtitle,
                              icon: Icons.people_outline,
                            ),
                            const SizedBox(height: 18),
                            if (visibleEntries.isEmpty)
                              EmptyState(
                                icon: Icons.people_outline,
                                message: strings.noCompanyEmployees,
                              )
                            else
                              for (final entry in visibleEntries)
                                _EmployeeDirectoryTile(
                                  entry: entry,
                                  strings: strings,
                                  canEdit:
                                      assignmentAccessAsync.value
                                          ?.canManageTarget(entry) ??
                                      false,
                                  canDelete:
                                      assignmentAccessAsync.value
                                          ?.canManageTarget(entry) ??
                                      false,
                                  onEdit: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) =>
                                            _EmployeeEditScreen(entry: entry),
                                      ),
                                    );
                                  },
                                  onManageAssignments: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => _EmployeeDetailsScreen(
                                          entry: entry,
                                        ),
                                      ),
                                    );
                                  },
                                  onDelete: () {
                                    _confirmDeactivateEmployee(
                                      context: context,
                                      ref: ref,
                                      entry: entry,
                                    );
                                  },
                                ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              if (canCreate && creationAccess != null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    tooltip: strings.createEmployee,
                    onPressed: () {
                      _showCreateEmployeeWizard(
                        context: context,
                        ref: ref,
                        access: creationAccess,
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  BranchModel? _selectedViewBranch(List<BranchModel> branches) {
    if (branches.isEmpty) {
      return null;
    }

    if (branches.length > 1 && selectedBranchId == null) {
      return null;
    }

    final selectedId = selectedBranchId;
    if (selectedId != null) {
      for (final branch in branches) {
        if (branch.remoteId == selectedId) {
          return branch;
        }
      }
    }

    return branches.length == 1 ? branches.first : null;
  }

  List<EmployeeDirectoryEntryModel> _filterVisibleEntries({
    required List<EmployeeDirectoryEntryModel> entries,
    required BranchModel? selectedBranch,
    required List<BranchModel> accessibleBranches,
  }) {
    final selectedBranchId = selectedBranch?.remoteId;
    if (selectedBranchId != null) {
      return entries
          .where((entry) => _entryHasBranch(entry, selectedBranchId))
          .toList(growable: false);
    }

    final accessibleBranchIds = accessibleBranches
        .map((branch) => branch.remoteId)
        .whereType<String>()
        .toSet();

    if (accessibleBranchIds.isEmpty) {
      return const [];
    }

    return entries
        .where(
          (entry) => entry.accessibleBranches.any(
            (branch) =>
                branch.remoteId != null &&
                accessibleBranchIds.contains(branch.remoteId),
          ),
        )
        .toList(growable: false);
  }

  bool _entryHasBranch(EmployeeDirectoryEntryModel entry, String branchId) {
    return entry.accessibleBranches.any(
      (branch) => branch.remoteId == branchId,
    );
  }
}

Future<void> _showCreateEmployeeWizard({
  required BuildContext context,
  required WidgetRef ref,
  required EmployeeCreationAccess access,
}) async {
  final strings = ref.read(appStringsProvider);
  final created = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _CreateEmployeeWizard(access: access),
  );

  if (created == true && context.mounted) {
    ref.invalidate(employeeDirectoryProvider);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(strings.employeeCreatedWithRole)));
  }
}

Future<void> _showAddRoleAssignmentDialog({
  required BuildContext context,
  required WidgetRef ref,
  required EmployeeDirectoryEntryModel target,
}) async {
  final strings = ref.read(appStringsProvider);
  final freshAccess = await _loadFreshAssignmentAccess(
    context: context,
    ref: ref,
  );

  if (freshAccess == null || !context.mounted) {
    return;
  }

  final outcome = await showDialog<_RoleAssignmentDialogOutcome>(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        _AddRoleAssignmentDialog(target: target, access: freshAccess),
  );

  if (outcome == _RoleAssignmentDialogOutcome.created && context.mounted) {
    ref.invalidate(employeeDirectoryProvider);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(strings.assignmentCreated)));
  }
}

Future<void> _showEditRoleAssignmentDialog({
  required BuildContext context,
  required WidgetRef ref,
  required EmployeeDirectoryEntryModel target,
  required EmployeeRoleAssignmentDetailModel detail,
}) async {
  final strings = ref.read(appStringsProvider);
  final freshAccess = await _loadFreshAssignmentAccess(
    context: context,
    ref: ref,
  );

  if (freshAccess == null || !context.mounted) {
    return;
  }

  final outcome = await showDialog<_RoleAssignmentDialogOutcome>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AddRoleAssignmentDialog(
      target: target,
      access: freshAccess,
      editingDetail: detail,
    ),
  );

  if (!context.mounted) {
    return;
  }

  if (outcome == _RoleAssignmentDialogOutcome.replaced) {
    ref.invalidate(employeeDirectoryProvider);
    await _refreshCurrentSessionIfNeeded(ref: ref, target: target);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.assignmentUpdated)));
    }
  }
}

Future<RoleAssignmentManagementAccess?> _loadFreshAssignmentAccess({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  try {
    ref.invalidate(roleAssignmentManagementAccessProvider);
    return await ref
        .read(globalLoadingProvider.notifier)
        .runWithLoading(
          () => ref.read(roleAssignmentManagementAccessProvider.future),
        );
  } catch (error, stackTrace) {
    debugPrint('Could not refresh role assignment access: $error');
    debugPrintStack(stackTrace: stackTrace);

    if (context.mounted) {
      final strings = ref.read(appStringsProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.couldNotLoadEmployees)));
    }

    return null;
  }
}

Future<void> _refreshCurrentSessionIfNeeded({
  required WidgetRef ref,
  required EmployeeDirectoryEntryModel target,
}) async {
  final currentEmployee = ref.read(currentEmployeeProvider);
  final currentUser = ref.read(currentAuthUserProvider);

  if (currentEmployee?.id != target.employee.id || currentUser == null) {
    return;
  }

  await ref
      .read(currentSessionBootstrapServiceProvider)
      .bootstrapForAuthenticatedUser(currentUser.id);
}

Future<void> _confirmDeactivateEmployee({
  required BuildContext context,
  required WidgetRef ref,
  required EmployeeDirectoryEntryModel entry,
}) async {
  final strings = ref.read(appStringsProvider);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(strings.deleteEmployee),
        content: Text(strings.deleteEmployeeConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(strings.delete),
          ),
        ],
      );
    },
  );

  if (confirmed != true || !context.mounted) {
    return;
  }

  try {
    final result = await ref
        .read(globalLoadingProvider.notifier)
        .runWithLoading(() {
          return ref
              .read(inventoryRepositoryProvider)
              .deactivateEmployeeForManagement(
                DeactivateEmployeeRequest(targetEmployeeId: entry.employee.id),
              );
        });

    if (!context.mounted) {
      return;
    }

    switch (result) {
      case DeactivateEmployeeResult.deactivated:
      case DeactivateEmployeeResult.partiallyDeactivated:
        ref.invalidate(employeeDirectoryProvider);
        await _refreshCurrentSessionIfNeeded(ref: ref, target: entry);
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_deactivateEmployeeResultMessage(result, strings)),
          ),
        );
        return;
      case DeactivateEmployeeResult.nothingToDeactivate:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_deactivateEmployeeResultMessage(result, strings)),
          ),
        );
        return;
      case DeactivateEmployeeResult.employeeNotFound:
      case DeactivateEmployeeResult.employeeInactive:
      case DeactivateEmployeeResult.protectedRole:
      case DeactivateEmployeeResult.selfManagementNotAllowed:
      case DeactivateEmployeeResult.unauthorized:
      case DeactivateEmployeeResult.operationFailed:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_deactivateEmployeeResultMessage(result, strings)),
          ),
        );
        return;
    }
  } catch (error, stackTrace) {
    debugPrint('Deactivate employee failed: $error');
    debugPrintStack(stackTrace: stackTrace);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.employeeDeactivateFailed)));
    }
  }
}

enum _CreateEmployeeStep { identity, role, scope, validity, review }

enum _AddRoleAssignmentStep { role, scope, validity, review }

enum _RoleAssignmentDialogOutcome { created, replaced }

class _CreateEmployeeWizard extends ConsumerStatefulWidget {
  final EmployeeCreationAccess access;

  const _CreateEmployeeWizard({required this.access});

  @override
  ConsumerState<_CreateEmployeeWizard> createState() =>
      _CreateEmployeeWizardState();
}

class _CreateEmployeeWizardState extends ConsumerState<_CreateEmployeeWizard> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  var currentStep = 0;
  var saving = false;
  RoleCode? selectedRole;
  String? selectedAreaId;
  String? selectedBranchId;
  DateTime? validFrom;
  DateTime? validUntil;
  String? nameError;
  String? phoneError;
  String? roleError;
  String? scopeError;
  String? validUntilError;
  String? wizardError;

  @override
  void initState() {
    super.initState();
    selectedRole = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final role = selectedRole;
    final errorMessage = wizardError;
    final steps = _wizardSteps(role);
    if (currentStep >= steps.length) {
      currentStep = steps.length - 1;
    }
    final activeStep = steps[currentStep];
    final isLastStep = currentStep == steps.length - 1;

    return AlertDialog(
      title: Text(strings.createEmployee),
      content: SizedBox(
        width: 520,
        height: MediaQuery.sizeOf(context).height * 0.72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (errorMessage != null) ...[
              AppErrorBanner(message: errorMessage),
              const SizedBox(height: 12),
            ],
            Flexible(
              child: AppScrollbar(
                builder: (controller) {
                  return SingleChildScrollView(
                    controller: controller,
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _WizardStepHeader(
                          labels: [
                            for (final step in steps)
                              _createEmployeeStepTitle(strings, step),
                          ],
                          currentStep: currentStep,
                        ),
                        const SizedBox(height: 18),
                        _buildStepContent(
                          strings: strings,
                          step: activeStep,
                          role: role,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving
              ? null
              : () {
                  Navigator.pop(context, false);
                },
          child: Text(strings.cancel),
        ),
        if (currentStep > 0)
          TextButton(
            onPressed: saving
                ? null
                : () {
                    setState(() {
                      currentStep--;
                    });
                  },
            child: Text(strings.back),
          ),
        FilledButton(
          onPressed: saving
              ? null
              : () async {
                  if (!isLastStep) {
                    if (_validateCurrentStep(strings, activeStep)) {
                      setState(() {
                        currentStep++;
                        wizardError = null;
                      });
                    }
                    return;
                  }

                  await _submit(strings);
                },
          child: Text(isLastStep ? strings.createEmployee : strings.next),
        ),
      ],
    );
  }

  Widget _buildStepContent({
    required AppStrings strings,
    required _CreateEmployeeStep step,
    required RoleCode? role,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: switch (step) {
        _CreateEmployeeStep.identity => _identityStep(strings),
        _CreateEmployeeStep.role => _roleStep(strings),
        _CreateEmployeeStep.scope => _scopeStep(strings),
        _CreateEmployeeStep.validity => _validityStep(strings),
        _CreateEmployeeStep.review =>
          role == null
              ? _MutedText(strings.invalidRole)
              : _reviewStep(strings, role),
      },
    );
  }

  List<_CreateEmployeeStep> _wizardSteps(RoleCode? role) {
    return [
      _CreateEmployeeStep.identity,
      _CreateEmployeeStep.role,
      _CreateEmployeeStep.scope,
      if (role == RoleCode.deputyBranchManager) _CreateEmployeeStep.validity,
      _CreateEmployeeStep.review,
    ];
  }

  Widget _identityStep(AppStrings strings) {
    return Column(
      children: [
        AppTextField(
          controller: nameController,
          label: strings.employeeName,
          icon: Icons.person_outline,
          errorText: nameError,
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: phoneController,
          label: strings.phoneNumber,
          hintText: '050-1234567',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.number,
          errorText: phoneError,
          inputFormatters: const [IsraeliPhoneInputFormatter()],
        ),
      ],
    );
  }

  Widget _roleStep(AppStrings strings) {
    final roles = _assignableRoles(widget.access);
    final error = roleError;

    if (roles.isEmpty) {
      return _MutedText(strings.unauthorized);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: strings.selectRole,
            prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RoleCode>(
              value: selectedRole,
              isExpanded: true,
              items: roles
                  .map(
                    (role) => DropdownMenuItem<RoleCode>(
                      value: role,
                      child: Text(_roleLabel(role, strings)),
                    ),
                  )
                  .toList(),
              onChanged: (role) {
                setState(() {
                  _selectRole(role);
                });
              },
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.error),
          ),
        ],
      ],
    );
  }

  Widget _scopeStep(AppStrings strings) {
    final role = selectedRole;
    if (role == null) {
      return _MutedText(strings.invalidRole);
    }

    if (role == RoleCode.systemManager) {
      return _MutedText(strings.noScopeRequired);
    }

    if (role == RoleCode.areaManager) {
      final areas = widget.access.allowedAreas;
      if (areas.length == 1) {
        return _ScopeContent(
          errorText: scopeError,
          child: _SelectedScopeValue(
            label: strings.selectArea,
            value: areas.first.name,
            icon: Icons.map_outlined,
          ),
        );
      }

      return _ScopeContent(
        errorText: scopeError,
        child: DropdownButtonFormField<String>(
          initialValue: selectedAreaId,
          decoration: InputDecoration(
            labelText: strings.selectArea,
            prefixIcon: const Icon(Icons.map_outlined),
          ),
          items: areas
              .map(
                (area) => DropdownMenuItem<String>(
                  value: area.id,
                  child: Text(area.name),
                ),
              )
              .toList(),
          onChanged: (areaId) {
            setState(() {
              selectedAreaId = areaId;
              scopeError = null;
              wizardError = null;
            });
          },
        ),
      );
    }

    final branches = widget.access.allowedBranches;
    if (branches.length == 1) {
      return _ScopeContent(
        errorText: scopeError,
        child: _SelectedScopeValue(
          label: strings.selectBranch,
          value: branches.first.name,
          icon: Icons.business_outlined,
        ),
      );
    }

    return _ScopeContent(
      errorText: scopeError,
      child: DropdownButtonFormField<String>(
        initialValue: selectedBranchId,
        decoration: InputDecoration(
          labelText: strings.selectBranch,
          prefixIcon: const Icon(Icons.business_outlined),
        ),
        items: branches
            .map(
              (branch) => DropdownMenuItem<String>(
                value: branch.remoteId,
                child: Text(branch.name),
              ),
            )
            .toList(),
        onChanged: (branchId) {
          setState(() {
            selectedBranchId = branchId;
            scopeError = null;
            wizardError = null;
          });
        },
      ),
    );
  }

  Widget _validityStep(AppStrings strings) {
    if (selectedRole != RoleCode.deputyBranchManager) {
      return _MutedText(strings.alwaysValid);
    }

    final startsAt = validFrom ?? DateTime.now();
    final endsAt = validUntil;
    final error = validUntilError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: strings.validFrom, value: _formatDate(startsAt)),
        const SizedBox(height: 12),
        SecondaryButton(
          label: endsAt == null
              ? strings.validUntil
              : '${strings.validUntil}: ${_formatDate(endsAt)}',
          icon: Icons.event_outlined,
          onPressed: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: now.add(const Duration(days: 1)),
              firstDate: now,
              lastDate: now.add(const Duration(days: 365 * 2)),
            );

            if (picked == null) {
              return;
            }

            setState(() {
              validFrom = startsAt;
              validUntil = DateTime(
                picked.year,
                picked.month,
                picked.day,
                23,
                59,
                59,
              );
              validUntilError = null;
            });
          },
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.error),
          ),
        ],
      ],
    );
  }

  Widget _reviewStep(AppStrings strings, RoleCode role) {
    final validUntilValue = validUntil;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReviewSummaryItem(
          label: strings.employeeName,
          value: nameController.text.trim(),
          icon: Icons.person_outline,
        ),
        _ReviewSummaryItem(
          label: strings.phoneNumber,
          value: phoneController.text.trim(),
          icon: Icons.phone_outlined,
        ),
        _ReviewSummaryItem(
          label: strings.selectRole,
          value: _roleLabel(role, strings),
          icon: Icons.admin_panel_settings_outlined,
        ),
        if (role == RoleCode.areaManager)
          _ReviewSummaryItem(
            label: strings.area,
            value: _selectedAreaName() ?? strings.invalidScope,
            icon: Icons.map_outlined,
          ),
        if (_isBranchScopedRole(role))
          _ReviewSummaryItem(
            label: strings.branch,
            value: _selectedBranchName() ?? strings.invalidScope,
            icon: Icons.business_outlined,
          ),
        if (role == RoleCode.deputyBranchManager)
          _ReviewSummaryItem(
            label: strings.validity,
            value: validUntilValue == null
                ? strings.validUntilRequired
                : '${_formatDate(validFrom ?? DateTime.now())} - ${_formatDate(validUntilValue)}',
            icon: Icons.event_outlined,
          ),
      ],
    );
  }

  bool _validateCurrentStep(
    AppStrings strings,
    _CreateEmployeeStep currentStep,
  ) {
    return switch (currentStep) {
      _CreateEmployeeStep.identity => _validateIdentity(strings),
      _CreateEmployeeStep.role => _validateRole(strings),
      _CreateEmployeeStep.scope => _validateScope(strings),
      _CreateEmployeeStep.validity => _validateValidity(strings),
      _CreateEmployeeStep.review => true,
    };
  }

  bool _validateIdentity(AppStrings strings) {
    final name = nameController.text.trim();
    String? normalizedPhone;

    try {
      normalizedPhone = IsraeliPhoneNormalizer.normalizeToLocalStorage(
        phoneController.text,
      );
    } on FormatException {
      normalizedPhone = null;
    }

    setState(() {
      nameError = name.isEmpty ? strings.employeeNameRequired : null;
      phoneError = normalizedPhone == null ? strings.invalidPhone : null;
      wizardError = null;

      if (normalizedPhone != null) {
        phoneController.text = normalizedPhone;
      }
      nameController.text = name;
    });

    return nameError == null && phoneError == null;
  }

  bool _validateRole(AppStrings strings) {
    final role = selectedRole;
    final valid = role != null && widget.access.canAssignRole(role);

    setState(() {
      roleError = valid ? null : strings.invalidRole;
      wizardError = valid ? null : strings.invalidRole;
    });

    return valid;
  }

  bool _validateScope(AppStrings strings) {
    final role = selectedRole;
    if (role == null) {
      setState(() {
        currentStep = _stepIndexFor(_CreateEmployeeStep.role);
        roleError = strings.invalidRole;
        scopeError = strings.invalidRole;
        wizardError = strings.invalidRole;
      });
      return false;
    }

    if (role == RoleCode.systemManager) {
      setState(() {
        selectedAreaId = null;
        selectedBranchId = null;
        scopeError = null;
      });
      return true;
    }

    bool valid;
    if (role == RoleCode.areaManager) {
      final areaId = selectedAreaId;
      valid = areaId != null && widget.access.canUseArea(areaId);
    } else {
      final branchId = selectedBranchId;
      valid = branchId != null && widget.access.canUseBranch(branchId);
    }

    setState(() {
      scopeError = valid ? null : strings.invalidScope;
      wizardError = valid ? null : strings.invalidScope;
    });

    return valid;
  }

  bool _validateValidity(AppStrings strings) {
    if (selectedRole != RoleCode.deputyBranchManager) {
      return true;
    }

    final startsAt = validFrom ?? DateTime.now();
    final endsAt = validUntil;

    setState(() {
      validFrom = startsAt;
      validUntilError = endsAt == null
          ? strings.validUntilRequired
          : !endsAt.isAfter(startsAt)
          ? strings.validUntilAfterFrom
          : null;
      wizardError = validUntilError;
    });

    return validUntilError == null;
  }

  Future<void> _submit(AppStrings strings) async {
    if (!_validateIdentity(strings) ||
        !_validateRole(strings) ||
        !_validateScope(strings) ||
        !_validateValidity(strings)) {
      return;
    }

    final request = _buildValidatedRequest(strings);
    if (request == null) {
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      final result = await ref
          .read(globalLoadingProvider.notifier)
          .runWithLoading(() {
            return ref
                .read(inventoryRepositoryProvider)
                .createEmployeeWithFirstRoleAssignment(request);
          });

      if (!mounted) {
        return;
      }

      if (result == CreateEmployeeResult.created) {
        Navigator.pop(context, true);
        return;
      }

      setState(() {
        wizardError = _createEmployeeResultMessage(result, strings);
      });
    } catch (error, stackTrace) {
      debugPrint('Create employee failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          wizardError = strings.employeeCreationFailed;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  void _selectRole(RoleCode? role) {
    selectedRole = role;
    roleError = null;
    scopeError = null;
    validUntilError = null;
    wizardError = null;
    validFrom = role == RoleCode.deputyBranchManager ? DateTime.now() : null;
    validUntil = null;
    _resetScopeForRole(role);
    _clampCurrentStep(role);
  }

  void _resetScopeForRole(RoleCode? role) {
    if (role == RoleCode.areaManager) {
      selectedAreaId = widget.access.allowedAreas.length == 1
          ? widget.access.allowedAreas.first.id
          : null;
      selectedBranchId = null;
      return;
    }

    if (role != null && _isBranchScopedRole(role)) {
      selectedBranchId = widget.access.allowedBranches.length == 1
          ? widget.access.allowedBranches.first.remoteId
          : null;
      selectedAreaId = null;
      return;
    }

    selectedAreaId = null;
    selectedBranchId = null;
  }

  void _clampCurrentStep(RoleCode? role) {
    final steps = _wizardSteps(role);
    if (currentStep >= steps.length) {
      currentStep = steps.length - 1;
    }
  }

  int _stepIndexFor(_CreateEmployeeStep step) {
    final steps = _wizardSteps(selectedRole);
    final index = steps.indexOf(step);
    return index < 0 ? steps.length - 1 : index;
  }

  CreateEmployeeRequest? _buildValidatedRequest(AppStrings strings) {
    final name = nameController.text.trim();
    String phone;

    try {
      phone = IsraeliPhoneNormalizer.normalizeToLocalStorage(
        phoneController.text,
      );
    } on FormatException {
      setState(() {
        currentStep = _stepIndexFor(_CreateEmployeeStep.identity);
        phoneError = strings.invalidPhone;
        wizardError = strings.invalidPhone;
      });
      return null;
    }

    if (name.isEmpty) {
      setState(() {
        currentStep = _stepIndexFor(_CreateEmployeeStep.identity);
        nameError = strings.employeeNameRequired;
        wizardError = strings.employeeNameRequired;
      });
      return null;
    }

    final role = selectedRole;
    if (role == null || !widget.access.canAssignRole(role)) {
      setState(() {
        currentStep = _stepIndexFor(_CreateEmployeeStep.role);
        roleError = strings.invalidRole;
        wizardError = strings.invalidRole;
      });
      return null;
    }

    String? areaId;
    String? branchId;

    if (role == RoleCode.areaManager) {
      areaId = selectedAreaId;
      if (areaId == null || !widget.access.canUseArea(areaId)) {
        setState(() {
          currentStep = _stepIndexFor(_CreateEmployeeStep.scope);
          scopeError = strings.invalidScope;
          wizardError = strings.invalidScope;
        });
        return null;
      }
    } else if (_isBranchScopedRole(role)) {
      branchId = selectedBranchId;
      if (branchId == null || !widget.access.canUseBranch(branchId)) {
        setState(() {
          currentStep = _stepIndexFor(_CreateEmployeeStep.scope);
          scopeError = strings.invalidScope;
          wizardError = strings.invalidScope;
        });
        return null;
      }
    } else if (selectedAreaId != null || selectedBranchId != null) {
      setState(() {
        currentStep = _stepIndexFor(_CreateEmployeeStep.scope);
        scopeError = strings.invalidScope;
        wizardError = strings.invalidScope;
      });
      return null;
    }

    DateTime? requestValidFrom;
    DateTime? requestValidUntil;
    if (role == RoleCode.deputyBranchManager) {
      requestValidFrom = validFrom ?? DateTime.now();
      requestValidUntil = validUntil;
      if (requestValidUntil == null ||
          !requestValidUntil.isAfter(requestValidFrom)) {
        setState(() {
          currentStep = _stepIndexFor(_CreateEmployeeStep.validity);
          validFrom = requestValidFrom;
          validUntilError = requestValidUntil == null
              ? strings.validUntilRequired
              : strings.validUntilAfterFrom;
          wizardError = validUntilError;
        });
        return null;
      }
    }

    return CreateEmployeeRequest(
      name: name,
      phone: phone,
      role: role,
      areaId: areaId,
      branchId: branchId,
      validFrom: requestValidFrom,
      validUntil: requestValidUntil,
      access: widget.access,
    );
  }

  String? _selectedAreaName() {
    final areaId = selectedAreaId;
    if (areaId == null) {
      return null;
    }

    for (final area in widget.access.allowedAreas) {
      if (area.id == areaId) {
        return area.name;
      }
    }

    return null;
  }

  String? _selectedBranchName() {
    final branchId = selectedBranchId;
    if (branchId == null) {
      return null;
    }

    for (final branch in widget.access.allowedBranches) {
      if (branch.remoteId == branchId) {
        return branch.name;
      }
    }

    return null;
  }
}

class _AddRoleAssignmentDialog extends ConsumerStatefulWidget {
  final EmployeeDirectoryEntryModel target;
  final RoleAssignmentManagementAccess access;
  final EmployeeRoleAssignmentDetailModel? editingDetail;

  const _AddRoleAssignmentDialog({
    required this.target,
    required this.access,
    this.editingDetail,
  });

  bool get isEditing => editingDetail != null;

  @override
  ConsumerState<_AddRoleAssignmentDialog> createState() =>
      _AddRoleAssignmentDialogState();
}

class _AddRoleAssignmentDialogState
    extends ConsumerState<_AddRoleAssignmentDialog> {
  var currentStep = 0;
  var saving = false;
  RoleCode? selectedRole;
  String? selectedAreaId;
  String? selectedBranchId;
  DateTime? validFrom;
  DateTime? validUntil;
  String? roleError;
  String? scopeError;
  String? validUntilError;
  String? dialogError;

  @override
  void initState() {
    super.initState();
    final detail = widget.editingDetail;
    if (detail == null) {
      return;
    }

    final assignment = detail.assignment;
    final role = assignment.role.role;
    selectedRole = role;
    selectedAreaId = role == RoleCode.areaManager ? assignment.areaId : null;
    selectedBranchId = _isBranchScopedRole(role) ? assignment.branchId : null;
    validFrom = role == RoleCode.deputyBranchManager
        ? assignment.validFrom ?? DateTime.now()
        : null;
    validUntil = role == RoleCode.deputyBranchManager
        ? assignment.validUntil
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final role = selectedRole;
    final steps = _addRoleAssignmentSteps(role);
    if (currentStep >= steps.length) {
      currentStep = steps.length - 1;
    }
    final activeStep = steps[currentStep];
    final isLastStep = currentStep == steps.length - 1;
    final error = dialogError;

    return AlertDialog(
      title: Text(widget.isEditing ? strings.editAssignment : strings.addRole),
      content: SizedBox(
        width: 520,
        height: MediaQuery.sizeOf(context).height * 0.62,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (error != null) ...[
              AppErrorBanner(message: error),
              const SizedBox(height: 12),
            ],
            Flexible(
              child: AppScrollbar(
                builder: (controller) {
                  return SingleChildScrollView(
                    controller: controller,
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _WizardStepHeader(
                          labels: [
                            for (final step in steps)
                              _addRoleAssignmentStepTitle(strings, step),
                          ],
                          currentStep: currentStep,
                        ),
                        const SizedBox(height: 18),
                        _buildStepContent(strings, activeStep, role),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving ? null : () => Navigator.pop(context),
          child: Text(strings.cancel),
        ),
        if (currentStep > 0)
          TextButton(
            onPressed: saving
                ? null
                : () {
                    setState(() {
                      currentStep--;
                      dialogError = null;
                    });
                  },
            child: Text(strings.back),
          ),
        FilledButton(
          onPressed: saving
              ? null
              : () async {
                  if (!isLastStep) {
                    if (_validateCurrentStep(strings, activeStep)) {
                      setState(() {
                        currentStep++;
                        dialogError = null;
                      });
                    }
                    return;
                  }

                  await _submit(strings);
                },
          child: Text(
            isLastStep
                ? widget.isEditing
                      ? strings.save
                      : strings.createAssignment
                : strings.next,
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent(
    AppStrings strings,
    _AddRoleAssignmentStep step,
    RoleCode? role,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: switch (step) {
        _AddRoleAssignmentStep.role => _roleStep(strings),
        _AddRoleAssignmentStep.scope => _scopeStep(strings),
        _AddRoleAssignmentStep.validity => _validityStep(strings),
        _AddRoleAssignmentStep.review =>
          role == null
              ? _MutedText(strings.invalidRole)
              : _reviewStep(strings, role),
      },
    );
  }

  Widget _roleStep(AppStrings strings) {
    final roles = _assignableAssignmentRoles(widget.access);
    final error = roleError;

    if (roles.isEmpty) {
      return _MutedText(strings.unauthorized);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: strings.selectRole,
            prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RoleCode>(
              value: selectedRole,
              isExpanded: true,
              items: roles
                  .map(
                    (role) => DropdownMenuItem<RoleCode>(
                      value: role,
                      child: Text(_roleLabel(role, strings)),
                    ),
                  )
                  .toList(),
              onChanged: (role) {
                setState(() {
                  _selectRole(role);
                });
              },
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.error),
          ),
        ],
      ],
    );
  }

  Widget _scopeStep(AppStrings strings) {
    final role = selectedRole;
    if (role == null) {
      return _MutedText(strings.invalidRole);
    }

    if (role == RoleCode.systemManager) {
      return _MutedText(strings.noScopeRequired);
    }

    if (role == RoleCode.areaManager) {
      final areas = widget.access.allowedAreas;
      if (areas.length == 1) {
        return _ScopeContent(
          errorText: scopeError,
          child: _SelectedScopeValue(
            label: strings.selectArea,
            value: _selectedAreaName() ?? areas.first.name,
            icon: Icons.map_outlined,
          ),
        );
      }

      return _ScopeContent(
        errorText: scopeError,
        child: DropdownButtonFormField<String>(
          key: ValueKey('assignment-area-${selectedAreaId ?? ''}'),
          initialValue: selectedAreaId,
          decoration: InputDecoration(
            labelText: strings.selectArea,
            prefixIcon: const Icon(Icons.map_outlined),
          ),
          items: areas
              .map(
                (area) => DropdownMenuItem<String>(
                  value: area.id,
                  child: Text(area.name),
                ),
              )
              .toList(),
          onChanged: (areaId) {
            setState(() {
              selectedAreaId = areaId;
              scopeError = null;
              dialogError = null;
            });
          },
        ),
      );
    }

    final branches = widget.access.allowedBranches;
    if (branches.length == 1) {
      return _ScopeContent(
        errorText: scopeError,
        child: _SelectedScopeValue(
          label: strings.selectBranch,
          value: _selectedBranchName() ?? branches.first.name,
          icon: Icons.business_outlined,
        ),
      );
    }

    return _ScopeContent(
      errorText: scopeError,
      child: DropdownButtonFormField<String>(
        key: ValueKey('assignment-branch-${selectedBranchId ?? ''}'),
        initialValue: selectedBranchId,
        decoration: InputDecoration(
          labelText: strings.selectBranch,
          prefixIcon: const Icon(Icons.business_outlined),
        ),
        items: branches
            .map(
              (branch) => DropdownMenuItem<String>(
                value: branch.remoteId,
                child: Text(branch.name),
              ),
            )
            .toList(),
        onChanged: (branchId) {
          setState(() {
            selectedBranchId = branchId;
            scopeError = null;
            dialogError = null;
          });
        },
      ),
    );
  }

  Widget _validityStep(AppStrings strings) {
    if (selectedRole != RoleCode.deputyBranchManager) {
      return _MutedText(strings.alwaysValid);
    }

    final startsAt = validFrom ?? DateTime.now();
    final endsAt = validUntil;
    final error = validUntilError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: strings.validFrom, value: _formatDate(startsAt)),
        const SizedBox(height: 12),
        SecondaryButton(
          label: endsAt == null
              ? strings.validUntil
              : '${strings.validUntil}: ${_formatDate(endsAt)}',
          icon: Icons.event_outlined,
          onPressed: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: now.add(const Duration(days: 1)),
              firstDate: now,
              lastDate: now.add(const Duration(days: 365 * 2)),
            );

            if (picked == null) {
              return;
            }

            setState(() {
              validFrom = startsAt;
              validUntil = DateTime(
                picked.year,
                picked.month,
                picked.day,
                23,
                59,
                59,
              );
              validUntilError = null;
              dialogError = null;
            });
          },
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.error),
          ),
        ],
      ],
    );
  }

  Widget _reviewStep(AppStrings strings, RoleCode role) {
    final validUntilValue = validUntil;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReviewSummaryItem(
          label: strings.employeeName,
          value: widget.target.employee.name,
          icon: Icons.person_outline,
        ),
        _ReviewSummaryItem(
          label: strings.selectRole,
          value: _roleLabel(role, strings),
          icon: Icons.admin_panel_settings_outlined,
        ),
        if (role == RoleCode.areaManager)
          _ReviewSummaryItem(
            label: strings.area,
            value: _selectedAreaName() ?? strings.invalidScope,
            icon: Icons.map_outlined,
          ),
        if (_isBranchScopedRole(role))
          _ReviewSummaryItem(
            label: strings.branch,
            value: _selectedBranchName() ?? strings.invalidScope,
            icon: Icons.business_outlined,
          ),
        if (role == RoleCode.deputyBranchManager)
          _ReviewSummaryItem(
            label: strings.validity,
            value: validUntilValue == null
                ? strings.validUntilRequired
                : '${_formatDate(validFrom ?? DateTime.now())} - ${_formatDate(validUntilValue)}',
            icon: Icons.event_outlined,
          ),
      ],
    );
  }

  bool _validateCurrentStep(AppStrings strings, _AddRoleAssignmentStep step) {
    return switch (step) {
      _AddRoleAssignmentStep.role => _validateRole(strings),
      _AddRoleAssignmentStep.scope => _validateScope(strings),
      _AddRoleAssignmentStep.validity => _validateValidity(strings),
      _AddRoleAssignmentStep.review => true,
    };
  }

  bool _validateRole(AppStrings strings) {
    final role = selectedRole;
    final valid = role != null && widget.access.canAssignRole(role);

    setState(() {
      roleError = valid ? null : strings.invalidRole;
      dialogError = valid ? null : strings.invalidRole;
    });

    return valid;
  }

  bool _validateScope(AppStrings strings) {
    final role = selectedRole;
    if (role == null) {
      setState(() {
        currentStep = _stepIndexFor(_AddRoleAssignmentStep.role);
        roleError = strings.invalidRole;
        scopeError = strings.invalidRole;
        dialogError = strings.invalidRole;
      });
      return false;
    }

    if (role == RoleCode.systemManager) {
      setState(() {
        selectedAreaId = null;
        selectedBranchId = null;
        scopeError = null;
        dialogError = null;
      });
      return true;
    }

    bool valid;
    if (role == RoleCode.areaManager) {
      final areaId = selectedAreaId;
      valid = areaId != null && widget.access.canUseArea(areaId);
    } else {
      final branchId = selectedBranchId;
      valid = branchId != null && widget.access.canUseBranch(branchId);
    }

    setState(() {
      scopeError = valid ? null : strings.invalidScope;
      dialogError = valid ? null : strings.invalidScope;
    });

    return valid;
  }

  bool _validateValidity(AppStrings strings) {
    if (selectedRole != RoleCode.deputyBranchManager) {
      return true;
    }

    final startsAt = validFrom ?? DateTime.now();
    final endsAt = validUntil;

    setState(() {
      validFrom = startsAt;
      validUntilError = endsAt == null
          ? strings.validUntilRequired
          : !endsAt.isAfter(startsAt)
          ? strings.validUntilAfterFrom
          : null;
      dialogError = validUntilError;
    });

    return validUntilError == null;
  }

  Future<void> _submit(AppStrings strings) async {
    if (!_validateRole(strings) ||
        !_validateScope(strings) ||
        !_validateValidity(strings)) {
      return;
    }

    if (widget.isEditing) {
      await _submitEdit(strings);
      return;
    }

    await _submitCreate(strings);
  }

  Future<void> _submitCreate(AppStrings strings) async {
    final request = _buildValidatedRequest(strings);
    if (request == null) {
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      final result = await ref
          .read(globalLoadingProvider.notifier)
          .runWithLoading(() {
            return ref
                .read(inventoryRepositoryProvider)
                .addEmployeeRoleAssignment(request);
          });

      if (!mounted) {
        return;
      }

      if (result == AddRoleAssignmentResult.created) {
        Navigator.pop(context, _RoleAssignmentDialogOutcome.created);
        return;
      }

      setState(() {
        dialogError = _addRoleAssignmentResultMessage(result, strings);
      });
    } catch (error, stackTrace) {
      debugPrint('Add role assignment failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          dialogError = strings.assignmentCreationFailed;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  Future<void> _submitEdit(AppStrings strings) async {
    final request = _buildValidatedReplaceRequest(strings);
    if (request == null) {
      return;
    }

    if (!_assignmentChanged(request)) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      final result = await ref
          .read(globalLoadingProvider.notifier)
          .runWithLoading(() {
            return ref
                .read(inventoryRepositoryProvider)
                .replaceEmployeeRoleAssignment(request);
          });

      if (!mounted) {
        return;
      }

      if (result == ReplaceRoleAssignmentResult.replaced) {
        Navigator.pop(context, _RoleAssignmentDialogOutcome.replaced);
        return;
      }

      if (result == ReplaceRoleAssignmentResult.unchanged) {
        Navigator.pop(context);
        return;
      }

      setState(() {
        dialogError = _replaceRoleAssignmentResultMessage(result, strings);
      });
    } catch (error, stackTrace) {
      debugPrint('Replace role assignment failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          dialogError = strings.assignmentUpdateFailed;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  void _selectRole(RoleCode? role) {
    selectedRole = role;
    roleError = null;
    scopeError = null;
    validUntilError = null;
    dialogError = null;
    validFrom = role == RoleCode.deputyBranchManager ? DateTime.now() : null;
    validUntil = null;
    _resetScopeForRole(role);
    _clampCurrentStep(role);
  }

  void _resetScopeForRole(RoleCode? role) {
    if (role == RoleCode.areaManager) {
      selectedAreaId = widget.access.allowedAreas.length == 1
          ? widget.access.allowedAreas.first.id
          : null;
      selectedBranchId = null;
      return;
    }

    if (role != null && _isBranchScopedRole(role)) {
      selectedBranchId = widget.access.allowedBranches.length == 1
          ? widget.access.allowedBranches.first.remoteId
          : null;
      selectedAreaId = null;
      return;
    }

    selectedAreaId = null;
    selectedBranchId = null;
  }

  void _clampCurrentStep(RoleCode? role) {
    final steps = _addRoleAssignmentSteps(role);
    if (currentStep >= steps.length) {
      currentStep = steps.length - 1;
    }
  }

  int _stepIndexFor(_AddRoleAssignmentStep step) {
    final steps = _addRoleAssignmentSteps(selectedRole);
    final index = steps.indexOf(step);
    return index < 0 ? steps.length - 1 : index;
  }

  AddRoleAssignmentRequest? _buildValidatedRequest(AppStrings strings) {
    if (!widget.access.canAddRoleToTarget(widget.target)) {
      setState(() {
        dialogError = strings.selfManagementNotAllowed;
      });
      return null;
    }

    final role = selectedRole;
    if (role == null || !widget.access.canAssignRole(role)) {
      setState(() {
        currentStep = _stepIndexFor(_AddRoleAssignmentStep.role);
        roleError = strings.invalidRole;
        dialogError = strings.invalidRole;
      });
      return null;
    }

    String? areaId;
    String? branchId;

    if (role == RoleCode.areaManager) {
      areaId = selectedAreaId;
      if (areaId == null || !widget.access.canUseArea(areaId)) {
        setState(() {
          currentStep = _stepIndexFor(_AddRoleAssignmentStep.scope);
          scopeError = strings.invalidScope;
          dialogError = strings.invalidScope;
        });
        return null;
      }
    } else if (_isBranchScopedRole(role)) {
      branchId = selectedBranchId;
      if (branchId == null || !widget.access.canUseBranch(branchId)) {
        setState(() {
          currentStep = _stepIndexFor(_AddRoleAssignmentStep.scope);
          scopeError = strings.invalidScope;
          dialogError = strings.invalidScope;
        });
        return null;
      }
    } else if (selectedAreaId != null || selectedBranchId != null) {
      setState(() {
        currentStep = _stepIndexFor(_AddRoleAssignmentStep.scope);
        scopeError = strings.invalidScope;
        dialogError = strings.invalidScope;
      });
      return null;
    }

    DateTime? requestValidFrom;
    DateTime? requestValidUntil;
    if (role == RoleCode.deputyBranchManager) {
      requestValidFrom = validFrom ?? DateTime.now();
      requestValidUntil = validUntil;
      if (requestValidUntil == null ||
          !requestValidUntil.isAfter(requestValidFrom)) {
        setState(() {
          currentStep = _stepIndexFor(_AddRoleAssignmentStep.validity);
          validFrom = requestValidFrom;
          validUntilError = requestValidUntil == null
              ? strings.validUntilRequired
              : strings.validUntilAfterFrom;
          dialogError = validUntilError;
        });
        return null;
      }
    }

    return AddRoleAssignmentRequest(
      targetEmployeeId: widget.target.employee.id,
      roleCode: role,
      areaId: areaId,
      branchId: branchId,
      validFrom: requestValidFrom,
      validUntil: requestValidUntil,
    );
  }

  ReplaceRoleAssignmentRequest? _buildValidatedReplaceRequest(
    AppStrings strings,
  ) {
    final detail = widget.editingDetail;
    if (detail == null) {
      setState(() {
        dialogError = strings.assignmentUpdateFailed;
      });
      return null;
    }

    if (!widget.access.canEndRoleAssignment(
      target: widget.target,
      detail: detail,
      at: DateTime.now(),
    )) {
      setState(() {
        dialogError = strings.unauthorized;
      });
      return null;
    }

    final role = selectedRole;
    if (role == null || !widget.access.canAssignRole(role)) {
      setState(() {
        currentStep = _stepIndexFor(_AddRoleAssignmentStep.role);
        roleError = strings.invalidRole;
        dialogError = strings.invalidRole;
      });
      return null;
    }

    String? areaId;
    String? branchId;

    if (role == RoleCode.areaManager) {
      areaId = selectedAreaId;
      if (areaId == null || !widget.access.canUseArea(areaId)) {
        setState(() {
          currentStep = _stepIndexFor(_AddRoleAssignmentStep.scope);
          scopeError = strings.invalidScope;
          dialogError = strings.invalidScope;
        });
        return null;
      }
    } else if (_isBranchScopedRole(role)) {
      branchId = selectedBranchId;
      if (branchId == null || !widget.access.canUseBranch(branchId)) {
        setState(() {
          currentStep = _stepIndexFor(_AddRoleAssignmentStep.scope);
          scopeError = strings.invalidScope;
          dialogError = strings.invalidScope;
        });
        return null;
      }
    } else if (selectedAreaId != null || selectedBranchId != null) {
      setState(() {
        currentStep = _stepIndexFor(_AddRoleAssignmentStep.scope);
        scopeError = strings.invalidScope;
        dialogError = strings.invalidScope;
      });
      return null;
    }

    DateTime? requestValidUntil;
    if (role == RoleCode.deputyBranchManager) {
      final startsAt = validFrom ?? DateTime.now();
      requestValidUntil = validUntil;
      if (requestValidUntil == null || !requestValidUntil.isAfter(startsAt)) {
        setState(() {
          currentStep = _stepIndexFor(_AddRoleAssignmentStep.validity);
          validFrom = startsAt;
          validUntilError = requestValidUntil == null
              ? strings.validUntilRequired
              : strings.validUntilAfterFrom;
          dialogError = validUntilError;
        });
        return null;
      }
    }

    return ReplaceRoleAssignmentRequest(
      roleAssignmentId: detail.assignment.id,
      roleCode: role,
      areaId: areaId,
      branchId: branchId,
      validUntil: requestValidUntil,
    );
  }

  bool _assignmentChanged(ReplaceRoleAssignmentRequest request) {
    final detail = widget.editingDetail;
    if (detail == null) {
      return true;
    }

    final original = detail.assignment;
    final role = request.roleCode;

    if (original.role.role != role) {
      return true;
    }

    if (_normalizedId(original.areaId) != _normalizedId(request.areaId)) {
      return true;
    }

    if (_normalizedId(original.branchId) != _normalizedId(request.branchId)) {
      return true;
    }

    if (role != RoleCode.deputyBranchManager) {
      return false;
    }

    return !_sameDateTime(original.validUntil, request.validUntil);
  }

  String? _selectedAreaName() {
    final areaId = selectedAreaId;
    if (areaId == null) {
      return null;
    }

    for (final area in widget.access.allowedAreas) {
      if (area.id == areaId) {
        return area.name;
      }
    }

    return null;
  }

  String? _selectedBranchName() {
    final branchId = selectedBranchId;
    if (branchId == null) {
      return null;
    }

    for (final branch in widget.access.allowedBranches) {
      if (branch.remoteId == branchId) {
        return branch.name;
      }
    }

    return null;
  }
}

class _EmployeeDetailsScreen extends ConsumerStatefulWidget {
  final EmployeeDirectoryEntryModel entry;

  const _EmployeeDetailsScreen({required this.entry});

  @override
  ConsumerState<_EmployeeDetailsScreen> createState() =>
      _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState
    extends ConsumerState<_EmployeeDetailsScreen> {
  String? detailsError;

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final directoryAsync = ref.watch(employeeDirectoryProvider);
    final accessAsync = ref.watch(roleAssignmentManagementAccessProvider);
    final displayEntry =
        _findDirectoryEntry(directoryAsync.value, widget.entry.employee.id) ??
        widget.entry;
    final access = accessAsync.value;
    final canAddRole = access?.canAddRoleToTarget(displayEntry) ?? false;
    final now = DateTime.now();
    final error = detailsError;

    return AppFrame(
      title: strings.employeeDetails,
      child: AppScrollbar(
        builder: (controller) {
          return ListView(
            controller: controller,
            children: [
              SectionTitle(
                title: displayEntry.employee.name,
                icon: Icons.person_outline,
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                AppErrorBanner(message: error),
              ],
              if (canAddRole && access != null) ...[
                const SizedBox(height: 12),
                Center(
                  child: FilledButton.icon(
                    onPressed: () {
                      _showAddRoleAssignmentDialog(
                        context: context,
                        ref: ref,
                        target: displayEntry,
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(strings.addRole),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              _DetailsSection(
                title: strings.identity,
                icon: Icons.badge_outlined,
                children: [
                  _InfoRow(
                    label: strings.fullName,
                    value: displayEntry.employee.name,
                  ),
                  _InfoRow(
                    label: strings.phoneNumber,
                    value: displayEntry.employee.phone,
                  ),
                  _InfoRow(
                    label: strings.status,
                    value: displayEntry.employee.isActive
                        ? strings.active
                        : strings.inactive,
                  ),
                  _InfoRow(
                    label: strings.authStatus,
                    value: _authStatusLabel(displayEntry.employee, strings),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _DetailsSection(
                title: strings.currentRoles,
                icon: Icons.admin_panel_settings_outlined,
                children: displayEntry.effectiveRoles.isEmpty
                    ? [_MutedText(strings.noEffectiveRoles)]
                    : displayEntry.effectiveRoles
                          .map(
                            (detail) => _RoleAssignmentRow(
                              detail: detail,
                              strings: strings,
                              status: detail.assignment.statusAt(now),
                              onEdit:
                                  access?.canEndRoleAssignment(
                                        target: displayEntry,
                                        detail: detail,
                                        at: now,
                                      ) ??
                                      false
                                  ? () {
                                      _showEditRoleAssignmentDialog(
                                        context: context,
                                        ref: ref,
                                        target: displayEntry,
                                        detail: detail,
                                      );
                                    }
                                  : null,
                              onEnd:
                                  access?.canEndRoleAssignment(
                                        target: displayEntry,
                                        detail: detail,
                                        at: now,
                                      ) ??
                                      false
                                  ? () {
                                      _confirmEndRoleAssignment(detail: detail);
                                    }
                                  : null,
                            ),
                          )
                          .toList(),
              ),
              if (displayEntry.accessibleBranches.isNotEmpty) ...[
                const SizedBox(height: 14),
                _DetailsSection(
                  title: strings.accessibleBranches,
                  icon: Icons.business_outlined,
                  children: _nameRows(displayEntry.accessibleBranches),
                ),
              ],
              if (displayEntry.accessibleAreas.isNotEmpty) ...[
                const SizedBox(height: 14),
                _DetailsSection(
                  title: strings.accessibleAreas,
                  icon: Icons.map_outlined,
                  children: _areaRows(displayEntry.accessibleAreas),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmEndRoleAssignment({
    required EmployeeRoleAssignmentDetailModel detail,
  }) async {
    final strings = ref.read(appStringsProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.endRoleAssignment),
          content: Text(strings.endRoleAssignmentMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(strings.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(strings.endRole),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      detailsError = null;
    });

    try {
      final result = await ref
          .read(globalLoadingProvider.notifier)
          .runWithLoading(() {
            return ref
                .read(inventoryRepositoryProvider)
                .endEmployeeRoleAssignment(
                  EndRoleAssignmentRequest(
                    roleAssignmentId: detail.assignment.id,
                  ),
                );
          });

      if (!mounted) {
        return;
      }

      if (result == EndRoleAssignmentResult.ended) {
        ref.invalidate(employeeDirectoryProvider);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.roleEndedSuccessfully)));
        return;
      }

      ref.invalidate(employeeDirectoryProvider);
      setState(() {
        detailsError = _endRoleAssignmentResultMessage(result, strings);
      });
    } catch (error, stackTrace) {
      debugPrint('End role assignment failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          detailsError = strings.endRoleAssignmentFailed;
        });
      }
    }
  }

  List<Widget> _nameRows(List<BranchModel> branches) {
    return branches.map((branch) => _PlainText(branch.name)).toList();
  }

  List<Widget> _areaRows(List<AreaModel> areas) {
    return areas.map((area) => _PlainText(area.name)).toList();
  }
}

class _EmployeeEditScreen extends ConsumerStatefulWidget {
  final EmployeeDirectoryEntryModel entry;

  const _EmployeeEditScreen({required this.entry});

  @override
  ConsumerState<_EmployeeEditScreen> createState() =>
      _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends ConsumerState<_EmployeeEditScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  var saving = false;
  String? nameError;
  String? phoneError;
  String? formError;

  EmployeeModel get employee => widget.entry.employee;

  @override
  void initState() {
    super.initState();
    nameController.text = employee.name;
    phoneController.text = employee.phone;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final error = formError;

    return AppFrame(
      title: strings.editEmployee,
      child: AppScrollbar(
        builder: (controller) {
          return ListView(
            controller: controller,
            children: [
              SectionTitle(
                title: strings.editEmployee,
                subtitle: employee.name,
                icon: Icons.edit_outlined,
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                AppErrorBanner(message: error),
              ],
              const SizedBox(height: 18),
              AppListCard(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.badge_outlined,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            strings.identity,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: nameController,
                        label: strings.fullName,
                        icon: Icons.person_outline,
                        errorText: nameError,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: phoneController,
                        label: strings.phoneNumber,
                        hintText: '054-1234567',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.number,
                        errorText: phoneError,
                        inputFormatters: const [IsraeliPhoneInputFormatter()],
                      ),
                      const SizedBox(height: 14),
                      _InfoRow(
                        label: strings.status,
                        value: employee.isActive
                            ? strings.active
                            : strings.inactive,
                      ),
                      _InfoRow(
                        label: strings.authStatus,
                        value: _authStatusLabel(employee, strings),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: saving ? null : () => Navigator.pop(context),
                      child: Text(strings.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: saving ? null : () => _save(strings),
                      child: saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(strings.save),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _save(AppStrings strings) async {
    if (!_validate(strings)) {
      return;
    }

    final name = nameController.text.trim();
    final phone = IsraeliPhoneNormalizer.normalizeToLocalStorage(
      phoneController.text,
    );

    if (name == employee.name.trim() && phone == employee.phone.trim()) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      saving = true;
      formError = null;
    });

    try {
      await ref.read(globalLoadingProvider.notifier).runWithLoading<void>(() {
        return ref
            .read(inventoryRepositoryProvider)
            .updateEmployeeForManagement(
              employee: employee,
              name: name,
              phone: phone,
            );
      });

      if (!mounted) {
        return;
      }

      ref.invalidate(employeeDirectoryProvider);
      await _refreshCurrentSessionIfNeeded(ref: ref, target: widget.entry);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.employeeUpdated)));
      Navigator.pop(context);
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        formError = error.message == 'Employee phone already exists.'
            ? strings.duplicatePhone
            : strings.employeeUpdateFailed;
      });
    } catch (error, stackTrace) {
      debugPrint('Update employee failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      setState(() {
        formError = strings.employeeUpdateFailed;
      });
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  bool _validate(AppStrings strings) {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    String? nextNameError;
    String? nextPhoneError;

    if (name.isEmpty) {
      nextNameError = strings.employeeNameRequired;
    }

    if (phone.isEmpty) {
      nextPhoneError = strings.phoneRequired;
    } else {
      try {
        IsraeliPhoneNormalizer.normalizeToLocalStorage(phone);
      } on FormatException {
        nextPhoneError = strings.invalidPhone;
      }
    }

    setState(() {
      nameError = nextNameError;
      phoneError = nextPhoneError;
      formError = nextNameError ?? nextPhoneError;
    });

    return nextNameError == null && nextPhoneError == null;
  }
}

class _EmployeeDirectoryTile extends StatelessWidget {
  final EmployeeDirectoryEntryModel entry;
  final AppStrings strings;
  final bool canEdit;
  final bool canDelete;
  final VoidCallback onEdit;
  final VoidCallback onManageAssignments;
  final VoidCallback onDelete;

  const _EmployeeDirectoryTile({
    required this.entry,
    required this.strings,
    required this.canEdit,
    required this.canDelete,
    required this.onEdit,
    required this.onManageAssignments,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final employee = entry.employee;

    return AppListCard(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
          child: const Icon(Icons.person_outline, color: AppTheme.primary),
        ),
        title: Text(employee.name),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(employee.phone),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _StatusChip(
                    label: employee.isActive
                        ? strings.active
                        : strings.inactive,
                    color: employee.isActive
                        ? AppTheme.success
                        : AppTheme.error,
                  ),
                  _StatusChip(
                    label: _authStatusLabel(employee, strings),
                    color: employee.authUserId == null
                        ? AppTheme.textMuted
                        : AppTheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              tooltip: strings.editEmployee,
              onPressed: canEdit ? onEdit : null,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: strings.manageAssignments,
              onPressed: onManageAssignments,
              icon: const Icon(Icons.manage_accounts_outlined),
            ),
            IconButton(
              tooltip: strings.deleteEmployee,
              onPressed: canDelete ? onDelete : null,
              icon: const Icon(Icons.delete_outline, color: AppTheme.error),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleAssignmentRow extends StatelessWidget {
  final EmployeeRoleAssignmentDetailModel detail;
  final AppStrings strings;
  final RoleAssignmentStatus status;
  final VoidCallback? onEdit;
  final VoidCallback? onEnd;

  const _RoleAssignmentRow({
    required this.detail,
    required this.strings,
    required this.status,
    this.onEdit,
    this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    final assignment = detail.assignment;
    final metadata = <String>[
      if (detail.branch != null) '${strings.branch}: ${detail.branch!.name}',
      if (detail.area != null) '${strings.area}: ${detail.area!.name}',
      '${strings.validity}: ${_validityLabel(assignment, strings)}',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _roleLabel(assignment.role.role, strings),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(
                label: _roleAssignmentStatusLabel(status, strings),
                color: _roleAssignmentStatusColor(status),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            metadata.join('\n'),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
          ),
          if (onEdit != null || onEnd != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.end,
                children: [
                  if (onEdit != null)
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(strings.editAssignment),
                    ),
                  if (onEnd != null)
                    TextButton.icon(
                      onPressed: onEnd,
                      icon: const Icon(Icons.block_outlined),
                      label: Text(strings.endRole),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ] else if (status == RoleAssignmentStatus.effective) ...[
            const SizedBox(height: 8),
            _MutedText(strings.protectedRole),
          ],
        ],
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _DetailsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _WizardStepHeader extends StatelessWidget {
  final List<String> labels;
  final int currentStep;

  const _WizardStepHeader({required this.labels, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var index = 0; index < labels.length; index++)
          _WizardStepChip(
            number: index + 1,
            label: labels[index],
            active: index == currentStep,
            complete: index < currentStep,
          ),
      ],
    );
  }
}

class _WizardStepChip extends StatelessWidget {
  final int number;
  final String label;
  final bool active;
  final bool complete;

  const _WizardStepChip({
    required this.number,
    required this.label,
    required this.active,
    required this.complete,
  });

  @override
  Widget build(BuildContext context) {
    final color = active || complete ? AppTheme.primary : AppTheme.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: active ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: color,
            child: complete
                ? const Icon(Icons.check, size: 13, color: Colors.white)
                : Text(
                    number.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewSummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ReviewSummaryItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.textMuted, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedScopeValue extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SelectedScopeValue({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.textMuted, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScopeContent extends StatelessWidget {
  final Widget child;
  final String? errorText;

  const _ScopeContent({required this.child, this.errorText});

  @override
  Widget build(BuildContext context) {
    final error = errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.error),
          ),
        ],
      ],
    );
  }
}

class _PlainText extends StatelessWidget {
  final String value;

  const _PlainText(this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _MutedText extends StatelessWidget {
  final String value;

  const _MutedText(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
    );
  }
}

String _createEmployeeStepTitle(AppStrings strings, _CreateEmployeeStep step) {
  return switch (step) {
    _CreateEmployeeStep.identity => strings.identity,
    _CreateEmployeeStep.role => strings.selectRole,
    _CreateEmployeeStep.scope => strings.scope,
    _CreateEmployeeStep.validity => strings.validity,
    _CreateEmployeeStep.review => strings.review,
  };
}

String _addRoleAssignmentStepTitle(
  AppStrings strings,
  _AddRoleAssignmentStep step,
) {
  return switch (step) {
    _AddRoleAssignmentStep.role => strings.selectRole,
    _AddRoleAssignmentStep.scope => strings.scope,
    _AddRoleAssignmentStep.validity => strings.validity,
    _AddRoleAssignmentStep.review => strings.review,
  };
}

List<_AddRoleAssignmentStep> _addRoleAssignmentSteps(RoleCode? role) {
  return [
    _AddRoleAssignmentStep.role,
    _AddRoleAssignmentStep.scope,
    if (role == RoleCode.deputyBranchManager) _AddRoleAssignmentStep.validity,
    _AddRoleAssignmentStep.review,
  ];
}

String _authStatusLabel(EmployeeModel employee, AppStrings strings) {
  final authUserId = employee.authUserId?.trim();

  return authUserId == null || authUserId.isEmpty
      ? strings.notLinked
      : strings.linked;
}

List<RoleCode> _assignableRoles(EmployeeCreationAccess access) {
  const order = [
    RoleCode.systemManager,
    RoleCode.areaManager,
    RoleCode.branchManager,
    RoleCode.deputyBranchManager,
    RoleCode.storeEmployee,
    RoleCode.viewer,
  ];

  return order.where(access.canAssignRole).toList(growable: false);
}

List<RoleCode> _assignableAssignmentRoles(
  RoleAssignmentManagementAccess access,
) {
  const order = [
    RoleCode.systemManager,
    RoleCode.areaManager,
    RoleCode.branchManager,
    RoleCode.deputyBranchManager,
    RoleCode.storeEmployee,
    RoleCode.viewer,
  ];

  return order.where(access.canAssignRole).toList(growable: false);
}

bool _isBranchScopedRole(RoleCode role) {
  return switch (role) {
    RoleCode.branchManager ||
    RoleCode.deputyBranchManager ||
    RoleCode.storeEmployee ||
    RoleCode.viewer => true,
    RoleCode.developer ||
    RoleCode.systemManager ||
    RoleCode.areaManager => false,
  };
}

EmployeeDirectoryEntryModel? _findDirectoryEntry(
  List<EmployeeDirectoryEntryModel>? entries,
  String employeeId,
) {
  if (entries == null) {
    return null;
  }

  for (final entry in entries) {
    if (entry.employee.id == employeeId) {
      return entry;
    }
  }

  return null;
}

String _createEmployeeResultMessage(
  CreateEmployeeResult result,
  AppStrings strings,
) {
  return switch (result) {
    CreateEmployeeResult.created => strings.employeeCreatedWithRole,
    CreateEmployeeResult.duplicatePhone => strings.duplicatePhone,
    CreateEmployeeResult.duplicateEmployeeCode => strings.duplicateEmployeeCode,
    CreateEmployeeResult.invalidRole => strings.invalidRole,
    CreateEmployeeResult.invalidScope => strings.invalidScope,
    CreateEmployeeResult.unauthorized => strings.unauthorized,
    CreateEmployeeResult.employeeCreationFailed ||
    CreateEmployeeResult.assignmentCreationFailed ||
    CreateEmployeeResult.operationFailed => strings.employeeCreationFailed,
  };
}

String _addRoleAssignmentResultMessage(
  AddRoleAssignmentResult result,
  AppStrings strings,
) {
  return switch (result) {
    AddRoleAssignmentResult.created => strings.assignmentCreated,
    AddRoleAssignmentResult.assignmentNotFound =>
      strings.assignmentCreationFailed,
    AddRoleAssignmentResult.employeeNotFound =>
      strings.assignmentEmployeeNotFound,
    AddRoleAssignmentResult.employeeInactive =>
      strings.assignmentEmployeeInactive,
    AddRoleAssignmentResult.invalidRole => strings.invalidRole,
    AddRoleAssignmentResult.invalidScope => strings.invalidScope,
    AddRoleAssignmentResult.invalidValidity => strings.invalidValidity,
    AddRoleAssignmentResult.duplicateAssignment => strings.duplicateAssignment,
    AddRoleAssignmentResult.overlappingAssignment =>
      strings.overlappingAssignment,
    AddRoleAssignmentResult.unauthorized => strings.unauthorized,
    AddRoleAssignmentResult.selfManagementNotAllowed =>
      strings.selfManagementNotAllowed,
    AddRoleAssignmentResult.protectedRole => strings.protectedRole,
    AddRoleAssignmentResult.operationFailed => strings.assignmentCreationFailed,
  };
}

String _endRoleAssignmentResultMessage(
  EndRoleAssignmentResult result,
  AppStrings strings,
) {
  return switch (result) {
    EndRoleAssignmentResult.ended => strings.roleEndedSuccessfully,
    EndRoleAssignmentResult.alreadyEnded => strings.roleAssignmentAlreadyEnded,
    EndRoleAssignmentResult.assignmentNotFound =>
      strings.roleAssignmentNotFound,
    EndRoleAssignmentResult.employeeNotFound =>
      strings.assignmentEmployeeNotFound,
    EndRoleAssignmentResult.employeeInactive =>
      strings.assignmentEmployeeInactive,
    EndRoleAssignmentResult.invalidValidity => strings.invalidEndTime,
    EndRoleAssignmentResult.unauthorized => strings.unauthorized,
    EndRoleAssignmentResult.selfManagementNotAllowed =>
      strings.selfManagementNotAllowed,
    EndRoleAssignmentResult.protectedRole => strings.protectedRole,
    EndRoleAssignmentResult.operationFailed => strings.endRoleAssignmentFailed,
  };
}

String _replaceRoleAssignmentResultMessage(
  ReplaceRoleAssignmentResult result,
  AppStrings strings,
) {
  return switch (result) {
    ReplaceRoleAssignmentResult.replaced => strings.assignmentUpdated,
    ReplaceRoleAssignmentResult.unchanged => strings.noAssignmentChanges,
    ReplaceRoleAssignmentResult.unauthorized => strings.unauthorized,
    ReplaceRoleAssignmentResult.assignmentNotFound =>
      strings.roleAssignmentNotFound,
    ReplaceRoleAssignmentResult.employeeNotFound =>
      strings.assignmentEmployeeNotFound,
    ReplaceRoleAssignmentResult.employeeInactive =>
      strings.assignmentEmployeeInactive,
    ReplaceRoleAssignmentResult.protectedRole => strings.protectedRole,
    ReplaceRoleAssignmentResult.alreadyEnded =>
      strings.roleAssignmentAlreadyEnded,
    ReplaceRoleAssignmentResult.invalidRole => strings.invalidRole,
    ReplaceRoleAssignmentResult.invalidScope => strings.invalidScope,
    ReplaceRoleAssignmentResult.invalidValidity => strings.invalidValidity,
    ReplaceRoleAssignmentResult.duplicateAssignment =>
      strings.duplicateAssignment,
    ReplaceRoleAssignmentResult.overlappingAssignment =>
      strings.overlappingAssignment,
    ReplaceRoleAssignmentResult.operationFailed =>
      strings.assignmentUpdateFailed,
  };
}

String _deactivateEmployeeResultMessage(
  DeactivateEmployeeResult result,
  AppStrings strings,
) {
  return switch (result) {
    DeactivateEmployeeResult.deactivated => strings.employeeDeactivated,
    DeactivateEmployeeResult.partiallyDeactivated =>
      strings.employeePartiallyDeactivated,
    DeactivateEmployeeResult.nothingToDeactivate =>
      strings.employeeNothingToDeactivate,
    DeactivateEmployeeResult.employeeNotFound => strings.employeeNotFound,
    DeactivateEmployeeResult.employeeInactive =>
      strings.employeeAlreadyInactive,
    DeactivateEmployeeResult.protectedRole => strings.protectedRole,
    DeactivateEmployeeResult.selfManagementNotAllowed =>
      strings.selfManagementNotAllowed,
    DeactivateEmployeeResult.unauthorized =>
      strings.employeeDeactivateUnauthorized,
    DeactivateEmployeeResult.operationFailed =>
      strings.employeeDeactivateFailed,
  };
}

String _roleLabel(RoleCode role, AppStrings strings) {
  return switch (role) {
    RoleCode.developer => strings.roleDeveloper,
    RoleCode.systemManager => strings.roleSystemManager,
    RoleCode.areaManager => strings.roleAreaManager,
    RoleCode.branchManager => strings.roleBranchManager,
    RoleCode.deputyBranchManager => strings.roleDeputyBranchManager,
    RoleCode.storeEmployee => strings.roleStoreEmployee,
    RoleCode.viewer => strings.roleViewer,
  };
}

String _roleAssignmentStatusLabel(
  RoleAssignmentStatus status,
  AppStrings strings,
) {
  return switch (status) {
    RoleAssignmentStatus.effective => strings.effective,
    RoleAssignmentStatus.future => strings.future,
    RoleAssignmentStatus.expired => strings.expired,
    RoleAssignmentStatus.inactive => strings.ended,
  };
}

Color _roleAssignmentStatusColor(RoleAssignmentStatus status) {
  return switch (status) {
    RoleAssignmentStatus.effective => AppTheme.success,
    RoleAssignmentStatus.future => AppTheme.primary,
    RoleAssignmentStatus.expired => AppTheme.textMuted,
    RoleAssignmentStatus.inactive => AppTheme.error,
  };
}

String _validityLabel(RoleAssignmentModel assignment, AppStrings strings) {
  final validFrom = assignment.validFrom;
  final validUntil = assignment.validUntil;

  if (validFrom == null && validUntil == null) {
    return strings.alwaysValid;
  }

  final parts = <String>[
    if (validFrom != null) _formatDate(validFrom),
    if (validUntil != null) _formatDate(validUntil),
  ];

  return parts.join(' - ');
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final year = local.year.toString();

  return '$day/$month/$year';
}

String? _normalizedId(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

bool _sameDateTime(DateTime? first, DateTime? second) {
  if (first == null || second == null) {
    return first == second;
  }

  return first.toUtc().isAtSameMomentAs(second.toUtc());
}
