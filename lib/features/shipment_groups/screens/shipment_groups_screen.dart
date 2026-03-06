import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../models/shipment_group_model.dart';
import '../providers/shipment_groups_provider.dart';
import 'shipment_group_detail_screen.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/services/auth_service.dart';

class ShipmentGroupsScreen extends StatefulWidget {
  const ShipmentGroupsScreen({super.key});

  @override
  State<ShipmentGroupsScreen> createState() => _ShipmentGroupsScreenState();
}

class _ShipmentGroupsScreenState extends State<ShipmentGroupsScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShipmentGroupsProvider>().init();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgGrey,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            _buildSearchBar(context),
            _buildListMeta(context),
            const Expanded(child: _GroupList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final provider = context.watch<ShipmentGroupsProvider>();
    final isIB     = provider.isInbound;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppConstants.nokiaBlue,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _confirmSwitch(context, provider),
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                // FIX: withOpacity() deprecated in Flutter 3.27+. Use withValues(alpha:).
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1),
              ),
              child: const Center(
                child: Text('⇄', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('LEAP',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        height: 1.1)),
                Text('DockMate',
                    style: TextStyle(
                        color: Color(0xFF7EB3FF),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        height: 1.1)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isIB
                  ? const Color(0xFFE8F7F1)
                  : const Color(0xFFFFF3E8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isIB ? 'INBOUND' : 'OUTBOUND',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isIB
                    ? AppConstants.inboundGreen
                    : AppConstants.outboundOrange,
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
            onPressed: () => context.read<ShipmentGroupsProvider>().load(),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 22),
            onPressed: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      color: Colors.white,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppConstants.bgGrey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.search_rounded,
                color: AppConstants.textGrey, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                onChanged: (q) =>
                    context.read<ShipmentGroupsProvider>().setSearch(q),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search group ID, source, destination…',
                  hintStyle: TextStyle(
                    // FIX: withOpacity() deprecated. Use withValues(alpha:).
                    color: AppConstants.textGrey.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                  isDense: true,
                ),
              ),
            ),
            // FIX: Replaced bare _searchCtrl.text.isNotEmpty check (fragile rebuild reliance)
            // with ValueListenableBuilder so the X button reacts directly to controller changes.
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchCtrl,
              builder: (_, value, __) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return GestureDetector(
                  onTap: () {
                    _searchCtrl.clear();
                    context.read<ShipmentGroupsProvider>().setSearch('');
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.close_rounded,
                        color: AppConstants.textGrey, size: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListMeta(BuildContext context) {
    final count = context
        .select<ShipmentGroupsProvider, int>((p) => p.groups.length);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
      child: Text(
        '$count GROUP${count != 1 ? 'S' : ''}',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppConstants.textGrey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _confirmSwitch(BuildContext context, ShipmentGroupsProvider provider) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Switch to ${provider.isInbound ? 'Outbound' : 'Inbound'}?',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.nokiaBlue),
            ),
            const SizedBox(height: 6),
            Text(
              provider.isInbound
                  ? 'Show EXPORTER shipment groups'
                  : 'Show IMPORTER shipment groups',
              style: const TextStyle(
                  fontSize: 13, color: AppConstants.textGrey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppConstants.borderGrey),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(color: AppConstants.textGrey)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      provider.switchTeam();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.nokiaBlue,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Switch',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService.instance.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}

// ─── Group List ────────────────────────────────────────────────────────────────

class _GroupList extends StatelessWidget {
  const _GroupList();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShipmentGroupsProvider>();

    if (provider.state == LoadState.loading) {
      return const Center(
        child: CircularProgressIndicator(
            color: AppConstants.nokiaBlue, strokeWidth: 2.5),
      );
    }

    if (provider.state == LoadState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('😕', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text(provider.error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppConstants.nokiaBlue)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.load,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.nokiaBlue),
                child: const Text('Retry',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final groups     = provider.groups;
    final otherCount = provider.isInbound
        ? provider.outboundCount
        : provider.inboundCount;
    final otherTeam  = provider.isInbound ? 'Outbound' : 'Inbound';

    if (groups.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.inbox_outlined,
                      color: AppConstants.nokiaBlue, size: 30),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'No ${provider.isInbound ? "Inbound" : "Outbound"} Groups',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.nokiaBlue),
              ),
              const SizedBox(height: 6),
              Text(
                otherCount > 0
                    ? 'There are $otherCount $otherTeam group${otherCount > 1 ? "s" : ""} available.\nTap ⇄ to switch.'
                    : 'No shipment groups found.\nPull down to refresh.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, color: AppConstants.textGrey, height: 1.5),
              ),
              if (otherCount > 0) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: provider.switchTeam,
                  icon: const Text('⇄', style: TextStyle(fontSize: 14)),
                  // FIX: Was 'Switch to \$otherTeam' (escaped backslash) — literal text displayed.
                  // Corrected to proper string interpolation.
                  label: Text('Switch to $otherTeam'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.nokiaBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppConstants.nokiaBlue,
      onRefresh: provider.load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 16),
        itemCount: groups.length,
        itemBuilder: (_, i) => _GroupCard(
          group: groups[i],
          isInbound: provider.isInbound,
        ),
      ),
    );
  }
}

// ─── Group Card with ripple + scale animation ─────────────────────────────────

class _GroupCard extends StatefulWidget {
  const _GroupCard({required this.group, required this.isInbound});
  final ShipmentGroup group;
  final bool isInbound;

  @override
  State<_GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<_GroupCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final g    = widget.group;
    final isIB = widget.isInbound;

    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: (_) => _scaleCtrl.reverse(),
        onTapUp: (_) {
          _scaleCtrl.forward();
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ShipmentGroupDetailScreen(group: g),
            ),
          );
        },
        onTapCancel: () => _scaleCtrl.forward(),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppConstants.borderGrey, width: 1.5),
            boxShadow: [
              BoxShadow(
                // FIX: withOpacity() deprecated. Use withValues(alpha:).
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
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
                  decoration: BoxDecoration(
                    color: isIB
                        ? AppConstants.inboundGreen
                        : AppConstants.nokiaBlue,
                    borderRadius: const BorderRadius.only(
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
                        // Top row
                        Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: isIB
                                    ? const Color(0xFFE8F7F1)
                                    : const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  isIB ? '📥' : '📤',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    g.shipGroupXid,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppConstants.nokiaBlue,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${g.displaySource} → ${g.displayDest}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppConstants.textGrey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: isIB
                                    ? const Color(0xFFE8F7F1)
                                    : const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                g.shipGroupTypeGid,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: isIB
                                      ? AppConstants.inboundGreen
                                      : AppConstants.nokiaBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Meta row with improved shipment count
                        Row(
                          children: [
                            _MetaItem(label: 'START', value: _fmtDate(g.startTime)),
                            _MetaItem(label: 'END',   value: _fmtDate(g.endTime)),
                            // Shipments — big number
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${g.numberOfShipments}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppConstants.nokiaBlue,
                                      height: 1,
                                    ),
                                  ),
                                  const Text(
                                    'Shipments',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: AppConstants.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Bottom row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '⚖️ ${g.totalWeight.isNotEmpty ? g.totalWeight : 'N/A'}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.textGrey,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded,
                                size: 13, color: AppConstants.textGrey),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _fmtDate(String s) {
    if (s.isEmpty) return 'N/A';
    try { return DateFormat('dd MMM').format(DateTime.parse(s)); }
    catch (_) { return s; }
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textGrey,
                  letterSpacing: 0.4)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436)),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
