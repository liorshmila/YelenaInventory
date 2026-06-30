import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/branch_model.dart';
import '../providers/branch_provider.dart';
import '../providers/employees_provider.dart';
import '../providers/repository_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
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

    return AppFrame(
      child: branchesAsync.when(
        loading: () => const LoadingView(message: 'Loading branches...'),
        error: (error, stack) => ErrorView(
          message: 'Could not load branches.',
          onRetry: () {
            ref.invalidate(branchesProvider);
          },
        ),
        data: (branches) {
          if (branches.isEmpty) {
            return const EmptyState(
              icon: Icons.business_outlined,
              message: 'No branches found',
            );
          }

          final activeBranch = _activeBranch(branches);
          final employeesAsync = ref.watch(
            employeesForBranchProvider(activeBranch.id),
          );

          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(
                    title: 'Manage Employees',
                    subtitle: 'Create and maintain employees by branch.',
                    icon: Icons.people_outline,
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<int>(
                    initialValue: activeBranch.id,
                    decoration: const InputDecoration(
                      labelText: 'Branch',
                      prefixIcon: Icon(Icons.business_outlined),
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
                  const SizedBox(height: 24),
                  Expanded(
                    child: employeesAsync.when(
                      loading: () =>
                          const LoadingView(message: 'Loading employees...'),
                      error: (error, stack) => ErrorView(
                        message: 'Could not load employees.',
                        onRetry: () {
                          ref.invalidate(
                            employeesForBranchProvider(activeBranch.id),
                          );
                        },
                      ),
                      data: (employees) {
                        if (employees.isEmpty) {
                          return EmptyStateWithAction(
                            icon: Icons.people_outline,
                            message: 'No employees in this branch.',
                            actionLabel: 'Create Employee',
                            onPressed: () {
                              _showEmployeeDialog(
                                context: context,
                                ref: ref,
                                branches: branches,
                                initialBranch: activeBranch,
                              );
                            },
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 96),
                          itemCount: employees.length,
                          itemBuilder: (context, index) {
                            final employee = employees[index];

                            return _EmployeeManagementTile(
                              employee: employee,
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
                child: FloatingActionButton.extended(
                  onPressed: () {
                    _showEmployeeDialog(
                      context: context,
                      ref: ref,
                      branches: branches,
                      initialBranch: activeBranch,
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Employee'),
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
    Employee? employee,
  }) async {
    final nameParts = _splitEmployeeName(employee?.name ?? '');
    final firstNameController = TextEditingController(text: nameParts.first);
    final lastNameController = TextEditingController(text: nameParts.last);
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isEditing = employee != null;
    var dialogBranchId = employee?.branchId ?? initialBranch.id;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Employee' : 'Add Employee'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: firstNameController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'First name is required.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Last name is required.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          final phone = value?.trim() ?? '';

                          if (phone.isEmpty) {
                            return 'Phone number is required.';
                          }

                          if (!RegExp(r'^\d+$').hasMatch(phone)) {
                            return 'Phone must contain digits only.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        initialValue: dialogBranchId,
                        decoration: const InputDecoration(
                          labelText: 'Branch',
                          prefixIcon: Icon(Icons.business_outlined),
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

                          setDialogState(() {
                            dialogBranchId = value;
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
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    _saveEmployee(
                      context: context,
                      dialogContext: dialogContext,
                      ref: ref,
                      formKey: formKey,
                      firstNameController: firstNameController,
                      lastNameController: lastNameController,
                      phoneController: phoneController,
                      branchId: dialogBranchId,
                      employee: employee,
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
  }

  Future<void> _saveEmployee({
    required BuildContext context,
    required BuildContext dialogContext,
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController phoneController,
    required int branchId,
    Employee? employee,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final repository = ref.read(inventoryRepositoryProvider);
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();
    final fullName = '$firstName $lastName'.trim();
    final exists = await repository.employeeNameExistsInBranch(
      fullName: fullName,
      branchId: branchId,
      excludeId: employee?.id,
    );

    if (!context.mounted || !dialogContext.mounted) {
      return;
    }

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An employee with this name already exists here.'),
        ),
      );
      return;
    }

    if (employee == null) {
      await repository.addEmployee(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        branchId: branchId,
      );
    } else {
      await repository.updateEmployee(
        id: employee.id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        branchId: branchId,
      );
    }

    ref.invalidate(employeesProvider);
    ref.invalidate(employeesForBranchProvider(branchId));
    if (employee != null && employee.branchId != branchId) {
      ref.invalidate(employeesForBranchProvider(employee.branchId));
    }

    if (!context.mounted || !dialogContext.mounted) {
      return;
    }

    Navigator.pop(dialogContext);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          employee == null ? 'Employee created.' : 'Employee updated.',
        ),
      ),
    );
  }

  Future<void> _confirmDeleteEmployee({
    required BuildContext context,
    required WidgetRef ref,
    required Employee employee,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Employee'),
          content: Text('Delete employee\n${employee.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(inventoryRepositoryProvider).deleteEmployee(employee.id);
      ref.invalidate(employeesProvider);
      ref.invalidate(employeesForBranchProvider(employee.branchId));

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Employee deleted.')));
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete this employee.')),
      );
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
}

class _EmployeeManagementTile extends StatelessWidget {
  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EmployeeManagementTile({
    required this.employee,
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
              tooltip: 'Edit',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: AppTheme.error),
            ),
          ],
        ),
      ),
    );
  }
}
