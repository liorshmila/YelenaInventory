import 'package:flutter/material.dart';

import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/section_title.dart';
import 'audit_log_screen.dart';
import 'branch_management_screen.dart';
import 'employee_management_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: AppScrollbar(
        builder: (controller) {
          return ListView(
            controller: controller,
            children: [
              const SectionTitle(
                title: 'Settings',
                subtitle: 'Manage application setup and master data.',
                icon: Icons.settings_outlined,
              ),
              const SizedBox(height: 18),
              AppListCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BranchManagementScreen(),
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(Icons.business_outlined),
                  title: Text(
                    'Branches',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: const Text('Create, edit, and delete branches'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
              AppListCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmployeeManagementScreen(),
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(Icons.people_outline),
                  title: Text(
                    'Employees',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: const Text('Create, edit, and delete employees'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
              AppListCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AuditLogScreen()),
                  );
                },
                child: ListTile(
                  leading: const Icon(Icons.history_outlined),
                  title: Text(
                    'Audit Log',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: const Text('Review important app activity'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
