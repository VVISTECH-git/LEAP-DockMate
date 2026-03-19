import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// OtmInstanceService
//
// Handles everything related to OTM instance URLs:
//   • Parsing a raw URL into a human-friendly OtmInstance object
//   • Persisting up to 5 saved instances in SharedPreferences
//   • Tracking the active instance
//
// Parsing rules (derived from Oracle OTM URL pattern):
//   https://otmgtm-{env-slug}-{domain}.otmgtm.{region}.ocs.oraclecloud.com/
//
//   Environment detection (from slug after "otmgtm-"):
//     contains "test"     → "OTM Test"
//     contains "dev" + N  → "OTM Development N"
//     no keyword match    → "OTM Production"
//
//   Domain: last segment of the env-slug (e.g. "bttfusion", "a629995")
// ═══════════════════════════════════════════════════════════════════════════════

enum OtmEnv { production, test, development }

class OtmInstance {
  final String url;
  final String displayName;   // "OTM Test", "OTM Production", "OTM Development 1"
  final String domain;        // "bttfusion", "a629995"
  final OtmEnv env;
  final int? devNumber;       // 1, 2, etc — only set for development instances

  const OtmInstance({
    required this.url,
    required this.displayName,
    required this.domain,
    required this.env,
    this.devNumber,
  });

  String get envLabel {
    switch (env) {
      case OtmEnv.production:  return 'Production';
      case OtmEnv.test:        return 'Test';
      case OtmEnv.development: return devNumber != null ? 'Dev $devNumber' : 'Dev';
    }
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'displayName': displayName,
    'domain': domain,
    'env': env.name,
    'devNumber': devNumber,
  };

  factory OtmInstance.fromJson(Map<String, dynamic> j) => OtmInstance(
    url: j['url'] as String,
    displayName: j['displayName'] as String,
    domain: j['domain'] as String,
    env: OtmEnv.values.firstWhere((e) => e.name == j['env'],
        orElse: () => OtmEnv.production),
    devNumber: j['devNumber'] as int?,
  );

  @override
  bool operator ==(Object other) =>
      other is OtmInstance && other.url.toLowerCase() == url.toLowerCase();

  @override
  int get hashCode => url.toLowerCase().hashCode;
}


class OtmInstanceService {
  OtmInstanceService._();
  static final instance = OtmInstanceService._();

  static const _keyInstances = 'otm_saved_instances';
  static const _keyActive    = 'otm_active_instance_url';
  static const maxSaved      = 5;

  // ── Parse a raw OTM URL into an OtmInstance ───────────────────────────────
  // Returns null if the URL doesn't look like a valid OTM instance URL.

  static OtmInstance? parse(String rawUrl) {
    try {
      final url = rawUrl.trim().endsWith('/')
          ? rawUrl.trim()
          : '${rawUrl.trim()}/';

      final host = url
          .replaceFirst(RegExp(r'^https?://'), '')
          .split('/')[0]
          .split('?')[0];

      // Must follow otmgtm-*.otmgtm.*.ocs.oraclecloud.com pattern
      if (!host.startsWith('otmgtm-') || !host.contains('.otmgtm.')) {
        return null;
      }

      // Extract the slug: everything between "otmgtm-" and the first "."
      final slug = host.split('.')[0].replaceFirst('otmgtm-', '');
      final segments = slug.split('-');

      OtmEnv env = OtmEnv.production;
      int? devNumber;
      String domain = segments.last;

      for (int i = 0; i < segments.length; i++) {
        final seg = segments[i].toLowerCase();

        // Test detection
        if (seg == 'test') {
          env = OtmEnv.test;
          // Domain is everything after "test-"
          domain = segments.sublist(i + 1).join('-');
          break;
        }

        // Dev detection — matches "dev", "dev1", "dev2", etc.
        final devMatch = RegExp(r'^dev(\d*)$').firstMatch(seg);
        if (devMatch != null) {
          env = OtmEnv.development;
          final numStr = devMatch.group(1) ?? '';
          devNumber = numStr.isNotEmpty ? int.tryParse(numStr) : null;
          domain = segments.sublist(i + 1).join('-');
          break;
        }
      }

      // If domain ended up empty (slug had no separator), use the whole slug
      if (domain.isEmpty) domain = slug;

      // Build display name
      String displayName;
      switch (env) {
        case OtmEnv.production:
          displayName = 'OTM Production';
          break;
        case OtmEnv.test:
          displayName = 'OTM Test';
          break;
        case OtmEnv.development:
          displayName = devNumber != null
              ? 'OTM Development $devNumber'
              : 'OTM Development';
          break;
      }

      return OtmInstance(
        url: url,
        displayName: displayName,
        domain: domain,
        env: env,
        devNumber: devNumber,
      );
    } catch (_) {
      return null;
    }
  }

  // ── Load all saved instances ───────────────────────────────────────────────

  Future<List<OtmInstance>> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getString(_keyInstances);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((j) => OtmInstance.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── Load active instance ───────────────────────────────────────────────────

  Future<OtmInstance?> loadActive() async {
    final prefs   = await SharedPreferences.getInstance();
    final url     = prefs.getString(_keyActive);
    if (url == null) return null;
    final saved = await loadSaved();
    try {
      return saved.firstWhere((i) => i.url.toLowerCase() == url.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  // ── Save a new instance (or promote existing to top) ──────────────────────
  // Adds to the front of the list. If already exists, moves it to front.
  // Trims to maxSaved.

  Future<void> saveInstance(OtmInstance inst) async {
    final prefs   = await SharedPreferences.getInstance();
    final current = await loadSaved();

    // Remove duplicates
    current.removeWhere((i) => i == inst);

    // Add to front
    current.insert(0, inst);

    // Trim to max
    final trimmed = current.take(maxSaved).toList();

    await prefs.setString(
      _keyInstances,
      jsonEncode(trimmed.map((i) => i.toJson()).toList()),
    );
  }

  // ── Set active instance ────────────────────────────────────────────────────

  Future<void> setActive(OtmInstance inst) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyActive, inst.url);
    // Also update the instance URL used by ApiClient / AppConstants
    await prefs.setString('instance_url', inst.url);
  }

  // ── Save + set active in one call ─────────────────────────────────────────

  Future<void> saveAndActivate(OtmInstance inst) async {
    await saveInstance(inst);
    await setActive(inst);
  }

  // ── Delete a saved instance ────────────────────────────────────────────────

  Future<void> delete(OtmInstance inst) async {
    final prefs   = await SharedPreferences.getInstance();
    final current = await loadSaved();
    current.removeWhere((i) => i == inst);
    await prefs.setString(
      _keyInstances,
      jsonEncode(current.map((i) => i.toJson()).toList()),
    );
  }
}