import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../models/branch_model.dart';
import '../models/employee_model.dart';
import '../providers/branch_provider.dart';
import '../providers/employees_provider.dart';
import '../providers/repository_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/section_title.dart';

class EmployeeManagementScreen extends ConsumerStatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  ConsumerState<EmployeeManagementScreen> createState() =>
      _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState
    extends ConsumerState<EmployeeManagementScreen> {
  BranchModel? selectedBranch;

  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(branchesProvider);
    final strings = ref.watch(appStringsProvider);

    return AppFrame(
      child: branchesAsync.when(
        loading: () => LoadingView(message: strings.loadingBranches),
        error: (error, stack) => ErrorView(
          message: strings.couldNotLoadBranches,
          retryLabel: strings.retry,
          onRetry: () {
            ref.invalidate(branchesProvider);
          },
        ),
        data: (branches) {
          if (branches.isEmpty) {
            return EmptyState(
              icon: Icons.business_outlined,
              message: strings.noBranchesFound,
            );
          }

          final activeBranch = _activeBranch(branches);
          final employeesAsync = ref.watch(
            employeeManagementEmployeesProvider(activeBranch),
          );

          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                    title: strings.manageEmployees,
                    subtitle: strings.manageEmployeesSubtitle,
                    icon: Icons.people_outline,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<int>(
                    initialValue: activeBranch.id,
                    decoration: InputDecoration(
                      labelText: strings.branch,
                      prefixIcon: const Icon(Icons.business_outlined),
                    ),
                    items: branches
                        .map(
                          (branch) => DropdownMenuItem<int>(
                            value: branch.id,
                            child: Text(branch.name),
                          ),
                        )
                        .toList(),
                    onChanged: (branchId) {
                      final branch = branches.firstWhere(
                        (item) => item.id == branchId,
                      );

                      setState(() {
                        selectedBranch = branch;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: employeesAsync.when(
                      loading: () =>
                          LoadingView(message: strings.loadingEmployees),
                      error: (error, stack) => ErrorView(
                        message: strings.couldNotLoadEmployees,
                        retryLabel: strings.retry,
                        onRetry: () {
                          ref.invalidate(
                            employeeManagementEmployeesProvider(activeBranch),
                          );
                        },
                      ),
                      data: (employees) {
                        if (employees.isEmpty) {
                          return EmptyState(
                            icon: Icons.people_outline,
                            message: strings.noEmployeesInBranch,
                          );
                        }

                        return AppScrollbar(
                          builder: (controller) {
                            return ListView.builder(
                              controller: controller,
                              padding: const EdgeInsets.only(bottom: 86),
                              itemCount: employees.length,
                              itemBuilder: (context, index) {
                                final employee = employees[index];

                                return _EmployeeManagementTile(
                                  employee: employee,
                                  editLabel: strings.edit,
                                  deleteLabel: strings.delete,
                                  onEdit: () {
                                    _showEmployeeDialog(
                                      context: context,
                                      ref: ref,
                                      branches: branches,
                                      initialBranch: activeBranch,
                                      employee: employee,
                                    );
                                  },
                                  onDelete: () {
                                    _confirmDeleteEmployee(
                                      context: context,
                                      ref: ref,
                                      employee: employee,
                                      branch: activeBranch,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    _showEmployeeDialog(
                      context: context,
                      ref: ref,
                      branches: branches,
                      initialBranch: activeBranch,
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

  BranchModel _activeBranch(List<BranchModel> branches) {
    final selected = selectedBranch;

    if (selected != null) {
      for (final branch in branches) {
        if (branch.id == selected.id) {
          return branch;
        }
      }
    }

    selectedBranch = branches.first;
    return branches.first;
  }

  Future<void> _showEmployeeDialog({
    required BuildContext context,
    required WidgetRef ref,
    required List<BranchModel> branches,
    required BranchModel initialBranch,
    EmployeeModel? employee,
  }) async {
    final nameParts = _splitEmployeeName(employee?.name ?? '');
    final firstNameController = TextEditingController(text: nameParts.first);
    final lastNameController = TextEditingController(text: nameParts.last);
    final phoneController = TextEditingController(text: employee?.phone ?? '');
    final formKey = GlobalKey<FormState>();
    final isEditing = employee != null;
    var dialogBranch = employee == null
        ? initialBranch
        : _branchForRemoteId(branches, employee.branchId) ?? initialBranch;
    final strings = ref.read(appStringsProvider);
    String? duplicateNameError;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void showDuplicateNameError() {
              setDialogState(() {
                duplicateNameError = strings.employeeExists;
              });
            }

            return AlertDialog(
              title: Text(
                isEditing ? strings.editEmployee : strings.addEmployee,
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: firstNameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: strings.firstName,
                          prefixIcon: const Icon(Icons.person_outline),
                          errorText: duplicateNameError,
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          if (duplicateNameError != null) {
                            setDialogState(() {
                              duplicateNameError = null;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return strings.firstNameRequired;
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: strings.lastName,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          if (duplicateNameError != null) {
                            setDialogState(() {
                              duplicateNameError = null;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return strings.lastNameRequired;
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: strings.phoneNumber,
                          prefixIcon: const Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          final phone = value?.trim() ?? '';

                          if (phone.isEmpty) {
                            return strings.phoneRequired;
                          }

                          if (!RegExp(r'^\d+$').hasMatch(phone)) {
                            return strings.phoneDigitsOnly;
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        initialValue: dialogBranch.id,
                        decoration: InputDecoration(
                          labelText: strings.branch,
                          prefixIcon: const Icon(Icons.business_outlined),
                        ),
                        items: branches
                            .map(
                              (branch) => DropdownMenuItem<int>(
                                value: branch.id,
                                child: Text(branch.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          final selected = branches.firstWhere(
                            (branch) => branch.id == value,
                          );

                          setDialogState(() {
                            dialogBranch = selected;
                            duplicateNameError = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text(strings.cancel),
                ),
                FilledButton(
                  onPressed: () async {
                    await _saveEmployee(
                      context: context,
                      dialogContext: dialogContext,
                      ref: ref,
                      formKey: formKey,
                      firstNameController: firstNameController,
                      lastNameController: lastNameController,
                      phoneController: phoneController,
                      branch: dialogBranch,
                      employee: employee,
                      onDuplicateName: showDuplicateNameError,
                    );
                  },
                  child: Text(strings.save),
                ),
              ],
            );
          },
        );
      },
    );

    await WidgetsBinding.instance.endOfFrame;
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();

    if (saved == true && context.mounted) {
      ref.invalidate(employeeManagementEmployeesProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            employee == null
                ? strings.employeeCreated
                : strings.employeeUpdated,
          ),
        ),
      );
    }
  }

  Future<void> _saveEmployee({
    required BuildContext context,
    required BuildContext dialogContext,
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController phoneController,
    required BranchModel branch,
    required VoidCallback onDuplicateName,
    EmployeeModel? employee,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final repository = ref.read(inventoryRepositoryProvider);
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();
    final fullName = '$firstName $lastName'.trim();
    final managementExists = await repository
        .employeeManagementNameExistsInBranch(
          fullName: fullName,
          branch: branch,
          excludeEmployeeId: employee?.id,
        );

    if (!context.mounted || !dialogContext.mounted) {
      return;
    }

    if (managementExists) {
      onDuplicateName();
      return;
    }

    try {
      if (employee == null) {
        await repository.addEmployeeForManagement(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          branch: branch,
        );
      } else {
        await repository.updateEmployeeForManagement(
          employee: employee,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          branch: branch,
        );
      }
    } on StateError catch (error) {
      if (error.message == 'Employee name already exists in this branch.') {
        onDuplicateName();
        return;
      }

      rethrow;
    }

    if (!context.mounted || !dialogContext.mounted) {
      return;
    }

    Navigator.pop(dialogContext, true);
  }

  Future<void> _confirmDeleteEmployee({
    required BuildContext context,
    required WidgetRef ref,
    required EmployeeModel employee,
    required BranchModel branch,
  }) async {
    final strings = ref.read(appStringsProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.deleteEmployeeTitle),
          content: Text(strings.deleteEmployeeMessage(employee.name)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(strings.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
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
      await ref
          .read(inventoryRepositoryProvider)
          .deactivateEmployeeForManagement(employee);
      final refreshedEmployees = await ref.refresh(
        employeeManagementEmployeesProvider(branch).future,
      );

      if (refreshedEmployees.any((item) => item.id == employee.id)) {
        throw StateError('Employee still exists after deletion.');
      }

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.employeeDeleted)));
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.couldNotDeleteEmployee)));
    }
  }

  ({String first, String last}) _splitEmployeeName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) {
      return (first: '', last: '');
    }

    if (parts.length == 1) {
      return (first: parts.first, last: '');
    }

    return (first: parts.first, last: parts.skip(1).join(' '));
  }

  BranchModel? _branchForRemoteId(List<BranchModel> branches, String remoteId) {
    for (final branch in branches) {
      if (branch.remoteId == remoteId) {
        return branch;
      }
    }

    return null;
  }
}

class _EmployeeManagementTile extends StatelessWidget {
  final EmployeeModel employee;
  final String editLabel;
  final String deleteLabel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EmployeeManagementTile({
    required this.employee,
    required this.editLabel,
    required this.deleteLabel,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person_outline)),
        title: Text(
          employee.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              tooltip: editLabel,
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: deleteLabel,
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: AppTheme.error),
            ),
          ],
        ),
      ),
    );
  }
}
