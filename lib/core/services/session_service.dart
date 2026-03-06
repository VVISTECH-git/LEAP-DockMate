import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Single source of truth for the current user session.
/// No saved credentials — user must login every time.
class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _p async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ─── Write ────────────────────────────────────────────────────────────────

  Future<void> saveSession({
    required String instanceUrl,
    required String authHeader,
    required String userId,
  }) async {
    final p = await _p;
    final parts  = userId.split('.');
    final domain = parts.isNotEmpty ? parts[0] : AppConstants.defaultDomain;
    final user   = parts.length > 1 ? parts.sublist(1).join('.') : userId;

    await p.setString(AppConstants.prefInstanceUrl, instanceUrl);
    await p.setString(AppConstants.prefAuthHeader, authHeader);
    await p.setString(AppConstants.prefUserId, userId);
    await p.setString(AppConstants.prefUser, user);
    await p.setString(AppConstants.prefDomain, domain);
  }

  Future<void> setLastTeam(String team) async =>
      (await _p).setString(AppConstants.prefLastTeam, team);

  // ─── Read ─────────────────────────────────────────────────────────────────

  Future<String> get instanceUrl async =>
      (await _p).getString(AppConstants.prefInstanceUrl) ??
      AppConstants.defaultInstanceUrl;

  Future<String> get authHeader async =>
      (await _p).getString(AppConstants.prefAuthHeader) ?? '';

  Future<String> get domain async =>
      (await _p).getString(AppConstants.prefDomain) ??
      AppConstants.defaultDomain;

  Future<String> get user async =>
      (await _p).getString(AppConstants.prefUser) ?? '';

  Future<String> get userId async =>
      (await _p).getString(AppConstants.prefUserId) ?? '';

  Future<String> get lastTeam async =>
      (await _p).getString(AppConstants.prefLastTeam) ?? 'inbound';

  Future<bool> get isLoggedIn async =>
      (await authHeader).isNotEmpty;

  // ─── Clear ────────────────────────────────────────────────────────────────

  // FIX: Replaced .clear() (which wiped ALL SharedPreferences including 3rd-party libs)
  // with explicit per-key removes so only this app's session keys are deleted.
  Future<void> clear() async {
    final p = await _p;
    await Future.wait([
      p.remove(AppConstants.prefInstanceUrl),
      p.remove(AppConstants.prefAuthHeader),
      p.remove(AppConstants.prefUserId),
      p.remove(AppConstants.prefUser),
      p.remove(AppConstants.prefDomain),
      p.remove(AppConstants.prefLastTeam),
    ]);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  static String buildBasicAuth(String userId, String password) {
    final encoded = base64Encode(utf8.encode('$userId:$password'));
    return 'Basic $encoded';
  }
}
