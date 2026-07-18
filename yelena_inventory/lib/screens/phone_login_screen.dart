import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../providers/auth_provider.dart';
import '../providers/global_loading_provider.dart';
import '../utils/israeli_phone_input_formatter.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_frame.dart';
import '../widgets/app_text_field.dart';
import '../widgets/section_title.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final phoneController = TextEditingController();
  bool submitting = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final authState = ref.watch(authProvider);

    ref.listen<AuthControllerState>(authProvider, (previous, next) {
      if (next.status != AuthStatus.error) {
        return;
      }

      if (next.errorCode == AuthErrorCode.invalidOrExpiredOtp) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authErrorMessage(strings, next.errorCode))),
      );
    });

    return AppFrame(
      title: strings.appTitle,
      child: ListView(
        children: [
          SectionTitle(
            title: strings.phoneLoginTitle,
            subtitle: strings.phoneLoginSubtitle,
            icon: Icons.phone_iphone_outlined,
          ),
          const SizedBox(height: 24),
          AppTextField(
            controller: phoneController,
            label: strings.phoneNumber,
            hintText: '050-1234567',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: const [IsraeliPhoneInputFormatter()],
          ),
          const SizedBox(height: 6),
          Text(
            strings.phoneLoginExample,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: strings.sendCode,
            icon: Icons.sms_outlined,
            onPressed:
                submitting ||
                    authState.status == AuthStatus.otpRequestInProgress
                ? null
                : _requestOtp,
          ),
        ],
      ),
    );
  }

  Future<void> _requestOtp() async {
    if (submitting) {
      return;
    }

    setState(() {
      submitting = true;
    });

    try {
      await ref.read(globalLoadingProvider.notifier).runWithLoading<void>(
        () async {
          await ref
              .read(authProvider.notifier)
              .requestOtp(
                rawPhone: phoneController.text,
                shouldCreateUser: initialPhoneAuthShouldCreateUser,
              );
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
