import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/repository_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_list_card.dart';
import '../widgets/app_scrollbar.dart';
import '../widgets/app_state_views.dart';
import '../widgets/app_text_field.dart';
import '../widgets/section_title.dart';
import 'barcode_scanner_screen.dart';

class ScanScreen extends ConsumerStatefulWidget {
  final Employee employee;

  const ScanScreen({super.key, required this.employee});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final barcodeController = TextEditingController();
  final quantityController = TextEditingController();
  final barcodeFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();

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

    barcodeFocusNode.requestFocus();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('נשמר בהצלחה')));
  }

  Future<void> scanBarcode() async {
    final barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );

    if (!mounted || barcode == null || barcode.isEmpty) {
      return;
    }

    barcodeController.text = barcode;
    quantityFocusNode.requestFocus();
  }

  @override
  void dispose() {
    barcodeController.dispose();
    quantityController.dispose();
    barcodeFocusNode.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const AppFrame(child: LoadingView(message: 'טוען ספירת מלאי...'));
    }

    return AppFrame(
      child: AppScrollbar(
        builder: (controller) {
          return ListView(
            controller: controller,
            children: [
              SectionTitle(
                title: 'סריקת מוצרים',
                subtitle: 'עובד: ${widget.employee.name}',
                icon: Icons.qr_code_scanner,
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: barcodeController,
                focusNode: barcodeFocusNode,
                label: 'ברקוד',
                icon: Icons.document_scanner_outlined,
                keyboardType: TextInputType.number,
                suffixIcon: IconButton(
                  tooltip: 'Scan barcode',
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: scanBarcode,
                ),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: quantityController,
                focusNode: quantityFocusNode,
                label: 'כמות',
                icon: Icons.add_chart_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'שמור',
                icon: Icons.save_outlined,
                onPressed: saveProduct,
              ),
              const SizedBox(height: 18),
              _InventoryHeader(count: inventory.length),
              const SizedBox(height: 12),
              if (inventory.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: EmptyState(
                    icon: Icons.inventory_2_outlined,
                    message: 'עדיין אין פריטים בספירה',
                  ),
                )
              else
                ...inventory.map(
                  (item) => AppListCard(
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
                            Text(item.countDate.toString().substring(0, 16)),
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
                          final repo = ref.read(inventoryRepositoryProvider);

                          await repo.deleteInventory(item.id);

                          await loadInventory();

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('הרשומה נמחקה')),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
