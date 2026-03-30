import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'session_service.dart';
import '../../features/shipment_groups/providers/shipment_groups_provider.dart';

/// Thin wrapper around http that:
/// • Injects Authorization + Content-Type headers automatically
/// • Throws [ApiException] with clean messages on non-2xx responses
/// • Auto-redirects to login on 401/403 (expired / revoked session)
/// • Calls updateLastActive() on every successful response
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  /// NavigatorKey so we can push LoginScreen from anywhere without a BuildContext.
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    final url     = Uri.parse('${await _baseUrl}$path');
    final headers = {...await _headers, ...?extraHeaders};

    try {
      final response = await http.get(url, headers: headers)
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(ApiClient.friendlyNetworkMessage(e));
    }
  }

  Future<dynamic> getUrl(String fullUrl) async {
    final url = Uri.parse(fullUrl);
    try {
      final response = await http.get(url, headers: await _headers)
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(ApiClient.friendlyNetworkMessage(e));
    }
  }

  // ─── POST ─────────────────────────────────────────────────────────────────

  Future<dynamic> post(String path, {required Map<String, dynamic> body}) async {
    final url = Uri.parse('${await _baseUrl}$path');
    try {
      final response = await http.post(
        url,
        headers: await _headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 60));
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(ApiClient.friendlyNetworkMessage(e));
    }
  }

  Future<http.Response> getRaw(
    String fullUrl, {
    required String authHeader,
  }) async {
    final url = Uri.parse(fullUrl);
    try {
      return await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': authHeader,
      }).timeout(const Duration(seconds: 30));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(ApiClient.friendlyNetworkMessage(e));
    }
  }

  Future<http.Response> postRaw(
    String fullUrl, {
    required String authHeader,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse(fullUrl);
    try {
      return await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(ApiClient.friendlyNetworkMessage(e));
    }
  }

  // ─── Response Handler ─────────────────────────────────────────────────────

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Reset inactivity clock on every successful call.
      SessionService.instance.updateLastActive();
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      // Session expired or revoked — soft-logout and redirect to login.
      unawaited(_handleSessionExpired());
      throw const ApiException('Session expired. Please log in again.', 401);
    }
    if (response.statusCode == 404) {
      throw ApiException('Not found.', response.statusCode);
    }
    throw ApiException(
      'Server error (${response.statusCode}). Contact your admin.',
      response.statusCode,
    );
  }

  Future<void> _handleSessionExpired() async {
    await SessionService.instance.softLogout();
    // Reset provider so re-login on a different account never sees stale data.
    try { ShipmentGroupsProvider.instanceForReset?.reset(); } catch (_) {}
    final nav = navigatorKey.currentState;
    if (nav == null) return;
    nav.pushNamedAndRemoveUntil('/login', (_) => false);
  }

  /// Converts low-level network exceptions into user-friendly messages.
  /// Also used by other services that need to surface network errors.
  static String friendlyNetworkMessage(Object e) {
    if (e is TimeoutException) {
      return 'Connection timed out. Please check your network and try again.';
    }
    if (e is SocketException) {
      // errno 7 = ENOENT / host not found; errno 111 = connection refused
      final msg = e.message.toLowerCase();
      if (msg.contains('failed host lookup') ||
          msg.contains('no address associated') ||
          e.osError?.errorCode == 7 ||
          e.osError?.errorCode == 8) {
        return 'Unable to reach the server. Please check your network connection.';
      }
      if (msg.contains('connection refused')) {
        return 'Connection refused by the server. Please contact your admin.';
      }
      return 'Network error. Please check your connection and try again.';
    }
    // http package wraps socket errors as ClientException
    final str = e.toString().toLowerCase();
    if (str.contains('failed host lookup') ||
        str.contains('socketexception') ||
        str.contains('no address associated')) {
      return 'Unable to reach the server. Please check your network connection.';
    }
    if (str.contains('connection refused')) {
      return 'Connection refused by the server. Please contact your admin.';
    }
    if (str.contains('timeout')) {
      return 'Connection timed out. Please check your network and try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}
