import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/current_session_model.dart';
import '../services/auth_service.dart';
import '../utils/israeli_phone_normalizer.dart';
import 'current_session_provider.dart';

// Initial production SMS flow allows Supabase to create an Auth user.
// Employee linking remains a separate, explicit business process.
const initialPhoneAuthShouldCreateUser = true;

enum AuthStatus {
  loading,
  unauthenticated,
  authenticated,
  otpRequestInProgress,
  otpRequested,
  otpVerificationInProgress,
  error,
}

enum AuthErrorCode {
  invalidPhone,
  otpRequestFailed,
  invalidOrExpiredOtp,
  rateLimited,
  networkFailure,
  authOperationFailed,
}

class AuthControllerState {
  final AuthStatus status;
  final User? currentUser;
  final String? normalizedPhone;
  final AuthErrorCode? errorCode;

  const AuthControllerState({
    required this.status,
    this.currentUser,
    this.normalizedPhone,
    this.errorCode,
  }) : assert(
         (status == AuthStatus.error) == (errorCode != null),
         'errorCode must be set only for error auth states.',
       );
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = NotifierProvider<AuthController, AuthControllerState>(
  AuthController.new,
);

final currentAuthUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).currentUser;
});

final authStatusProvider = Provider<AuthStatus>((ref) {
  return ref.watch(authProvider).status;
});

class AuthController extends Notifier<AuthControllerState> {
  int _operationGeneration = 0;

  AuthService get _authService => ref.read(authServiceProvider);

  @override
  AuthControllerState build() {
    return const AuthControllerState(status: AuthStatus.loading);
  }

  Future<void> restoreSession() async {
    final operation = _startOperation();
    state = const AuthControllerState(status: AuthStatus.loading);

    try {
      final currentUser = _authService.currentUser;
      final currentSession = _authService.currentSession;

      if (currentUser == null || currentSession == null) {
        if (_isCurrentOperation(operation)) {
          state = const AuthControllerState(status: AuthStatus.unauthenticated);
        }
        return;
      }

      if (!_isCurrentOperation(operation)) {
        return;
      }

      state = AuthControllerState(
        status: AuthStatus.authenticated,
        currentUser: currentUser,
      );

      await _linkEmployeeAndBootstrap(currentUser, operation: operation);
    } catch (error, stackTrace) {
      debugPrint('Auth session restore failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (_isCurrentOperation(operation)) {
        _setError(AuthErrorCode.authOperationFailed);
      }
    }
  }

  Future<void> requestOtp({
    required String rawPhone,
    required bool shouldCreateUser,
  }) async {
    final normalizedPhone = _normalizePhone(rawPhone);

    if (normalizedPhone == null) {
      _setError(AuthErrorCode.invalidPhone);
      return;
    }

    final operation = _startOperation();
    state = AuthControllerState(
      status: AuthStatus.otpRequestInProgress,
      currentUser: state.currentUser,
      normalizedPhone: normalizedPhone,
    );

    try {
      await _authService.requestOtp(
        phone: normalizedPhone,
        shouldCreateUser: shouldCreateUser,
      );

      if (_isCurrentOperation(operation)) {
        state = AuthControllerState(
          status: AuthStatus.otpRequested,
          currentUser: state.currentUser,
          normalizedPhone: normalizedPhone,
        );
      }
    } catch (error, stackTrace) {
      debugPrint('OTP request failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (_isCurrentOperation(operation)) {
        _setError(
          _mapAuthException(
            error,
            defaultErrorCode: AuthErrorCode.otpRequestFailed,
          ),
          normalizedPhone: normalizedPhone,
        );
      }
    }
  }

  Future<void> verifyOtp({required String token}) async {
    final normalizedPhone = state.normalizedPhone;

    if (normalizedPhone == null || normalizedPhone.isEmpty) {
      _setError(AuthErrorCode.authOperationFailed);
      return;
    }

    final trimmedToken = token.trim();

    if (trimmedToken.isEmpty) {
      _setError(
        AuthErrorCode.invalidOrExpiredOtp,
        normalizedPhone: normalizedPhone,
      );
      return;
    }

    final operation = _startOperation();
    state = AuthControllerState(
      status: AuthStatus.otpVerificationInProgress,
      currentUser: state.currentUser,
      normalizedPhone: normalizedPhone,
    );

    try {
      final response = await _authService.verifyOtp(
        phone: normalizedPhone,
        token: trimmedToken,
      );
      final user = response.user;

      if (user == null) {
        throw const AuthException('OTP verification did not return a user.');
      }

      if (!_isCurrentOperation(operation)) {
        return;
      }

      state = AuthControllerState(
        status: AuthStatus.authenticated,
        currentUser: user,
      );

      await _linkEmployeeAndBootstrap(user, operation: operation);
    } catch (error, stackTrace) {
      debugPrint('OTP verification failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (_isCurrentOperation(operation)) {
        _setError(
          _mapAuthException(
            error,
            defaultErrorCode: AuthErrorCode.authOperationFailed,
            isOtpVerification: true,
          ),
          normalizedPhone: normalizedPhone,
        );
      }
    }
  }

  Future<void> signOut() async {
    final operation = _startOperation();
    state = AuthControllerState(
      status: AuthStatus.loading,
      currentUser: state.currentUser,
    );

    try {
      await _authService.signOut();
      await ref.read(currentSessionProvider.notifier).clearSession();

      if (_isCurrentOperation(operation)) {
        state = const AuthControllerState(status: AuthStatus.unauthenticated);
      }
    } catch (error, stackTrace) {
      debugPrint('Auth sign out failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (_isCurrentOperation(operation)) {
        _setError(_mapAuthException(error));
      }
    }
  }

  void clearError() {
    if (state.status != AuthStatus.error) {
      return;
    }

    if (state.currentUser != null) {
      state = AuthControllerState(
        status: AuthStatus.authenticated,
        currentUser: state.currentUser,
        normalizedPhone: state.normalizedPhone,
      );
      return;
    }

    if (state.normalizedPhone != null) {
      state = AuthControllerState(
        status: AuthStatus.otpRequested,
        normalizedPhone: state.normalizedPhone,
      );
      return;
    }

    state = const AuthControllerState(status: AuthStatus.unauthenticated);
  }

  void returnToPhoneEntry() {
    _startOperation();
    state = const AuthControllerState(status: AuthStatus.unauthenticated);
  }

  Future<void> retryEmployeeLinkAndBootstrap() async {
    final operation = _startOperation();
    final currentUser = state.currentUser ?? _authService.currentUser;
    final currentSession = _authService.currentSession;

    if (currentUser == null || currentSession == null) {
      await ref.read(currentSessionProvider.notifier).clearSession();
      if (_isCurrentOperation(operation)) {
        state = const AuthControllerState(status: AuthStatus.unauthenticated);
      }
      return;
    }

    state = AuthControllerState(
      status: AuthStatus.authenticated,
      currentUser: currentUser,
    );

    await _linkEmployeeAndBootstrap(currentUser, operation: operation);
  }

  Future<void> _linkEmployeeAndBootstrap(
    User user, {
    required int operation,
  }) async {
    if (!_isCurrentOperation(operation)) {
      return;
    }

    ref.read(currentSessionProvider.notifier).setLoading();

    try {
      final linkResult = await _authService.linkAuthenticatedEmployee();

      if (!_isCurrentOperation(operation)) {
        return;
      }

      switch (linkResult) {
        case EmployeeLinkResult.linked:
        case EmployeeLinkResult.alreadyLinked:
          await ref
              .read(currentSessionBootstrapServiceProvider)
              .bootstrapForAuthenticatedUser(user.id);
          break;
        case EmployeeLinkResult.employeeNotFound:
          ref
              .read(currentSessionProvider.notifier)
              .setError(
                errorCode: CurrentSessionErrorCode.employeeNotLinked,
                authenticatedUserId: user.id,
              );
          break;
        case EmployeeLinkResult.employeeInactive:
          ref
              .read(currentSessionProvider.notifier)
              .setNoActivePermission(authenticatedUserId: user.id);
          break;
        case EmployeeLinkResult.linkingConflict:
          ref
              .read(currentSessionProvider.notifier)
              .setError(
                errorCode: CurrentSessionErrorCode.employeeLinkingConflict,
                authenticatedUserId: user.id,
              );
          break;
        case EmployeeLinkResult.authenticatedPhoneMissing:
        case EmployeeLinkResult.invalidAuthenticatedPhone:
        case EmployeeLinkResult.operationFailed:
          ref
              .read(currentSessionProvider.notifier)
              .setError(
                errorCode: CurrentSessionErrorCode.sessionLoadFailed,
                authenticatedUserId: user.id,
              );
          break;
      }
    } catch (error, stackTrace) {
      debugPrint('Employee link/bootstrap failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (_isCurrentOperation(operation)) {
        ref
            .read(currentSessionProvider.notifier)
            .setError(
              errorCode: CurrentSessionErrorCode.sessionLoadFailed,
              authenticatedUserId: user.id,
            );
      }
    }

    if (!_isCurrentOperation(operation) && state.currentUser?.id != user.id) {
      await ref.read(currentSessionProvider.notifier).clearSession();
    }
  }

  String? _normalizePhone(String rawPhone) {
    try {
      return IsraeliPhoneNormalizer.normalizeToE164(rawPhone);
    } on FormatException catch (error, stackTrace) {
      debugPrint('Phone normalization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  AuthErrorCode _mapAuthException(
    Object error, {
    AuthErrorCode defaultErrorCode = AuthErrorCode.authOperationFailed,
    bool isOtpVerification = false,
  }) {
    if (error is AuthRetryableFetchException) {
      return AuthErrorCode.networkFailure;
    }

    if (error is AuthException) {
      final statusCode = error.statusCode;
      final code = error.code?.toLowerCase() ?? '';
      final message = error.message.toLowerCase();

      if (statusCode == '429' ||
          code.contains('rate') ||
          message.contains('rate')) {
        return AuthErrorCode.rateLimited;
      }

      if (_looksLikeNetworkFailure(message)) {
        return AuthErrorCode.networkFailure;
      }

      if (isOtpVerification &&
          (statusCode == '400' ||
              statusCode == '401' ||
              statusCode == '403' ||
              code.contains('otp') ||
              code.contains('token') ||
              code.contains('expired') ||
              code.contains('invalid') ||
              message.contains('otp') ||
              message.contains('token') ||
              message.contains('expired') ||
              message.contains('invalid'))) {
        return AuthErrorCode.invalidOrExpiredOtp;
      }
    }

    return defaultErrorCode;
  }

  bool _looksLikeNetworkFailure(String message) {
    return message.contains('socket') ||
        message.contains('network') ||
        message.contains('connection') ||
        message.contains('timeout') ||
        message.contains('timed out') ||
        message.contains('failed host lookup');
  }

  int _startOperation() {
    _operationGeneration += 1;
    return _operationGeneration;
  }

  bool _isCurrentOperation(int operationGeneration) {
    return operationGeneration == _operationGeneration;
  }

  void _setError(AuthErrorCode errorCode, {String? normalizedPhone}) {
    state = AuthControllerState(
      status: AuthStatus.error,
      currentUser: state.currentUser,
      normalizedPhone: normalizedPhone ?? state.normalizedPhone,
      errorCode: errorCode,
    );
  }
}
