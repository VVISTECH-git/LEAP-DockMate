import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/session_service.dart';
import '../models/shipment_group_model.dart';

class ShipmentGroupService {
  ShipmentGroupService._();
  static final ShipmentGroupService instance = ShipmentGroupService._();

  Future<List<ShipmentGroup>> fetchGroups({int limit = 100, int offset = 0}) async {
    // FIX: All debugPrint calls wrapped in kDebugMode — no logging in production builds.
    if (kDebugMode) {
      debugPrint('=== fetchGroups START ===');
      debugPrint('URL: ${AppConstants.pathShipmentGroups}?limit=$limit&offset=$offset&expand=statuses,refnums');
    }

    final data = await ApiClient.instance.get(
      '${AppConstants.pathShipmentGroups}?limit=$limit&offset=$offset&expand=statuses,refnums',
    );

    if (kDebugMode) {
      debugPrint('=== fetchGroups RESPONSE ===');
      debugPrint('count: ${data['count']}');
      debugPrint('hasMore: ${data['hasMore']}');
    }

    final items = (data['items'] as List<dynamic>?) ?? [];
    if (kDebugMode) debugPrint('items length: ${items.length}');

    final groups = items
        .map((j) => ShipmentGroup.fromJson(j as Map<String, dynamic>))
        .toList();

    if (kDebugMode) {
      debugPrint('parsed groups: ${groups.length}');
      for (final g in groups) {
        debugPrint('  → ${g.shipGroupXid} | type: ${g.shipGroupTypeGid} | inbound: ${g.isInbound}');
      }
    }

    // Hydrate location names
    return _hydrateLocationNames(groups);
  }

  Future<ShipmentGroup> fetchById(String groupId) async {
    final domain = await SessionService.instance.domain;
    final gid = groupId.contains('.') ? groupId : '$domain.$groupId';

    if (kDebugMode) debugPrint('=== fetchById: $gid ===');

    final data = await ApiClient.instance
        .get('${AppConstants.pathShipmentGroups}/$gid');

    final group = ShipmentGroup.fromJson(data as Map<String, dynamic>);

    final names = await Future.wait([
      _fetchLocationName(group.sourceLocation),
      _fetchLocationName(group.destinationLocation),
    ]);

    return group.copyWith(
      sourceLocationName: names[0],
      destLocationName:   names[1],
    );
  }

  Future<String> _fetchLocationName(String locationGid) async {
    if (locationGid.isEmpty) return '';
    try {
      if (kDebugMode) debugPrint('=== fetchLocationName: $locationGid ===');
      final data = await ApiClient.instance.get(
        '${AppConstants.pathLocations}/$locationGid?fields=locationName',
      );
      final n = data['locationName'];
      final name = (n is Map ? n['value'] : n)?.toString() ?? locationGid;
      if (kDebugMode) debugPrint('  → name: $name');
      return name;
    } catch (e) {
      if (kDebugMode) debugPrint('  → error: $e, falling back to GID');
      return locationGid;
    }
  }

  Future<List<ShipmentGroup>> _hydrateLocationNames(
      List<ShipmentGroup> groups) async {
    final gids = <String>{
      for (final g in groups) ...[
        if (g.sourceLocation.isNotEmpty) g.sourceLocation,
        if (g.destinationLocation.isNotEmpty) g.destinationLocation,
      ],
    };

    if (kDebugMode) debugPrint('=== hydrateLocationNames: ${gids.length} unique GIDs ===');

    final nameMap = <String, String>{};
    await Future.wait(gids.map((gid) async {
      nameMap[gid] = await _fetchLocationName(gid);
    }));

    return groups.map((g) => g.copyWith(
      sourceLocationName: nameMap[g.sourceLocation] ?? g.sourceLocation,
      destLocationName:   nameMap[g.destinationLocation] ?? g.destinationLocation,
    )).toList();
  }
}
