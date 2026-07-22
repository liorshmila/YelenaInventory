import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../providers/current_session_provider.dart';
import '../providers/role_assignment_management_access_provider.dart';
import '../services/app_version_service.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/current_user_header.dart';
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
    final canManageBranches = ref.watch(canManageBranchesProvider);
    final canManageEmployees =
        ref
            .watch(roleAssignmentManagementAccessProvider)
            .value
            ?.canAddRoleAssignments ??
        false;

    return AppFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CurrentUserHeader(),
          const SizedBox(height: 14),
          Expanded(
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
                    if (canManageBranches)
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
                          subtitle: Text(strings.settingsBranchesSubtitle),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    if (canManageEmployees)
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
                          subtitle: Text(strings.settingsEmployeesSubtitle),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    AppListCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AuditLogScreen(),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(Icons.history_outlined),
                        title: Text(
                          strings.auditLog,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(strings.settingsAuditLogSubtitle),
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
                    AppListCard(
                      onTap: () {
                        _showAboutDialog(context: context, ref: ref);
                      },
                      child: ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: Text(
                          strings.about,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(strings.aboutSubtitle),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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

  Future<void> _showAboutDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final strings = ref.read(appStringsProvider);
    final appVersion = await AppVersionService.getInstalledVersion();
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final textTheme = Theme.of(dialogContext).textTheme;

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.asset(
                    'assets/logos/YelenaInventoryLogo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                strings.appTitle,
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                strings.inventoryManagementSystem,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (appVersion != null) ...[
                Text(
                  '${strings.version} ${appVersion.version}',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${strings.build} ${appVersion.buildNumber}',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              Text(
                '© 2026',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(strings.close),
            ),
          ],
        );
      },
    );
  }
}
