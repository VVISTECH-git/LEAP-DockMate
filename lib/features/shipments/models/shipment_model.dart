import 'package:flutter/foundation.dart';

// ─── EET conversion ───────────────────────────────────────────────────────────
DateTime? toEet(String? utcStr) {
  if (utcStr == null || utcStr.isEmpty) return null;
  try {
    final utc      = DateTime.parse(utcStr).toUtc();
    final year     = utc.year;
    final dstStart = _lastSundayOf(year, 3);
    final dstEnd   = _lastSundayOf(year, 10);
    final isDst    = utc.isAfter(dstStart) && utc.isBefore(dstEnd);
    return utc.add(Duration(hours: isDst ? 3 : 2));
  } catch (_) {
    return null;
  }
}

DateTime _lastSundayOf(int year, int month) {
  var day = DateTime.utc(year, month + 1, 0);
  while (day.weekday != DateTime.sunday) {
    day = day.subtract(const Duration(days: 1));
  }
  return DateTime.utc(day.year, day.month, day.day, 1, 0);
}

// ─── Shipment ─────────────────────────────────────────────────────────────────

class Shipment {
  final String shipmentGid;
  final String shipmentXid;
  final String domainName;
  final String sourceLocation;        // GID
  final String destinationLocation;   // GID
  final String sourceLocationName;
  final String destLocationName;
  final String transportMode;         // e.g. "AIR", "ROAD"
  final String totalWeight;
  final String totalVolume;
  final String totalShipUnitCount;
  final String totalActualCost;
  final String totalWeightedCost;
  final String loadedDistance;
  final String startTimeUtc;
  final String endTimeUtc;

  const Shipment({
    required this.shipmentGid,
    required this.shipmentXid,
    required this.domainName,
    required this.sourceLocation,
    required this.destinationLocation,
    required this.startTimeUtc,
    required this.endTimeUtc,
    this.sourceLocationName  = '',
    this.destLocationName    = '',
    this.transportMode       = '',
    this.totalWeight         = '',
    this.totalVolume         = '',
    this.totalShipUnitCount  = '',
    this.totalActualCost     = '',
    this.totalWeightedCost   = '',
    this.loadedDistance      = '',
  });

  DateTime? get startTimeEet => toEet(startTimeUtc);
  DateTime? get endTimeEet   => toEet(endTimeUtc);

  String get displaySource =>
      sourceLocationName.isNotEmpty ? sourceLocationName : sourceLocation;
  String get displayDest =>
      destLocationName.isNotEmpty ? destLocationName : destinationLocation;

  // ─── fromShipmentDetail ───────────────────────────────────────────────────
  // Parses an item from:
  // GET /shipmentGroups/{gid}/shipmentDetails?expand=shipment&fields=shipment.*
  // The payload is: { "shipment": { "shipmentXid": ..., "sourceLocationGid": ..., ... } }
  factory Shipment.fromShipmentDetail(Map<String, dynamic> item) {
    final s = (item['shipment'] as Map<String, dynamic>?) ?? {};
    return Shipment.fromJson(s);
  }

  // ─── fromJson ─────────────────────────────────────────────────────────────
  factory Shipment.fromJson(Map<String, dynamic> json) {
    final xid    = json['shipmentXid']?.toString() ?? '';
    final domain = json['domainName']?.toString() ?? '';

    // sourceLocationGid / destLocationGid come as plain strings in this endpoint.
    final srcGid = json['sourceLocationGid']?.toString() ?? '';
    final dstGid = json['destLocationGid']?.toString() ?? '';

    // Transport mode GID — strip domain prefix if present (e.g. "OTM1.AIR" → "AIR").
    final rawMode = json['transportModeGid']?.toString() ?? '';
    final mode    = rawMode.contains('.') ? rawMode.split('.').last : rawMode;

    if (kDebugMode) {
      debugPrint('=== Shipment.fromJson: $xid | mode: $mode | src: $srcGid | dst: $dstGid ===');
    }

    return Shipment(
      shipmentGid:        domain.isNotEmpty ? '$domain.$xid' : xid,
      shipmentXid:        xid,
      domainName:         domain,
      sourceLocation:     srcGid,
      destinationLocation: dstGid,
      transportMode:      mode,
      totalWeight:        _extractMeasure(json['totalWeight']),
      totalVolume:        _extractMeasure(json['totalVolume']),
      totalShipUnitCount: _extractNum(json['totalShipUnitCount']),
      totalActualCost:    _extractMeasure(json['totalActualCost']),
      totalWeightedCost:  _extractMeasure(json['totalWeightedCost']),
      loadedDistance:     _extractMeasure(json['loadedDistance']),
      startTimeUtc:       _extractValue(json['startTime']),
      endTimeUtc:         _extractValue(json['endTime']),
    );
  }

  Shipment copyWith({
    String? sourceLocationName,
    String? destLocationName,
  }) => Shipment(
    shipmentGid:         shipmentGid,
    shipmentXid:         shipmentXid,
    domainName:          domainName,
    sourceLocation:      sourceLocation,
    destinationLocation: destinationLocation,
    startTimeUtc:        startTimeUtc,
    endTimeUtc:          endTimeUtc,
    sourceLocationName:  sourceLocationName ?? this.sourceLocationName,
    destLocationName:    destLocationName   ?? this.destLocationName,
    transportMode:       transportMode,
    totalWeight:         totalWeight,
    totalVolume:         totalVolume,
    totalShipUnitCount:  totalShipUnitCount,
    totalActualCost:     totalActualCost,
    totalWeightedCost:   totalWeightedCost,
    loadedDistance:      loadedDistance,
  );

  // ─── Parsers ──────────────────────────────────────────────────────────────

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

  static String _extractNum(dynamic obj) {
    if (obj == null) return '';
    if (obj is double) return obj.toInt().toString();
    return obj.toString();
  }
}