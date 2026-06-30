import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/employees_provider.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
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

    return AppFrame(
      child: employeesAsync.when(
        loading: () => const LoadingView(message: 'טוען עובדים...'),
        error: (error, stack) => ErrorView(
          message: 'לא הצלחנו לטעון את רשימת העובדים.',
          onRetry: () {
            ref.invalidate(employeesProvider);
          },
        ),
        data: (employees) {
          if (employees.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline,
              message:
                  'No employees in this branch.\nAdd employees from Settings.',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'בחר עובד',
                subtitle: 'בחר מי מבצע את ספירת המלאי.',
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: RadioGroup<Employee>(
                  groupValue: selectedEmployee,
                  onChanged: (value) {
                    setState(() {
                      selectedEmployee = value;
                    });
                  },
                  child: ListView.builder(
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
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'המשך',
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
