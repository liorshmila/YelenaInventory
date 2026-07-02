import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/section_title.dart';
import 'audit_log_screen.dart';
import 'branch_management_screen.dart';
import 'employee_management_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final language = ref.watch(languageProvider);

    return AppFrame(
      child: AppScrollbar(
        builder: (controller) {
          return ListView(
            controller: controller,
            children: [
              SectionTitle(
                title: strings.settings,
                subtitle: strings.settingsSubtitle,
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
                    strings.branches,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    strings.isHebrew
                        ? 'יצירה, עריכה ומחיקה של סניפים'
                        : 'Create, edit, and delete branches',
                  ),
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
                    strings.employees,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    strings.isHebrew
                        ? 'יצירה, עריכה ומחיקה של עובדים'
                        : 'Create, edit, and delete employees',
                  ),
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
                    strings.auditLog,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    strings.isHebrew
                        ? 'סקירת פעולות חשובות באפליקציה'
                        : 'Review important app activity',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
              AppListCard(
                onTap: () {
                  _showLanguageDialog(context: context, ref: ref);
                },
                child: ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(
                    strings.language,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    '${strings.languageSubtitle}: ${language.label}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showLanguageDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final strings = ref.read(appStringsProvider);
    final selectedLanguage = ref.read(languageProvider);

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.chooseLanguage),
          content: RadioGroup<AppLanguage>(
            groupValue: selectedLanguage,
            onChanged: (value) {
              if (value == null) {
                return;
              }

              ref.read(languageProvider.notifier).setLanguage(value);
              Navigator.pop(dialogContext);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppLanguage.values.map((language) {
                return RadioListTile<AppLanguage>(
                  value: language,
                  title: Text(language.label),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(strings.cancel),
            ),
          ],
        );
      },
    );
  }
}
