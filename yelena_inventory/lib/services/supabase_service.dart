import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const _url = String.fromEnvironment('SUPABASE_URL');
  static const _publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static bool _initialized = false;

  static bool get isConfigured => _url.isNotEmpty && _publishableKey.isNotEmpty;

  static Future<void> initialize() async {
    if (!isConfigured || _initialized) return;

    await Supabase.initialize(url: _url, publishableKey: _publishableKey);
    _initialized = true;
  }

  static SupabaseClient get client {
    if (!_initialized) {
      throw StateError(
        'Supabase is not configured. Provide SUPABASE_URL and '
        'SUPABASE_PUBLISHABLE_KEY with --dart-define.',
      );
    }

    return Supabase.instance.client;
  }
}
