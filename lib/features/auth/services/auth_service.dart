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
    // Security: reject non-HTTPS URLs — Basic Auth over HTTP sends credentials
    // in base64 plaintext, which is trivially decodable by any network observer.
    if (!instanceUrl.trim().toLowerCase().startsWith('https://')) {
      throw const AuthException(
        'Insecure connection rejected. Your OTM instance URL must start with https://.',
      );
    }

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
      throw const AuthException(
          'Incorrect username or password. Please try again.');
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

  Future<void> logout() => SessionService.instance.softLogout();
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}