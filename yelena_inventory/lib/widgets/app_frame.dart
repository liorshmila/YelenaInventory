import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppFrame extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool scrollable;

  const AppFrame({
    super.key,
    this.title,
    required this.child,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final topLogoWidth = _topLogoWidth(screenWidth);

    final content = SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: topLogoWidth,
                    child: Image.asset(
                      'assets/logos/YelenaInventoryLogo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(child: AppCard(child: child)),
                const SizedBox(height: 20),
                const _PoweredBy(),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: title == null ? null : AppBar(title: Text(title!)),
      body: content,
    );
  }

  double _topLogoWidth(double width) {
    if (width < 600) {
      return width * 0.64;
    }

    if (width < 1000) {
      return width * 0.48;
    }

    return 480;
  }
}

class AppCard extends StatelessWidget {
  final Widget child;

  const AppCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Padding(padding: const EdgeInsets.all(24), child: child),
      ),
    );
  }
}

class _PoweredBy extends StatelessWidget {
  const _PoweredBy();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final logoWidth = _bottomLogoWidth(screenWidth);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 160, child: Divider(height: 1)),
        const SizedBox(height: 10),
        Text(
          'Powered by',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textMuted,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: logoWidth,
          child: Image.asset(
            'assets/logos/paamit_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  double _bottomLogoWidth(double width) {
    if (width < 600) {
      return width * 0.585;
    }

    if (width < 1000) {
      return width * 0.455;
    }

    return 338;
  }
}
