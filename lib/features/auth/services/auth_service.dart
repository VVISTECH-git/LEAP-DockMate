import '../../../core/constants/app_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/session_service.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Future<void> login({
    required String instanceUrl,
    required String userId,
    required String password,
  }) async {
    final upperId    = userId.trim().toUpperCase();
    final authHeader = SessionService.buildBasicAuth(upperId, password.trim());
    final validationUrl =
        '${instanceUrl.trim()}${AppConstants.pathValidateLogin}';

    final response = await ApiClient.instance.getRaw(
      validationUrl,
      authHeader: authHeader,
    );

    // FIX: Previously, ALL non-200 responses (including 500, 503, 404) threw
    // "Invalid credentials", which is misleading for server-side errors.
    // Now we differentiate: 401/403 → bad credentials, everything else → server error.
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException(
          'Invalid credentials. Please check your username and password.');
    } else if (response.statusCode != 200) {
      throw AuthException(
          'Server error (${response.statusCode}). Please try again or contact your admin.');
    }

    await SessionService.instance.saveSession(
      instanceUrl: instanceUrl.trim(),
      authHeader:  authHeader,
      userId:      upperId,
    );
  }

  Future<void> logout() => SessionService.instance.clear();
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}
