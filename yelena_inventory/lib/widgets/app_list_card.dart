import 'package:flutter/material.dart';

class AppListCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AppListCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(18),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
