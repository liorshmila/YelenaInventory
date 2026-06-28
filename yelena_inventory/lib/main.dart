import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/branch_selection_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: YelenaInventoryApp()));
}

class YelenaInventoryApp extends StatelessWidget {
  const YelenaInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yelena Inventory',
      theme: AppTheme.light(),
      home: const BranchSelectionScreen(),
    );
  }
}
