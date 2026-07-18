import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../repositories/inventory_repository.dart';
import '../theme/app_theme.dart';

class ProductImageSection extends StatelessWidget {
  final ProductImage? image;
  final Uint8List? previewBytes;
  final String barcode;
  final InventoryRepository repository;
  final VoidCallback onAdd;
  final VoidCallback onReplace;
  final String noImageLabel;
  final String addImageLabel;
  final String replaceImageLabel;

  const ProductImageSection({
    super.key,
    required this.image,
    this.previewBytes,
    required this.barcode,
    required this.repository,
    required this.onAdd,
    required this.onReplace,
    required this.noImageLabel,
    required this.addImageLabel,
    required this.replaceImageLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (barcode.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final currentPreviewBytes = previewBytes;

    if (currentPreviewBytes != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImageMemoryThumbnail(bytes: currentPreviewBytes, size: 104),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onReplace,
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text(replaceImageLabel),
          ),
        ],
      );
    }

    final currentImage = image;
    if (currentImage == null) {
      return _NoImagePanel(
        onAdd: onAdd,
        message: noImageLabel,
        actionLabel: addImageLabel,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImageThumbnail(
          imagePath: currentImage.imagePath,
          repository: repository,
          size: 104,
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: onReplace,
          icon: const Icon(Icons.photo_camera_outlined),
          label: Text(replaceImageLabel),
        ),
      ],
    );
  }
}

class ProductImageMemoryThumbnail extends StatelessWidget {
  final Uint8List bytes;
  final double size;

  const ProductImageMemoryThumbnail({
    super.key,
    required this.bytes,
    this.size = 84,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showProductImagePreview(context, bytes);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}

class ProductImageThumbnail extends StatelessWidget {
  final String imagePath;
  final InventoryRepository repository;
  final double size;

  const ProductImageThumbnail({
    super.key,
    required this.imagePath,
    required this.repository,
    this.size = 84,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: repository.readProductImageBytes(imagePath),
      builder: (context, snapshot) {
        final bytes = snapshot.data;

        if (bytes == null) {
          return _ImagePlaceholder(size: size);
        }

        return GestureDetector(
          onTap: () {
            showProductImagePreview(context, bytes);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.memory(
              bytes,
              width: size,
              height: size,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
        );
      },
    );
  }
}

Future<void> showProductImagePreview(
  BuildContext context,
  Uint8List imageBytes,
) {
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: GestureDetector(
                  onTap: () {},
                  child: Image.memory(imageBytes, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _NoImagePanel extends StatelessWidget {
  final VoidCallback onAdd;
  final String message;
  final String actionLabel;

  const _NoImagePanel({
    required this.onAdd,
    required this.message,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.primary.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.14)),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  size: 30,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message),
                    const SizedBox(height: 4),
                    Text(
                      actionLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final double size;

  const _ImagePlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
    );
  }
}
