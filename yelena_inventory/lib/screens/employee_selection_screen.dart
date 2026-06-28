import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/employees_provider.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('בחירת עובד')),
      body: employeesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(child: Text(error.toString())),

        data: (employees) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'בחר עובד',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

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

                        return RadioListTile<Employee>(
                          value: employee,
                          title: Text(employee.name),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
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
                    child: const Text('המשך'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
