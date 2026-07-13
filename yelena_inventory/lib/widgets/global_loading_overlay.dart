import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/global_loading_provider.dart';

class GlobalLoadingOverlay extends ConsumerWidget {
  final Widget child;

  const GlobalLoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(globalLoadingActiveProvider);

    if (!isLoading) {
      return child;
    }

    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black.withValues(alpha: 0.18),
            ),
          ),
          const Positioned.fill(
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
