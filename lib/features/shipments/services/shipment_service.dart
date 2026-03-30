import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/session_service.dart';
import '../models/shipment_model.dart';

class ShipmentService {
  ShipmentService._();
  static final ShipmentService instance = ShipmentService._();

  /// Fetches all shipments belonging to a shipment group in a single API call.
  /// GET /shipmentGroups/{domain.xid}/shipmentDetails?expand=shipment&fields=shipment.*
  Future<List<Shipment>> fetchByGroup(String shipGroupGid) async {
    // Ensure the GID has a domain prefix (e.g. "OTM1.SG30030973").
    // If it's missing or empty, fall back to the session domain.
    String gid = shipGroupGid;
    if (!gid.contains('.') || gid.startsWith('.')) {
      final domain = await SessionService.instance.domain;
      final xid    = gid.startsWith('.') ? gid.substring(1) : gid;
      gid = '$domain.$xid';
    }

    const fields =
        'shipment.shipmentXid,shipment.transportModeGid,'
        'shipment.totalActualCost,shipment.totalWeightedCost,'
        'shipment.loadedDistance,shipment.sourceLocationGid,'
        'shipment.destLocationGid,shipment.startTime,shipment.endTime,'
        'shipment.totalShipUnitCount,shipment.totalWeight,shipment.totalVolume';

    final path =
        '${AppConstants.pathShipmentGroups}/$gid/shipmentDetails'
        '?expand=shipment'
        '&fields=$fields';

    if (kDebugMode) debugPrint('=== fetchShipmentDetails: $path ===');

    final data  = await ApiClient.instance.get(path);
    final items = (data['items'] as List<dynamic>?) ?? [];

    if (kDebugMode) debugPrint('shipmentDetails count: ${items.length}');

    return items
        .map((item) => Shipment.fromShipmentDetail(item as Map<String, dynamic>))
        .toList();
  }
}