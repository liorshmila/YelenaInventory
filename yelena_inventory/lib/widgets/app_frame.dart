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
    final canPop = Navigator.canPop(context);

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
      body: Stack(children: [content, if (canPop) const _FloatingBackButton()]),
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

class _FloatingBackButton extends StatelessWidget {
  const _FloatingBackButton();

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final alignment = textDirection == TextDirection.rtl
        ? Alignment.topRight
        : Alignment.topLeft;

    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: 48,
            height: 48,
            child: BackButton(
              style: IconButton.styleFrom(
                iconSize: 30,
                minimumSize: const Size(48, 48),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ),
      ),
    );
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
          'Developed for',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: logoWidth,
          child: Image.asset(
            'assets/logos/paamit_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Yelena Inventory',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Version 1.0.0',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textMuted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '© 2026 Yelena Portnoy',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textMuted.withValues(alpha: 0.78),
            fontSize: 12,
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
