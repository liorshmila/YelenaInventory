import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

enum EmployeeLinkResult {
  linked('linked'),
  alreadyLinked('alreadyLinked'),
  employeeNotFound('employeeNotFound'),
  employeeInactive('employeeInactive'),
  linkingConflict('linkingConflict'),
  authenticatedPhoneMissing('authenticatedPhoneMissing'),
  invalidAuthenticatedPhone('invalidAuthenticatedPhone'),
  operationFailed('operationFailed');

  final String code;

  const EmployeeLinkResult(this.code);

  static EmployeeLinkResult fromCode(String code) {
    final normalizedCode = code.trim();

    for (final result in EmployeeLinkResult.values) {
      if (result.code == normalizedCode) {
        return result;
      }
    }

    throw FormatException('Unknown employee link result: $code');
  }
}

class AuthService {
  SupabaseClient get _client => SupabaseService.client;

  User? get currentUser => _client.auth.currentUser;

  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> requestOtp({
    required String phone,
    required bool shouldCreateUser,
  }) {
    return _client.auth.signInWithOtp(
      phone: phone,
      shouldCreateUser: shouldCreateUser,
    );
  }

  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
  }) {
    return _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  Future<EmployeeLinkResult> linkAuthenticatedEmployee() async {
    final response = await _client.rpc('link_authenticated_employee');

    if (response is! String) {
      throw FormatException(
        'Unexpected employee link RPC response type: ${response.runtimeType}',
      );
    }

    return EmployeeLinkResult.fromCode(response);
  }

  Future<void> signOut() {
    return _client.auth.signOut();
  }
}
