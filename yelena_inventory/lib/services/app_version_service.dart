import 'package:flutter/services.dart';

class AppVersionInfo {
  final String version;
  final String buildNumber;

  const AppVersionInfo({required this.version, required this.buildNumber});
}

class AppVersionService {
  static const _channel = MethodChannel('yelena_inventory/app_info');

  static Future<AppVersionInfo?> getInstalledVersion() async {
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'getAppVersion',
      );
      final version = result?['version']?.toString();
      final buildNumber = result?['buildNumber']?.toString();

      if (version == null ||
          version.isEmpty ||
          buildNumber == null ||
          buildNumber.isEmpty) {
        return null;
      }

      return AppVersionInfo(version: version, buildNumber: buildNumber);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
