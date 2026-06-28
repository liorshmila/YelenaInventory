import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/repository_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_state_views.dart';
import '../widgets/app_text_field.dart';
import '../widgets/section_title.dart';

class ScanScreen extends ConsumerStatefulWidget {
  final Employee employee;

  const ScanScreen({super.key, required this.employee});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final barcodeController = TextEditingController();
  final quantityController = TextEditingController();

  List<InventoryCount> inventory = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadInventory();
  }

  Future<void> loadInventory() async {
    final repo = ref.read(inventoryRepositoryProvider);

    final data = await repo.getInventory();

    if (!mounted) return;

    setState(() {
      inventory = data;
      loading = false;
    });
  }

  Future<void> saveProduct() async {
    final barcode = barcodeController.text.trim();

    final quantity = int.tryParse(quantityController.text.trim());

    if (barcode.isEmpty || quantity == null) {
      return;
    }

    final repo = ref.read(inventoryRepositoryProvider);

    await repo.saveInventory(
      barcode: barcode,
      quantity: quantity,
      employeeId: widget.employee.id,
    );

    barcodeController.clear();
    quantityController.clear();

    await loadInventory();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('נשמר בהצלחה')));
  }

  @override
  void dispose() {
    barcodeController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const AppFrame(child: LoadingView(message: 'טוען ספירת מלאי...'));
    }

    return AppFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'סריקת מוצרים',
            subtitle: 'עובד: ${widget.employee.name}',
            icon: Icons.qr_code_scanner,
          ),
          const SizedBox(height: 24),
          AppTextField(
            controller: barcodeController,
            label: 'ברקוד',
            icon: Icons.document_scanner_outlined,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: quantityController,
            label: 'כמות',
            icon: Icons.add_chart_outlined,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'שמור',
            icon: Icons.save_outlined,
            onPressed: saveProduct,
          ),
          const SizedBox(height: 24),
          _InventoryHeader(count: inventory.length),
          const SizedBox(height: 16),
          Expanded(
            child: inventory.isEmpty
                ? const EmptyState(
                    icon: Icons.inventory_2_outlined,
                    message: 'עדיין אין פריטים בספירה',
                  )
                : ListView.builder(
                    itemCount: inventory.length,
                    itemBuilder: (context, index) {
                      final item = inventory[index];

                      return AppListCard(
                        child: ListTile(
                          leading: const Icon(Icons.inventory_2_outlined),
                          title: Text(
                            item.barcode,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('כמות: ${item.quantity}'),
                                Text('עובד #${item.employeeId}'),
                                Text(
                                  item.countDate.toString().substring(0, 16),
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: 'מחק',
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppTheme.error,
                            ),
                            onPressed: () async {
                              final repo = ref.read(
                                inventoryRepositoryProvider,
                              );

                              await repo.deleteInventory(item.id);

                              await loadInventory();

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('הרשומה נמחקה')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _InventoryHeader extends StatelessWidget {
  final int count;

  const _InventoryHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.fact_check_outlined, color: AppTheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'נספרו $count מוצרים',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
