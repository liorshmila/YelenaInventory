import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppFrame extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool scrollable;
  final List<Widget> actions;
  final Widget? leading;
  final double? leadingWidth;

  const AppFrame({
    super.key,
    this.title,
    required this.child,
    this.scrollable = true,
    this.actions = const [],
    this.leading,
    this.leadingWidth,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final topLogoWidth = _topLogoWidth(screenWidth);
    final route = ModalRoute.of(context);
    final canPop = Navigator.canPop(context) && !(route?.isFirst ?? true);

    final content = SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _HeaderLogo(visible: !keyboardVisible, width: topLogoWidth),
                Expanded(child: AppCard(child: child)),
                _Footer(visible: !keyboardVisible),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: title == null && actions.isEmpty && leading == null
          ? null
          : AppBar(
              title: title == null ? null : Text(title!),
              leading: leading,
              leadingWidth: leadingWidth,
              actions: actions,
            ),
      body: Stack(children: [content, if (canPop) const _FloatingBackButton()]),
    );
  }

  double _topLogoWidth(double width) {
    if (width < 600) {
      return width * 0.58;
    }

    if (width < 1000) {
      return width * 0.43;
    }

    return 420;
  }
}

class _HeaderLogo extends StatelessWidget {
  final bool visible;
  final double width;

  const _HeaderLogo({required this.visible, required this.width});

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SizedBox(
            width: width,
            child: Image.asset(
              'assets/logos/YelenaInventoryLogo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final bool visible;

  const _Footer({required this.visible});

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [SizedBox(height: 8), _PoweredBy()],
    );
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
        child: Padding(padding: const EdgeInsets.all(14), child: child),
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
        const SizedBox(height: 4),
        Text(
          'Developed for',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          width: logoWidth,
          child: Image.asset(
            'assets/logos/paamit_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Yelena Inventory',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Version 1.0.0',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textMuted,
            fontSize: 10.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '© 2026 Yelena Portnoy',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textMuted.withValues(alpha: 0.78),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  double _bottomLogoWidth(double width) {
    if (width < 600) {
      return width * 0.52;
    }

    if (width < 1000) {
      return width * 0.40;
    }

    return 285;
  }
}
