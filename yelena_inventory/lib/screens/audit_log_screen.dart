import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/audit_log_provider.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/section_title.dart';

enum AuditLogFilter { all, today, week, branches, employees, inventory }

class AuditLogScreen extends ConsumerStatefulWidget {
  const AuditLogScreen({super.key});

  @override
  ConsumerState<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends ConsumerState<AuditLogScreen> {
  AuditLogFilter selectedFilter = AuditLogFilter.all;

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(auditLogsProvider);

    return AppFrame(
      child: logsAsync.when(
        loading: () => const LoadingView(message: 'Loading audit log...'),
        error: (error, stack) => ErrorView(
          message: 'Could not load audit log.',
          onRetry: () {
            ref.invalidate(auditLogsProvider);
          },
        ),
        data: (logs) {
          final filteredLogs = _filterLogs(logs);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Audit Log',
                subtitle: 'Review important actions performed in the app.',
                icon: Icons.history_outlined,
              ),
              const SizedBox(height: 16),
              _AuditFilterChips(
                selectedFilter: selectedFilter,
                onSelected: (filter) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredLogs.isEmpty
                    ? const EmptyState(
                        icon: Icons.history_outlined,
                        message: 'No logs yet.',
                      )
                    : AppScrollbar(
                        builder: (controller) {
                          return ListView.builder(
                            controller: controller,
                            itemCount: filteredLogs.length,
                            itemBuilder: (context, index) {
                              return _AuditLogTile(log: filteredLogs[index]);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<AuditLog> _filterLogs(List<AuditLog> logs) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));

    return logs.where((log) {
      return switch (selectedFilter) {
        AuditLogFilter.all => true,
        AuditLogFilter.today => !log.timestamp.isBefore(todayStart),
        AuditLogFilter.week => !log.timestamp.isBefore(weekStart),
        AuditLogFilter.branches => log.entityType == 'Branch',
        AuditLogFilter.employees => log.entityType == 'Employee',
        AuditLogFilter.inventory => log.entityType == 'Inventory',
      };
    }).toList();
  }
}

class _AuditFilterChips extends StatelessWidget {
  final AuditLogFilter selectedFilter;
  final ValueChanged<AuditLogFilter> onSelected;

  const _AuditFilterChips({
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AuditLogFilter.values.map((filter) {
        return ChoiceChip(
          label: Text(_filterLabel(filter)),
          selected: selectedFilter == filter,
          onSelected: (_) {
            onSelected(filter);
          },
        );
      }).toList(),
    );
  }

  String _filterLabel(AuditLogFilter filter) {
    return switch (filter) {
      AuditLogFilter.all => 'All',
      AuditLogFilter.today => 'Today',
      AuditLogFilter.week => 'This Week',
      AuditLogFilter.branches => 'Branches',
      AuditLogFilter.employees => 'Employees',
      AuditLogFilter.inventory => 'Inventory',
    };
  }
}

class _AuditLogTile extends StatelessWidget {
  final AuditLog log;

  const _AuditLogTile({required this.log});

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      child: ListTile(
        leading: Icon(_iconFor(log.entityType)),
        title: Text(log.action, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(log.description),
              const SizedBox(height: 4),
              Text('${_date(log.timestamp)}  ${_time(log.timestamp)}'),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String entityType) {
    return switch (entityType) {
      'Branch' => Icons.business_outlined,
      'Employee' => Icons.person_outline,
      'Inventory' => Icons.inventory_2_outlined,
      _ => Icons.history_outlined,
    };
  }

  String _date(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');

    return '$day/$month/${value.year}';
  }

  String _time(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
