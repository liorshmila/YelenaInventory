import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/repository_provider.dart';

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
    ).showSnackBar(const SnackBar(content: Text("נשמר בהצלחה")));
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("סריקת מוצרים")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.employee.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: barcodeController,
              decoration: const InputDecoration(
                labelText: "ברקוד",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "כמות",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveProduct,
                child: const Text("שמור"),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "נספרו ${inventory.length} מוצרים",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: inventory.length,
                itemBuilder: (context, index) {
                  final item = inventory[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.barcode),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("כמות: ${item.quantity}"),
                          Text("עובד #${item.employeeId}"),
                          Text(item.countDate.toString().substring(0, 16)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final repo = ref.read(inventoryRepositoryProvider);

                          await repo.deleteInventory(item.id);

                          await loadInventory();

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("הרשומה נמחקה")),
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
      ),
    );
  }
}
