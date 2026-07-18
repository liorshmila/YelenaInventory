import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../providers/auth_provider.dart';
import '../providers/global_loading_provider.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_text_field.dart';
import '../widgets/section_title.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final otpController = TextEditingController();
  bool submitting = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final authState = ref.watch(authProvider);
    final destinationPhone = authState.normalizedPhone ?? '';

    ref.listen<AuthControllerState>(authProvider, (previous, next) {
      if (next.status != AuthStatus.error) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authErrorMessage(strings, next.errorCode))),
      );
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || submitting) {
          return;
        }

        _returnToPhoneEntry();
      },
      child: AppFrame(
        title: strings.appTitle,
        child: ListView(
          children: [
            SectionTitle(
              title: strings.otpVerificationTitle,
              subtitle: strings.otpVerificationSubtitle(destinationPhone),
              icon: Icons.sms_outlined,
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: otpController,
              label: strings.otpCode,
              icon: Icons.password_outlined,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: strings.verifyCode,
              icon: Icons.verified_outlined,
              onPressed:
                  submitting ||
                      authState.status == AuthStatus.otpVerificationInProgress
                  ? null
                  : _verifyOtp,
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: strings.changePhone,
              icon: Icons.arrow_back,
              onPressed: submitting ? null : _returnToPhoneEntry,
            ),
          ],
        ),
      ),
    );
  }

  void _returnToPhoneEntry() {
    ref.read(authProvider.notifier).returnToPhoneEntry();
  }

  Future<void> _verifyOtp() async {
    final strings = ref.read(appStringsProvider);
    final token = otpController.text.trim();

    if (token.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.otpCodeRequired)));
      return;
    }

    if (submitting) {
      return;
    }

    setState(() {
      submitting = true;
    });

    try {
      await ref.read(globalLoadingProvider.notifier).runWithLoading<void>(
        () async {
          await ref.read(authProvider.notifier).verifyOtp(token: token);
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          submitting = false;
        });
      }
    }
  }

  String _authErrorMessage(AppStrings strings, AuthErrorCode? errorCode) {
    return switch (errorCode) {
      AuthErrorCode.invalidPhone => strings.invalidPhone,
      AuthErrorCode.otpRequestFailed => strings.otpRequestFailed,
      AuthErrorCode.invalidOrExpiredOtp => strings.invalidOrExpiredOtp,
      AuthErrorCode.rateLimited => strings.rateLimited,
      AuthErrorCode.networkFailure => strings.networkFailure,
      AuthErrorCode.authOperationFailed || null => strings.authOperationFailed,
    };
  }
}
