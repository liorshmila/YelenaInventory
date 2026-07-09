import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';

import '../localization/app_language.dart';

class InAppUpdateGate extends ConsumerStatefulWidget {
  final Widget child;

  const InAppUpdateGate({super.key, required this.child});

  @override
  ConsumerState<InAppUpdateGate> createState() => _InAppUpdateGateState();
}

class _InAppUpdateGateState extends ConsumerState<InAppUpdateGate> {
  bool _checkStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdate());
  }

  Future<void> _checkForUpdate() async {
    debugPrint(
      '[InAppUpdate] Startup check called. '
      'platform=$defaultTargetPlatform, kIsWeb=$kIsWeb, '
      'alreadyStarted=$_checkStarted',
    );

    if (_checkStarted ||
        kIsWeb ||
        defaultTargetPlatform != TargetPlatform.android) {
      debugPrint('[InAppUpdate] Check skipped by platform/start guard.');
      return;
    }
    _checkStarted = true;

    try {
      debugPrint(
        '[InAppUpdate] Requesting update information from Google Play.',
      );
      final updateInfo = await InAppUpdate.checkForUpdate();
      debugPrint(
        '[InAppUpdate] availability/availableVersionCode: '
        '${updateInfo.availableVersionCode}',
      );
      debugPrint(
        '[InAppUpdate] updateAvailability: '
        '${updateInfo.updateAvailability}',
      );
      debugPrint('[InAppUpdate] installStatus: ${updateInfo.installStatus}');
      debugPrint(
        '[InAppUpdate] immediateUpdateAllowed: '
        '${updateInfo.immediateUpdateAllowed}',
      );
      debugPrint(
        '[InAppUpdate] flexibleUpdateAllowed: '
        '${updateInfo.flexibleUpdateAllowed}',
      );
      if (!mounted) return;

      if (updateInfo.installStatus == InstallStatus.downloaded) {
        await _promptToInstall();
        return;
      }

      if (updateInfo.updateAvailability != UpdateAvailability.updateAvailable ||
          !updateInfo.flexibleUpdateAllowed) {
        return;
      }

      final shouldDownload = await _promptToDownload();
      if (!shouldDownload || !mounted) return;

      await InAppUpdate.startFlexibleUpdate();
      if (mounted) {
        await _promptToInstall();
      }
    } catch (error, stackTrace) {
      debugPrint('Google Play in-app update check failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<bool> _promptToDownload() async {
    final strings = ref.read(appStringsProvider);
    final shouldDownload = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.updateAvailable),
        content: Text(strings.updateAvailableMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.later),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(strings.updateNow),
          ),
        ],
      ),
    );

    return shouldDownload == true;
  }

  Future<void> _promptToInstall() async {
    final strings = ref.read(appStringsProvider);
    final shouldInstall = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.updateReady),
        content: Text(strings.updateReadyMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.later),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(strings.installUpdate),
          ),
        ],
      ),
    );

    if (shouldInstall != true) return;

    try {
      await InAppUpdate.completeFlexibleUpdate();
    } catch (error, stackTrace) {
      debugPrint('Google Play in-app update installation failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
