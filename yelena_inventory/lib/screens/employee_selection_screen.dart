import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../localization/app_language.dart';
import '../providers/employees_provider.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/section_title.dart';
import 'scan_screen.dart';

class EmployeeSelectionScreen extends ConsumerStatefulWidget {
  const EmployeeSelectionScreen({super.key});

  @override
  ConsumerState<EmployeeSelectionScreen> createState() =>
      _EmployeeSelectionScreenState();
}

class _EmployeeSelectionScreenState
    extends ConsumerState<EmployeeSelectionScreen> {
  Employee? selectedEmployee;

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesProvider);
    final strings = ref.watch(appStringsProvider);

    return AppFrame(
      child: employeesAsync.when(
        loading: () => LoadingView(message: strings.loadingEmployees),
        error: (error, stack) => ErrorView(
          message: strings.couldNotLoadEmployees,
          retryLabel: strings.retry,
          onRetry: () {
            ref.invalidate(employeesProvider);
          },
        ),
        data: (employees) {
          if (employees.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              message:
                  '${strings.noEmployeesInBranch}\n${strings.addEmployeesFromSettings}',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: strings.chooseEmployee,
                subtitle: strings.chooseEmployeeSubtitle,
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: RadioGroup<Employee>(
                  groupValue: selectedEmployee,
                  onChanged: (value) {
                    setState(() {
                      selectedEmployee = value;
                    });
                  },
                  child: AppScrollbar(
                    builder: (controller) {
                      return ListView.builder(
                        controller: controller,
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];

                          return AppListCard(
                            child: RadioListTile<Employee>(
                              value: employee,
                              title: Text(
                                employee.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              secondary: const Icon(Icons.person_outline),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: strings.continueLabel,
                icon: Icons.arrow_forward,
                onPressed: selectedEmployee == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ScanScreen(employee: selectedEmployee!),
                          ),
                        );
                      },
              ),
            ],
          );
        },
      ),
    );
  }
}
