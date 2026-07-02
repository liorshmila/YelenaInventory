import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../localization/app_language.dart';
import '../providers/audit_log_provider.dart';
import '../providers/repository_provider.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/product_image_widgets.dart';
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
    final strings = ref.watch(appStringsProvider);

    return AppFrame(
      child: logsAsync.when(
        loading: () => LoadingView(message: strings.loadingAuditLog),
        error: (error, stack) => ErrorView(
          message: strings.couldNotLoadAuditLog,
          retryLabel: strings.retry,
          onRetry: () {
            ref.invalidate(auditLogsProvider);
          },
        ),
        data: (logs) {
          final filteredLogs = _filterLogs(logs);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: strings.auditLog,
                subtitle: strings.auditLogSubtitle,
                icon: Icons.history_outlined,
              ),
              const SizedBox(height: 16),
              _AuditFilterChips(
                selectedFilter: selectedFilter,
                strings: strings,
                onSelected: (filter) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredLogs.isEmpty
                    ? EmptyState(
                        icon: Icons.history_outlined,
                        message: strings.noLogsYet,
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
  final AppStrings strings;
  final ValueChanged<AuditLogFilter> onSelected;

  const _AuditFilterChips({
    required this.selectedFilter,
    required this.strings,
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
      AuditLogFilter.all => strings.all,
      AuditLogFilter.today => strings.today,
      AuditLogFilter.week => strings.thisWeek,
      AuditLogFilter.branches => strings.branches,
      AuditLogFilter.employees => strings.employees,
      AuditLogFilter.inventory => strings.inventory,
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
        leading: _AuditLogLeading(
          log: log,
          fallbackIcon: _iconFor(log.entityType),
        ),
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

class _AuditLogLeading extends ConsumerWidget {
  final AuditLog log;
  final IconData fallbackIcon;

  const _AuditLogLeading({required this.log, required this.fallbackIcon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barcode = _barcodeFromLog(log);

    if (barcode == null) {
      return Icon(fallbackIcon);
    }

    final repository = ref.read(inventoryRepositoryProvider);

    return FutureBuilder<ProductImage?>(
      future: repository.getProductImageForBarcode(barcode),
      builder: (context, snapshot) {
        final image = snapshot.data;

        if (image == null) {
          return Icon(fallbackIcon);
        }

        return ProductImageThumbnail(
          imagePath: image.imagePath,
          repository: repository,
          size: 46,
        );
      },
    );
  }

  String? _barcodeFromLog(AuditLog log) {
    if (log.entityType != 'Inventory') {
      return null;
    }

    final match = RegExp(
      r'barcode\s+([^,\s.]+)',
      caseSensitive: false,
    ).firstMatch(log.description);

    return match?.group(1);
  }
}
