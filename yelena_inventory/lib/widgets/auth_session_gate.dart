import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../models/current_session_model.dart';
import '../providers/auth_provider.dart';
import '../providers/current_session_provider.dart';
import '../screens/no_active_permission_screen.dart';
import '../screens/otp_verification_screen.dart';
import '../screens/phone_login_screen.dart';
import '../screens/scan_screen.dart';
import '../screens/session_error_screen.dart';
import 'app_frame.dart';
import 'app_state_views.dart';

class AuthSessionGate extends ConsumerStatefulWidget {
  const AuthSessionGate({super.key});

  @override
  ConsumerState<AuthSessionGate> createState() => _AuthSessionGateState();
}

class _AuthSessionGateState extends ConsumerState<AuthSessionGate> {
  bool _restoreStarted = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_restoreSessionOnce);
  }

  Future<void> _restoreSessionOnce() async {
    if (_restoreStarted || !mounted) {
      return;
    }

    _restoreStarted = true;
    await ref.read(authProvider.notifier).restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final strings = ref.watch(appStringsProvider);

    switch (authState.status) {
      case AuthStatus.loading:
        return AppFrame(child: LoadingView(message: strings.loadingSession));
      case AuthStatus.unauthenticated:
      case AuthStatus.otpRequestInProgress:
        return const PhoneLoginScreen();
      case AuthStatus.otpRequested:
      case AuthStatus.otpVerificationInProgress:
        return const OtpVerificationScreen();
      case AuthStatus.error:
        if (authState.errorCode == AuthErrorCode.invalidOrExpiredOtp &&
            authState.normalizedPhone != null) {
          return const OtpVerificationScreen();
        }

        return const PhoneLoginScreen();
      case AuthStatus.authenticated:
        return _buildAuthenticatedSession(strings);
    }
  }

  Widget _buildAuthenticatedSession(AppStrings strings) {
    final session = ref.watch(currentSessionProvider);

    switch (session.status) {
      case CurrentSessionStatus.loading:
        return AppFrame(child: LoadingView(message: strings.loadingSession));
      case CurrentSessionStatus.unauthenticated:
        return const PhoneLoginScreen();
      case CurrentSessionStatus.noActivePermission:
        return const NoActivePermissionScreen();
      case CurrentSessionStatus.needsBranchSelection:
        return const ScanScreen();
      case CurrentSessionStatus.ready:
        return const ScanScreen();
      case CurrentSessionStatus.error:
        return const SessionErrorScreen();
    }
  }
}
