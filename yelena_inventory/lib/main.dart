import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'localization/app_language.dart';
import 'providers/branch_provider.dart';
import 'providers/employees_provider.dart';
import 'providers/inventory_db_provider.dart';
import 'services/in_app_update_service.dart';
import 'services/supabase_service.dart';
import 'theme/app_theme.dart';
import 'widgets/auth_session_gate.dart';
import 'widgets/global_loading_overlay.dart';

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
    ref.watch(branchRealtimeSubscriptionProvider);
    ref.watch(employeeManagementRealtimeSubscriptionProvider);
    ref.watch(operationalInventoryRealtimeSubscriptionProvider);

    final language = ref.watch(languageProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ref.watch(appStringsProvider).appTitle,
      theme: AppTheme.light(),
      locale: Locale(language.code),
      builder: (context, child) {
        return Directionality(
          textDirection: language.textDirection,
          child: GlobalLoadingOverlay(child: child ?? const SizedBox.shrink()),
        );
      },
      home: const InAppUpdateGate(child: AuthSessionGate()),
    );
  }
}
