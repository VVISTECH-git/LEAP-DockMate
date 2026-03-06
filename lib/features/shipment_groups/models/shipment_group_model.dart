import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Real OTM field names from API response
class ShipmentGroup {
  final String shipGroupGid;      // built as domainName.shipGroupXid
  final String shipGroupXid;      // "20260205-0001"
  final String shipGroupTypeGid;  // "EXPORTER" or "IMPORTER"
  final String domainName;
  final String sourceLocation;    // extracted from canonical link
  final String destinationLocation;
  final String startTime;
  final String endTime;
  final int numberOfShipments;
  final String totalWeight;       // "17636.98 LB"
  final String totalVolume;       // "3000.0 CUFT"
  final String sourceLocationName;
  final String destLocationName;

  const ShipmentGroup({
    required this.shipGroupGid,
    required this.shipGroupXid,
    required this.shipGroupTypeGid,
    required this.domainName,
    required this.sourceLocation,
    required this.destinationLocation,
    required this.startTime,
    required this.endTime,
    required this.numberOfShipments,
    required this.totalWeight,
    required this.totalVolume,
    this.sourceLocationName = '',
    this.destLocationName   = '',
  });

  // ─── isInbound ────────────────────────────────────────────────────────────
  // EXPORTER = Outbound, IMPORTER = Inbound
  // FIX: Added isUnknown guard — if API returns an unexpected type value,
  // the group is no longer silently dropped from both lists.
  bool get isInbound  => shipGroupTypeGid.toUpperCase() == 'IMPORTER';
  bool get isOutbound => shipGroupTypeGid.toUpperCase() == 'EXPORTER';
  bool get isUnknown  => !isInbound && !isOutbound;

  // ─── Display helpers ──────────────────────────────────────────────────────
  String get displaySource =>
      sourceLocationName.isNotEmpty ? sourceLocationName : sourceLocation;

  String get displayDest =>
      destLocationName.isNotEmpty ? destLocationName : destinationLocation;

  // ─── fromJson ─────────────────────────────────────────────────────────────
  factory ShipmentGroup.fromJson(Map<String, dynamic> json) {
    final domain  = json['domainName']?.toString() ?? '';
    final xid     = json['shipGroupXid']?.toString() ?? '';
    final typeGid = json['shipGroupTypeGid']?.toString() ?? '';

    // Weight: { "value": 17636.98, "unit": "LB" }
    final wt  = _extractMeasure(json['totalWeight']);
    final vol = _extractMeasure(json['totalVolume']);

    // FIX: debugPrint calls wrapped in kDebugMode so they don't run in production builds.
    if (kDebugMode) {
      debugPrint('=== ShipmentGroup.fromJson ===');
      debugPrint('xid: $xid | type: $typeGid | domain: $domain');
      debugPrint('source: ${_extractLocationGid(json['sourceLocation'])}');
      debugPrint('dest: ${_extractLocationGid(json['destLocation'])}');
      debugPrint('weight: $wt | volume: $vol');
      debugPrint('shipments: ${json['numberOfShipments']}');
    }

    return ShipmentGroup(
      shipGroupGid:        '$domain.$xid',
      shipGroupXid:        xid,
      shipGroupTypeGid:    typeGid,
      domainName:          domain,
      sourceLocation:      _extractLocationGid(json['sourceLocation']),
      destinationLocation: _extractLocationGid(json['destLocation']),
      startTime:           _extractValue(json['startTime']),
      endTime:             _extractValue(json['endTime']),
      numberOfShipments:   _parseInt(json['numberOfShipments']),
      totalWeight:         wt,
      totalVolume:         vol,
    );
  }

  ShipmentGroup copyWith({
    String? sourceLocationName,
    String? destLocationName,
  }) {
    return ShipmentGroup(
      shipGroupGid:        shipGroupGid,
      shipGroupXid:        shipGroupXid,
      shipGroupTypeGid:    shipGroupTypeGid,
      domainName:          domainName,
      sourceLocation:      sourceLocation,
      destinationLocation: destinationLocation,
      startTime:           startTime,
      endTime:             endTime,
      numberOfShipments:   numberOfShipments,
      totalWeight:         totalWeight,
      totalVolume:         totalVolume,
      sourceLocationName:  sourceLocationName ?? this.sourceLocationName,
      destLocationName:    destLocationName   ?? this.destLocationName,
    );
  }

  // ─── Parsers ──────────────────────────────────────────────────────────────

  // Extracts GID from canonical link href
  // e.g. ".../locations/DEMO.JAIPUR" → "DEMO.JAIPUR"
  static String _extractLocationGid(dynamic location) {
    if (location == null) return '';
    if (location is String) return location;
    if (location is Map) {
      final links = location['links'];
      if (links is List) {
        for (final link in links) {
          if (link is Map && link['rel'] == 'canonical') {
            final href = link['href']?.toString() ?? '';
            final match = RegExp(r'/locations/([^/]+)$').firstMatch(href);
            if (match != null) return match.group(1) ?? '';
          }
        }
      }
      return location['gid']?.toString() ?? location['value']?.toString() ?? '';
    }
    return location.toString();
  }

  // Extracts value from { "value": "...", ... }
  static String _extractValue(dynamic obj) {
    if (obj == null) return '';
    if (obj is String) return obj;
    if (obj is Map) return obj['value']?.toString() ?? '';
    return obj.toString();
  }

  // Extracts measure from { "value": 17636.98, "unit": "LB" }
  static String _extractMeasure(dynamic obj) {
    if (obj == null) return '';
    if (obj is Map) {
      final val  = obj['value'];
      final unit = obj['unit']?.toString() ?? '';
      if (val != null) {
        final num = val is double
            ? val.toStringAsFixed(2)
            : val.toString();
        return '$num $unit'.trim();
      }
    }
    return '';
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

// ─── Status (placeholder since status needs separate API call) ────────────────

class GroupStatus {
  final String label;
  final Color chipBg;
  final Color chipText;
  final Color barColor;

  const GroupStatus({
    required this.label,
    required this.chipBg,
    required this.chipText,
    required this.barColor,
  });
}

const Map<String, GroupStatus> kGroupStatuses = {
  'JOB_NEW': GroupStatus(
    label: 'New',
    chipBg: Color(0xFFE3F0FF),
    chipText: Color(0xFF1565C0),
    barColor: Color(0xFF2D5BE3),
  ),
  'JOB_ASSIGNED': GroupStatus(
    label: 'Assigned',
    chipBg: Color(0xFFFFF0E0),
    chipText: Color(0xFFB85C00),
    barColor: Color(0xFFE8720A),
  ),
  'JOB_DONE': GroupStatus(
    label: 'Done',
    chipBg: Color(0xFFE0F5EC),
    chipText: Color(0xFF0A6640),
    barColor: Color(0xFF10A868),
  ),
};

GroupStatus statusFor(String code) =>
    kGroupStatuses[code] ?? kGroupStatuses['JOB_NEW']!;
