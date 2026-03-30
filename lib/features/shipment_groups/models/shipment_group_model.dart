import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ─── Timezone helper ──────────────────────────────────────────────────────────
// Converts a UTC ISO-8601 string to Eastern Europe Time (EET UTC+2 / EEST UTC+3).
// DST in Eastern Europe: last Sunday of March → last Sunday of October.
DateTime? _toEET(String? utcStr) {
  if (utcStr == null || utcStr.isEmpty) return null;
  try {
    final utc = DateTime.parse(utcStr).toUtc();
    // Determine if EET or EEST (DST) applies.
    // DST starts: last Sunday of March at 01:00 UTC
    // DST ends:   last Sunday of October at 01:00 UTC
    final year = utc.year;
    final dstStart = _lastSundayOf(year, 3);
    final dstEnd   = _lastSundayOf(year, 10);
    final isDst = utc.isAfter(dstStart) && utc.isBefore(dstEnd);
    return utc.add(Duration(hours: isDst ? 3 : 2));
  } catch (_) {
    return null;
  }
}

DateTime _lastSundayOf(int year, int month) {
  // Find last day of month, then walk back to Sunday.
  var day = DateTime.utc(year, month + 1, 0); // last day of month
  while (day.weekday != DateTime.sunday) {
    day = day.subtract(const Duration(days: 1));
  }
  return DateTime.utc(day.year, day.month, day.day, 1, 0); // 01:00 UTC
}

// ─── ShipmentGroup ────────────────────────────────────────────────────────────

class ShipmentGroup {
  final String shipGroupGid;       // domain.xid
  final String shipGroupXid;       // e.g. "20260205-0001"
  final String shipGroupTypeGid;   // kept for reference only
  final String attribute5;         // "INBOUND" | "OUTBOUND" | "" → hidden
  final String attribute2;         // Dock Door
  final String attributeNumber1;   // Total Ship Units
  final String attributeDate5Utc;  // Appointment Start (raw UTC string)
  final String attributeDate6Utc;  // Appointment End   (raw UTC string)
  final String truckPlate;         // from refnums where qual = OTM1.TRUCK_PLATE_NUMBER
  final String domainName;
  final String sourceLocation;
  final String destinationLocation;
  final int    numberOfShipments;
  final String totalWeight;
  final String totalVolume;
  final String sourceLocationName;
  final String destLocationName;

  const ShipmentGroup({
    required this.shipGroupGid,
    required this.shipGroupXid,
    required this.shipGroupTypeGid,
    required this.attribute5,
    required this.attribute2,
    required this.attributeNumber1,
    required this.attributeDate5Utc,
    required this.attributeDate6Utc,
    required this.truckPlate,
    required this.domainName,
    required this.sourceLocation,
    required this.destinationLocation,
    required this.numberOfShipments,
    required this.totalWeight,
    required this.totalVolume,
    this.sourceLocationName = '',
    this.destLocationName   = '',
  });

  // ─── Direction ────────────────────────────────────────────────────────────
  bool get isInbound  => attribute5.toUpperCase() == 'INBOUND';
  bool get isOutbound => attribute5.toUpperCase() == 'OUTBOUND';
  bool get isHidden   => attribute5.isEmpty;

  // ─── EET-converted appointment times ──────────────────────────────────────
  DateTime? get apptStartEet => _toEET(attributeDate5Utc);
  DateTime? get apptEndEet   => _toEET(attributeDate6Utc);

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
    final attr5   = json['attribute5']?.toString().trim() ?? '';
    final attr2   = json['attribute2']?.toString().trim() ?? '';
    final attrN1  = _formatNumber(json['attributeNumber1']?.toString().trim() ?? '');
    final date5   = _extractValue(json['attributeDate5']);
    final date6   = _extractValue(json['attributeDate6']);
    final wt      = _extractMeasure(json['totalWeight']);
    final vol     = _extractMeasure(json['totalVolume']);

    // Truck plate — find refnum where qualGid ends with TRUCK_PLATE_NUMBER
    final plate = _extractTruckPlate(json['refnums']);

    // Location names come expanded in the list response.
    final srcName  = _extractLocationName(json['sourceLocation']);
    final dstName  = _extractLocationName(json['destLocation']);

    if (kDebugMode) {
      debugPrint('=== ShipmentGroup.fromJson ===');
      debugPrint('xid: $xid | attr5: $attr5 | door: $attr2 | units: $attrN1');
      debugPrint('apptStart(UTC): $date5 | apptEnd(UTC): $date6');
      debugPrint('plate: $plate | weight: $wt | volume: $vol');
      debugPrint('src: $srcName | dst: $dstName');
    }

    return ShipmentGroup(
      shipGroupGid:        '$domain.$xid',
      shipGroupXid:        xid,
      shipGroupTypeGid:    typeGid,
      attribute5:          attr5,
      attribute2:          attr2,
      attributeNumber1:    attrN1,
      attributeDate5Utc:   date5,
      attributeDate6Utc:   date6,
      truckPlate:          plate,
      domainName:          domain,
      sourceLocation:      _extractLocationGid(json['sourceLocation']),
      destinationLocation: _extractLocationGid(json['destLocation']),
      numberOfShipments:   _parseInt(json['numberOfShipments']),
      totalWeight:         wt,
      totalVolume:         vol,
      sourceLocationName:  srcName,
      destLocationName:    dstName,
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
      attribute5:          attribute5,
      attribute2:          attribute2,
      attributeNumber1:    attributeNumber1,
      attributeDate5Utc:   attributeDate5Utc,
      attributeDate6Utc:   attributeDate6Utc,
      truckPlate:          truckPlate,
      domainName:          domainName,
      sourceLocation:      sourceLocation,
      destinationLocation: destinationLocation,
      numberOfShipments:   numberOfShipments,
      totalWeight:         totalWeight,
      totalVolume:         totalVolume,
      sourceLocationName:  sourceLocationName ?? this.sourceLocationName,
      destLocationName:    destLocationName   ?? this.destLocationName,
    );
  }

  // ─── Parsers ──────────────────────────────────────────────────────────────

  static String _formatNumber(String raw) {
    if (raw.isEmpty) return '';
    final d = double.tryParse(raw);
    if (d == null) return raw;
    return d == d.truncateToDouble() ? d.toInt().toString() : raw;
  }

  static String _extractTruckPlate(dynamic refnums) {
    if (refnums == null) return '';
    final items = refnums is List
        ? refnums
        : (refnums is Map ? (refnums['items'] as List?) ?? [] : []);
    for (final r in items) {
      if (r is Map) {
        final qual = r['shipGroupRefnumQualGid']?.toString() ?? '';
        if (qual.toUpperCase().contains('TRUCK_PLATE_NUMBER')) {
          return r['shipGroupRefnumValue']?.toString() ?? '';
        }
      }
    }
    return '';
  }

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

  /// Extracts the human-readable location name from an expanded location object.
  /// The API returns `locationName` as either a plain string or a `{value: ...}` map.
  static String _extractLocationName(dynamic location) {
    if (location == null) return '';
    if (location is Map) {
      final raw = location['locationName'];
      if (raw == null) return '';
      if (raw is String) return raw.trim();
      if (raw is Map) return raw['value']?.toString().trim() ?? '';
    }
    return '';
  }

  static String _extractValue(dynamic obj) {
    if (obj == null) return '';
    if (obj is String) return obj;
    if (obj is Map) return obj['value']?.toString() ?? '';
    return obj.toString();
  }

  static String _extractMeasure(dynamic obj) {
    if (obj == null) return '';
    if (obj is Map) {
      final val  = obj['value'];
      final unit = obj['unit']?.toString() ?? '';
      if (val != null) {
        final n = val is double ? val.toStringAsFixed(2) : val.toString();
        return '$n $unit'.trim();
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

// ─── GroupStatus ──────────────────────────────────────────────────────────────

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