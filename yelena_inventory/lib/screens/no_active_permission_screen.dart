import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../providers/auth_provider.dart';
import '../providers/global_loading_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_frame.dart';

class NoActivePermissionScreen extends ConsumerWidget {
  const NoActivePermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);

    return AppFrame(
      title: strings.appTitle,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 58,
                color: AppTheme.textMuted,
              ),
              const SizedBox(height: 18),
              Text(
                strings.noActivePermissionTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                strings.noActivePermissionBody,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: strings.refresh,
                icon: Icons.refresh,
                onPressed: () => _refreshSession(ref),
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

  Future<void> _refreshSession(WidgetRef ref) async {
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
