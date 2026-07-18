import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../models/current_session_model.dart';
import '../providers/auth_provider.dart';
import '../providers/current_session_provider.dart';
import '../providers/global_loading_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_frame.dart';

class SessionErrorScreen extends ConsumerWidget {
  const SessionErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final errorCode = ref.watch(currentSessionProvider).errorCode;

    return AppFrame(
      title: strings.appTitle,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                errorCode == CurrentSessionErrorCode.employeeNotLinked
                    ? Icons.person_off_outlined
                    : Icons.error_outline,
                size: 58,
                color: errorCode == CurrentSessionErrorCode.employeeNotLinked
                    ? AppTheme.textMuted
                    : Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 18),
              Text(
                _title(strings, errorCode),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                _body(strings, errorCode),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: strings.retry,
                icon: Icons.refresh,
                onPressed: () => _retry(ref),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: strings.signOut,
                icon: Icons.logout,
                onPressed: () => _signOut(ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _title(AppStrings strings, CurrentSessionErrorCode? errorCode) {
    if (errorCode == CurrentSessionErrorCode.employeeNotLinked) {
      return strings.employeeNotLinkedTitle;
    }

    if (errorCode == CurrentSessionErrorCode.employeeLinkingConflict) {
      return strings.employeeLinkingConflictTitle;
    }

    return strings.sessionLoadFailedTitle;
  }

  String _body(AppStrings strings, CurrentSessionErrorCode? errorCode) {
    if (errorCode == CurrentSessionErrorCode.employeeNotLinked) {
      return strings.employeeNotLinkedBody;
    }

    if (errorCode == CurrentSessionErrorCode.employeeLinkingConflict) {
      return strings.employeeLinkingConflictBody;
    }

    return strings.sessionLoadFailedBody;
  }

  Future<void> _retry(WidgetRef ref) async {
    await ref.read(globalLoadingProvider.notifier).runWithLoading<void>(
      () async {
        await ref.read(authProvider.notifier).retryEmployeeLinkAndBootstrap();
      },
    );
  }

  Future<void> _signOut(WidgetRef ref) async {
    await ref.read(globalLoadingProvider.notifier).runWithLoading<void>(
      () async {
        await ref.read(authProvider.notifier).signOut();
      },
    );
  }
}
