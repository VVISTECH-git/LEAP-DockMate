import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/leap_theme.dart';
import '../models/shipment_model.dart';
import '../services/shipment_service.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';

class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({
    super.key,
    required this.shipGroupGid,
    required this.shipGroupXid,
    required this.expectedCount,
  });

  final String shipGroupGid;
  final String shipGroupXid;
  final int    expectedCount;

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  List<Shipment> _shipments = [];
  bool   _loading = true;
  String _error   = '';

  @override
  void initState() {
    super.initState();
    _fetchShipments();
  }

  Future<void> _fetchShipments() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final result = await ShipmentService.instance
          .fetchByGroup(widget.shipGroupGid);
      setState(() { _shipments = result; _loading = false; });
    } catch (e) {
      setState(() {
        _error   = e.toString().replaceAll('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LeapThemeProvider>().theme;

    return Scaffold(
      backgroundColor: t.surface1,
      appBar: AppBar(
        backgroundColor: t.navColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.shipments,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17)),
            Text(widget.shipGroupXid,
                style: const TextStyle(
                    color: Color(0xFF7EB3FF),
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          if (!_loading && _shipments.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 14),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: t.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_shipments.length}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
      body: _buildBody(context, t),
    );
  }

  Widget _buildBody(BuildContext context, AppThemeData t) {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: t.primary, strokeWidth: 2.5),
            const SizedBox(height: 14),
            Text('${AppLocalizations.of(context)!.shipments}…',
                style: TextStyle(fontSize: 13, color: t.textMuted)),
          ],
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('😕', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text(_error,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: t.primary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchShipments,
                style: ElevatedButton.styleFrom(
                    backgroundColor: t.primary),
                child: Text(AppLocalizations.of(context)!.retry,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    if (_shipments.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: t.textMuted),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.shipments,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: t.primary)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: t.primary,
      onRefresh: _fetchShipments,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
        itemCount: _shipments.length,
        itemBuilder: (_, i) => _ShipmentTile(shipment: _shipments[i]),
      ),
    );
  }
}

// ─── Shipment Tile ────────────────────────────────────────────────────────────

class _ShipmentTile extends StatelessWidget {
  const _ShipmentTile({required this.shipment});
  final Shipment shipment;

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LeapThemeProvider>().theme;
    final s = shipment;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: t.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left bar
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: AppConstants.outboundBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top: shipment ID + weight pill
                    Row(
                      children: [
                        Expanded(
                          child: Text(s.shipmentXid,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: t.primary),
                              overflow: TextOverflow.ellipsis),
                        ),
                        if (s.totalWeight.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: t.surface1,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: t.border),
                            ),
                            child: Text(s.totalWeight,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: t.textMuted)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Route: source → destination
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                  width: 7, height: 7,
                                  decoration: const BoxDecoration(
                                    color: AppConstants.inboundGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(AppLocalizations.of(context)!.pickup,
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: t.textMuted,
                                        letterSpacing: 0.5)),
                              ]),
                              const SizedBox(height: 2),
                              Text(s.displaySource,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: t.text),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward_rounded,
                              size: 14,
                              color: t.textMuted.withValues(alpha: 0.4)),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(AppLocalizations.of(context)!.delivery,
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: t.textMuted,
                                          letterSpacing: 0.5)),
                                  const SizedBox(width: 5),
                                  Container(
                                    width: 7, height: 7,
                                    decoration: const BoxDecoration(
                                      color: AppConstants.errorRed,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(s.displayDest,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: t.text),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Dates row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('START TIME',
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: t.textMuted,
                                      letterSpacing: 0.4)),
                              const SizedBox(height: 2),
                              Text(_fmtEet(s.startTimeEet),
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2D3436))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('END TIME',
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: t.textMuted,
                                      letterSpacing: 0.4)),
                              const SizedBox(height: 2),
                              Text(_fmtEet(s.endTimeEet),
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2D3436))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtEet(DateTime? dt) {
    if (dt == null) return 'N/A';
    return DateFormat('dd MMM yyyy • HH:mm').format(dt);
  }
}