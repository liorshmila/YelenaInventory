import 'package:flutter/material.dart';

class AppScrollbar extends StatefulWidget {
  final Widget Function(ScrollController controller) builder;

  const AppScrollbar({super.key, required this.builder});

  @override
  State<AppScrollbar> createState() => _AppScrollbarState();
}

class _AppScrollbarState extends State<AppScrollbar> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      interactive: true,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 10),
        child: widget.builder(controller),
      ),
    );
  }
}
