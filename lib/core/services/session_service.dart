import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Single source of truth for the current user session.
/// Auth token is stored in encrypted secure storage (Android Keystore).
/// Non-sensitive preferences remain in SharedPreferences.
class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  SharedPreferences? _prefs;
  final _secure = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

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
    final p      = await _p;
    final parts  = userId.split('.');
    final domain = parts.isNotEmpty ? parts[0] : AppConstants.defaultDomain;
    final user   = parts.length > 1 ? parts.sublist(1).join('.') : userId;

    // Auth token → encrypted Android Keystore
    await _secure.write(key: AppConstants.prefAuthHeader, value: authHeader);

    // Everything else → SharedPreferences (not sensitive)
    await p.setString(AppConstants.prefInstanceUrl, instanceUrl);
    await p.setString(AppConstants.prefUserId, userId);   // kept for pre-fill
    await p.setString(AppConstants.prefUser, user);
    await p.setString(AppConstants.prefDomain, domain);

    // Record login time as the first "last active" timestamp.
    await updateLastActive();
  }

  Future<void> setLastTeam(String team) async =>
      (await _p).setString(AppConstants.prefLastTeam, team);

  /// Call this whenever the user is active in the app (e.g. on every
  /// successful API response). Resets the inactivity clock.
  Future<void> updateLastActive() async =>
      (await _p).setInt(AppConstants.prefLastActive,
          DateTime.now().millisecondsSinceEpoch);

  /// Returns true if the user has been inactive for longer than [timeoutHours].
  /// Default: 12 hours — reasonable for a shift-based warehouse app.
  Future<bool> isInactivityExpired({int timeoutHours = 12}) async {
    final ts = (await _p).getInt(AppConstants.prefLastActive);
    if (ts == null) return true; // no timestamp ever recorded → treat as expired
    final last = DateTime.fromMillisecondsSinceEpoch(ts);
    return DateTime.now().difference(last) > Duration(hours: timeoutHours);
  }

  // ─── Read ─────────────────────────────────────────────────────────────────

  Future<String> get instanceUrl async =>
      (await _p).getString(AppConstants.prefInstanceUrl) ??
      AppConstants.defaultInstanceUrl;

  // Auth token read from encrypted secure storage
  Future<String> get authHeader async =>
      await _secure.read(key: AppConstants.prefAuthHeader) ?? '';

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

  /// Soft logout: clears auth token and lastActive but keeps userId and
  /// instanceUrl so the login screen can pre-fill them.
  Future<void> softLogout() async {
    final p = await _p;
    await _secure.delete(key: AppConstants.prefAuthHeader);
    await Future.wait([
      p.remove(AppConstants.prefLastActive),
      p.remove(AppConstants.prefLastTeam),
    ]);
    // userId, instanceUrl, domain, user → intentionally kept for pre-fill
  }

  /// Full logout: clears everything including pre-fill data.
  Future<void> clear() async {
    final p = await _p;
    await _secure.delete(key: AppConstants.prefAuthHeader);
    await Future.wait([
      p.remove(AppConstants.prefInstanceUrl),
      p.remove(AppConstants.prefUserId),
      p.remove(AppConstants.prefUser),
      p.remove(AppConstants.prefDomain),
      p.remove(AppConstants.prefLastTeam),
      p.remove(AppConstants.prefLastActive),
    ]);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  static String buildBasicAuth(String userId, String password) {
    final encoded = base64Encode(utf8.encode('$userId:$password'));
    return 'Basic $encoded';
  }
}
