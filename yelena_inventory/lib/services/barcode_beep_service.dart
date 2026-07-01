import 'package:flutter/services.dart';

class BarcodeBeepService {
  static const _channel = MethodChannel('yelena_inventory/barcode_beep');

  const BarcodeBeepService._();

  static Future<void> playSuccessBeep() async {
    try {
      await _channel.invokeMethod<void>('playSuccessBeep');
    } on MissingPluginException {
      await SystemSound.play(SystemSoundType.alert);
    } on PlatformException {
      await SystemSound.play(SystemSoundType.alert);
    }
  }
}
