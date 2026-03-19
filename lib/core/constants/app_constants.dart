import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // ─── Prefs Keys ───────────────────────────────────────────────────────────
  static const String prefInstanceUrl = 'instance_url';
  static const String prefAuthHeader  = 'auth_header';
  static const String prefUserId      = 'user_id';
  static const String prefUser        = 'user';
  static const String prefDomain      = 'domain';
  static const String prefLastTeam    = 'fp_last_team';

  // ─── Default ──────────────────────────────────────────────────────────────
  static const String defaultInstanceUrl =
      'https://otmgtm-test-bttfusion.otmgtm.me-jeddah-1.ocs.oraclecloud.com';
  static const String defaultDomain = 'DEMO';

  // ─── API Paths ────────────────────────────────────────────────────────────
  static const String pathValidateLogin =
      '/logisticsRestApi/resources-int/v2/items/DEFAULT?fields=itemXid';
  static const String pathShipmentGroups =
      '/logisticsRestApi/resources-int/v2/shipmentGroups';
  static const String pathLocations =
      '/logisticsRestApi/resources-int/v2/locations';
  static const String pathDocuments =
      '/logisticsRestApi/resources-int/v2/documents';

  // ─── Document Upload ──────────────────────────────────────────────────────
  static const int maxDocuments   = 20;
  static const int imageQuality   = 85;
  static const int imageMaxWidth  = 1920;
  static const int imageMaxHeight = 1080;

  static const List<String> docTypes = [
    'POD', 'BOL', 'Invoice', 'Packing List',
    'Inspection', 'Customs', 'Other',
  ];

  // ─── LEAP Platform Colours ────────────────────────────────────────────────
  // Shared identity across Driver, Carrier and DockMate

  static const Color leapNavy    = Color(0xFF0F1F3D); // platform nav/header
  static const Color leapNavy2   = Color(0xFF162952);
  static const Color leapOrange  = Color(0xFFF97316); // platform accent
  static const Color leapSuccess = Color(0xFF10A868);
  static const Color leapDanger  = Color(0xFFE01E35);
  static const Color leapWarning = Color(0xFFF97316);
  static const Color leapInfo    = Color(0xFF0EA5E9);
  static const Color leapSurface = Color(0xFFF4F6FB);
  static const Color leapBorder  = Color(0xFFD4DCE9);
  static const Color leapMuted   = Color(0xFF7A8499);

  // ─── DockMate Product Colours ─────────────────────────────────────────────
  // Green = dock confirmed, complete, done
  static const Color primary     = Color(0xFF0D7A4E);
  static const Color primary2    = Color(0xFF10A868);

  // ─── Semantic indicators ──────────────────────────────────────────────────
  static const Color inboundGreen  = Color(0xFF0D7A4E);
  static const Color outboundBlue  = Color(0xFF1847C2);

  // ─── Convenience aliases (used throughout existing code) ──────────────────
  static const Color navy        = leapNavy;
  static const Color blue        = Color(0xFF1847C2);
  static const Color bgGrey      = leapSurface;
  static const Color borderGrey  = leapBorder;
  static const Color textGrey    = leapMuted;
  static const Color errorRed    = leapDanger;

  // Legacy Nokia aliases — now map to LEAP tokens
  static const Color nokiaBlue       = leapNavy;
  static const Color nokiaBrightBlue = primary;
  static const Color outboundOrange  = leapOrange;
}
