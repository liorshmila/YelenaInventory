import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ProductImageStorage {
  static const int maxImageWidth = 800;
  static const int jpegQuality = 76;

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
    final directory = await _imagesDirectory();
    final safeBarcode = _safeFileName(barcode);
    final file = File(p.join(directory.path, '$safeBarcode.jpg'));

    await file.writeAsBytes(encodedBytes, flush: true);

    return file.path;
  }

  Future<Uint8List?> readImageBytes(String imagePath) async {
    final file = File(imagePath);

    if (!await file.exists()) {
      return null;
    }

    return file.readAsBytes();
  }

  Future<void> deleteImage(String imagePath) async {
    final file = File(imagePath);

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<Directory> _imagesDirectory() async {
    final supportDirectory = await getApplicationSupportDirectory();
    final imagesDirectory = Directory(p.join(supportDirectory.path, 'images'));

    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }

    return imagesDirectory;
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

  String _safeFileName(String barcode) {
    return barcode.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
  }
}
