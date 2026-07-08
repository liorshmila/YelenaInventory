import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../localization/app_language.dart';
import '../services/barcode_beep_service.dart';

class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen>
    with WidgetsBindingObserver {
  late final MobileScannerController controller;
  bool barcodeReturned = false;
  bool scannerStarting = false;
  bool scannerDisposed = false;
  String? lastBarcodeValue;
  int stableDetections = 0;

  static const stableDetectionThreshold = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = MobileScannerController(
      autoStart: false,
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
      detectionTimeoutMs: 120,
      formats: const [
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
        BarcodeFormat.code128,
        BarcodeFormat.code39,
        BarcodeFormat.qrCode,
      ],
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_startScanner());
    });
  }

  @override
  void dispose() {
    scannerDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    unawaited(controller.dispose());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (scannerDisposed || barcodeReturned) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(_startScanner());
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        unawaited(_stopScanner());
    }
  }

  Future<void> _startScanner() async {
    if (!mounted ||
        scannerDisposed ||
        scannerStarting ||
        barcodeReturned ||
        controller.value.isRunning ||
        controller.value.isStarting) {
      return;
    }

    scannerStarting = true;
    try {
      await controller.start();
    } finally {
      scannerStarting = false;
    }
  }

  Future<void> _stopScanner() async {
    if (scannerDisposed ||
        (!controller.value.isRunning && !controller.value.isStarting)) {
      return;
    }

    await controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(strings.scanBarcode),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            fit: BoxFit.cover,
            onDetect: _handleBarcodeCapture,
            errorBuilder: _buildError,
            useAppLifecycleState: false,
            placeholderBuilder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          ),
          _ScannerOverlay(message: strings.pointCameraAtBarcode),
        ],
      ),
    );
  }

  Future<void> _handleBarcodeCapture(BarcodeCapture capture) async {
    if (barcodeReturned) {
      return;
    }

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;

      if (value == null || value.trim().isEmpty) {
        continue;
      }

      final normalizedValue = value.trim();
      final canAcceptImmediately = _hasValidRetailCheckDigit(
        normalizedValue,
        barcode.format,
      );
      final invalidRetailCandidate =
          _isRetailLength(normalizedValue) &&
          barcode.format != BarcodeFormat.upcE &&
          !canAcceptImmediately;

      if (invalidRetailCandidate) {
        continue;
      }

      if (normalizedValue == lastBarcodeValue) {
        stableDetections += 1;
      } else {
        lastBarcodeValue = normalizedValue;
        stableDetections = 1;
      }

      if (!canAcceptImmediately &&
          stableDetections < stableDetectionThreshold) {
        return;
      }

      barcodeReturned = true;
      await BarcodeBeepService.playSuccessBeep();
      await controller.stop();
      if (!mounted) {
        return;
      }
      Navigator.pop(context, lastBarcodeValue);
      return;
    }
  }

  bool _hasValidRetailCheckDigit(String value, BarcodeFormat format) {
    if (_isValidWeightedCheckDigit(value, 13) ||
        _isValidWeightedCheckDigit(value, 8) ||
        _isValidWeightedCheckDigit(value, 12)) {
      return true;
    }

    return switch (format) {
      BarcodeFormat.ean13 => _isValidWeightedCheckDigit(value, 13),
      BarcodeFormat.ean8 => _isValidWeightedCheckDigit(value, 8),
      BarcodeFormat.upcA => _isValidWeightedCheckDigit(value, 12),
      _ => false,
    };
  }

  bool _isRetailLength(String value) {
    return RegExp(r'^\d+$').hasMatch(value) &&
        (value.length == 8 || value.length == 12 || value.length == 13);
  }

  bool _isValidWeightedCheckDigit(String value, int expectedLength) {
    if (value.length != expectedLength || !RegExp(r'^\d+$').hasMatch(value)) {
      return false;
    }

    final digits = value.split('').map(int.parse).toList();
    final checkDigit = digits.last;
    var sum = 0;

    for (var index = 0; index < digits.length - 1; index += 1) {
      final positionFromRight = digits.length - index;
      final weight = positionFromRight.isEven ? 3 : 1;
      sum += digits[index] * weight;
    }

    final calculatedCheckDigit = (10 - (sum % 10)) % 10;

    return calculatedCheckDigit == checkDigit;
  }

  Widget _buildError(BuildContext context, MobileScannerException error) {
    final message = switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied =>
        ref.read(appStringsProvider).cameraPermissionRequired,
      MobileScannerErrorCode.unsupported =>
        ref.read(appStringsProvider).cameraUnavailable,
      _ => ref.read(appStringsProvider).cameraUnavailable,
    };
    final details = error.errorDetails;
    final diagnosticText = [
      'Scanner diagnostics',
      'error.errorCode: ${error.errorCode}',
      'error.errorDetails?.code: ${details?.code}',
      'error.errorDetails?.message: ${details?.message}',
      'error.toString(): $error',
    ].join('\n');

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              color: Colors.white,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: SelectableText(
                diagnosticText,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(ref.read(appStringsProvider).close),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  final String message;

  const _ScannerOverlay({required this.message});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
