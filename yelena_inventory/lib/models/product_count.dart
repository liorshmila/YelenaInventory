class ProductCount {
  final String barcode;
  final int quantity;
  final String employeeName;
  final DateTime countDate;
  final String note;
  final bool updatedToScanner;
  final DateTime? scannerUpdateDate;

  ProductCount({
    required this.barcode,
    required this.quantity,
    required this.employeeName,
    required this.countDate,
    this.note = '',
    this.updatedToScanner = false,
    this.scannerUpdateDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'quantity': quantity,
      'employeeName': employeeName,
      'countDate': countDate.toIso8601String(),
      'note': note,
      'updatedToScanner': updatedToScanner,
      'scannerUpdateDate': scannerUpdateDate?.toIso8601String(),
    };
  }

  factory ProductCount.fromJson(Map<String, dynamic> json) {
    return ProductCount(
      barcode: json['barcode'],
      quantity: json['quantity'],
      employeeName: json['employeeName'],
      countDate: DateTime.parse(json['countDate']),
      note: json['note'] ?? '',
      updatedToScanner: json['updatedToScanner'] ?? false,
      scannerUpdateDate: json['scannerUpdateDate'] == null
          ? null
          : DateTime.parse(json['scannerUpdateDate']),
    );
  }
}
