import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'localization/app_language.dart';
import 'screens/branch_selection_screen.dart';
import 'services/in_app_update_service.dart';
import 'services/supabase_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SupabaseService.initialize();

  runApp(const ProviderScope(child: YelenaInventoryApp()));
}

class YelenaInventoryApp extends ConsumerWidget {
  const YelenaInventoryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ref.watch(appStringsProvider).appTitle,
      theme: AppTheme.light(),
      locale: Locale(language.code),
      builder: (context, child) {
        return Directionality(
          textDirection: language.textDirection,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const InAppUpdateGate(child: BranchSelectionScreen()),
    );
  }
}
