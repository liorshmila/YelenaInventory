import 'package:flutter/services.dart';

class AppExitService {
  static const _channel = MethodChannel('yelena_inventory/app_control');

  const AppExitService._();

  static Future<void> exitApplication() async {
    try {
      await _channel.invokeMethod<void>('exitApplication');
    } on MissingPluginException {
      await SystemNavigator.pop();
    }
  }
}
