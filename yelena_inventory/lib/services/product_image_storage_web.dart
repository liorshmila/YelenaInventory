import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:web/web.dart' as web;

class ProductImageStorage {
  static const int maxImageWidth = 800;
  static const int jpegQuality = 76;
  static const String _keyPrefix = 'yelena_inventory_product_image_';

  Future<String> saveBarcodeImage({
    required String barcode,
    required XFile source,
  }) async {
    final sourceBytes = await source.readAsBytes();

    return saveBarcodeImageBytes(barcode: barcode, sourceBytes: sourceBytes);
  }

  Future<String> saveBarcodeImageBytes({
    required String barcode,
    required Uint8List sourceBytes,
  }) async {
    final encodedBytes = _compressedJpeg(sourceBytes);
    final storageKey = '$_keyPrefix${_safeKey(barcode)}';

    web.window.localStorage.setItem(storageKey, base64Encode(encodedBytes));

    return storageKey;
  }

  Future<Uint8List?> readImageBytes(String imagePath) async {
    final encoded = web.window.localStorage.getItem(imagePath);

    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    return base64Decode(encoded);
  }

  Future<void> deleteImage(String imagePath) async {
    web.window.localStorage.removeItem(imagePath);
  }

  Uint8List _compressedJpeg(Uint8List sourceBytes) {
    final decoded = img.decodeImage(sourceBytes);

    if (decoded == null) {
      return sourceBytes;
    }

    final resized = decoded.width > maxImageWidth
        ? img.copyResize(decoded, width: maxImageWidth)
        : decoded;

    return Uint8List.fromList(img.encodeJpg(resized, quality: jpegQuality));
  }

  String _safeKey(String barcode) {
    return barcode.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
  }
}
