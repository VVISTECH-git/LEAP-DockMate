import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session_service.dart';

/// Thin wrapper around http that:
/// • Injects Authorization + Content-Type headers automatically
/// • Throws [ApiException] with clean messages on non-2xx responses
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  Future<Map<String, String>> get _headers async {
    final auth = await SessionService.instance.authHeader;
    return {
      'Content-Type': 'application/json',
      'Authorization': auth,
    };
  }

  Future<String> get _baseUrl => SessionService.instance.instanceUrl;

  // ─── GET ──────────────────────────────────────────────────────────────────

  Future<dynamic> get(String path, {Map<String, String>? extraHeaders}) async {
    final url = Uri.parse('${await _baseUrl}$path');
    final headers = {...await _headers, ...?extraHeaders};

    final response = await http.get(url, headers: headers)
        .timeout(const Duration(seconds: 30));

    return _handleResponse(response);
  }

  /// GET with a full URL (for cases like location lookup where URL is constructed externally)
  Future<dynamic> getUrl(String fullUrl) async {
    final url = Uri.parse(fullUrl);
    final response = await http.get(url, headers: await _headers)
        .timeout(const Duration(seconds: 30));
    return _handleResponse(response);
  }

  // ─── POST ─────────────────────────────────────────────────────────────────

  Future<dynamic> post(String path, {required Map<String, dynamic> body}) async {
    final url = Uri.parse('${await _baseUrl}$path');
    final response = await http.post(
      url,
      headers: await _headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 60)); // longer for doc uploads

    return _handleResponse(response);
  }

  /// POST with a custom auth header (used during login before session is saved)
  Future<http.Response> getRaw(
    String fullUrl, {
    required String authHeader,
  }) async {
    final url = Uri.parse(fullUrl);
    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': authHeader,
    }).timeout(const Duration(seconds: 30));
  }

  Future<http.Response> postRaw(
    String fullUrl, {
    required String authHeader,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse(fullUrl);
    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authHeader,
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 30));
  }

  // ─── Response Handler ─────────────────────────────────────────────────────

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw ApiException('Invalid credentials. Please login again.', response.statusCode);
    }
    if (response.statusCode == 404) {
      throw ApiException('Not found.', response.statusCode);
    }
    throw ApiException(
      'Server error (${response.statusCode}). Contact your admin.',
      response.statusCode,
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}
