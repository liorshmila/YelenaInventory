class InventoryCountModel {
  final String id;
  final String productId;
  final String barcode;
  final String? productName;
  final String? productImagePath;
  final String branchId;
  final String? branchName;
  final String? employeeId;
  final String? employeeName;
  final int quantity;
  final DateTime countedAt;

  const InventoryCountModel({
    required this.id,
    required this.productId,
    required this.barcode,
    this.productName,
    this.productImagePath,
    required this.branchId,
    this.branchName,
    this.employeeId,
    this.employeeName,
    required this.quantity,
    required this.countedAt,
  });
}
