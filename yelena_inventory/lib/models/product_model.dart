class ProductModel {
  final String id;
  final String barcode;
  final String? name;
  final String? notes;
  final String? imagePath;
  final bool isActive;

  const ProductModel({
    required this.id,
    required this.barcode,
    this.name,
    this.notes,
    this.imagePath,
    required this.isActive,
  });
}
