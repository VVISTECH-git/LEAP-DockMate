import 'package:flutter/foundation.dart';
import '../models/shipment_group_model.dart';
import '../services/shipment_group_service.dart';
import '../../../core/services/session_service.dart';

enum LoadState { idle, loading, success, error }

class ShipmentGroupsProvider extends ChangeNotifier {
  List<ShipmentGroup> _allGroups = [];
  LoadState _state = LoadState.idle;
  String _error    = '';

  // Team is now derived from shipGroupTypeGid — not stored separately
  // 'inbound' shows IMPORTER groups, 'outbound' shows EXPORTER groups
  // FIX: Default changed from 'outbound' to 'inbound' to match SessionService.lastTeam
  // default of 'inbound'. Both were contradicting each other before.
  String _team        = 'inbound';
  String _searchQuery = '';

  // ─── Getters ──────────────────────────────────────────────────────────────

  LoadState get state  => _state;
  String get error     => _error;
  String get team      => _team;
  String get searchQuery => _searchQuery;
  bool get isInbound   => _team == 'inbound';

  List<ShipmentGroup> get groups {
    // Filter by team first — IMPORTER = inbound, EXPORTER = outbound
    // FIX: Unknown type groups (neither IMPORTER nor EXPORTER) are now shown
    // under the current team rather than being silently dropped from both lists.
    var list = _allGroups.where((g) {
      if (g.isUnknown) return true; // show unknowns rather than hiding them
      return isInbound ? g.isInbound : g.isOutbound;
    }).toList();

    // Then apply search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((g) =>
          g.shipGroupXid.toLowerCase().contains(q) ||
          g.displaySource.toLowerCase().contains(q) ||
          g.displayDest.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  int get inboundCount  => _allGroups.where((g) => g.isInbound).length;
  int get outboundCount => _allGroups.where((g) => g.isOutbound).length;

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> init() async {
    _team = await SessionService.instance.lastTeam;
    await load();
  }

  Future<void> load() async {
    _state = LoadState.loading;
    _error = '';
    notifyListeners();

    try {
      _allGroups = await ShipmentGroupService.instance.fetchGroups();
      // FIX: debugPrint guarded by kDebugMode
      if (kDebugMode) {
        debugPrint('Provider: loaded ${_allGroups.length} total groups');
        debugPrint('  inbound: $inboundCount | outbound: $outboundCount');
      }
      _state = LoadState.success;
    } catch (e) {
      if (kDebugMode) debugPrint('Provider error: $e');
      _error = e.toString().replaceAll('Exception: ', '');
      _state = LoadState.error;
    }

    notifyListeners();
  }

  Future<void> switchTeam() async {
    _team = _team == 'inbound' ? 'outbound' : 'inbound';
    await SessionService.instance.setLastTeam(_team);
    _searchQuery = '';
    notifyListeners(); // no reload needed — filtering happens client-side
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
