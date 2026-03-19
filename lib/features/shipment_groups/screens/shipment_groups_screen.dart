import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/leap_theme.dart';
import '../../../core/providers/locale_provider.dart';
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
    final t = context.watch<LeapThemeProvider>().theme;
    return Scaffold(
      backgroundColor: t.surface1,
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
    final t        = context.watch<LeapThemeProvider>().theme;
    final provider = context.watch<ShipmentGroupsProvider>();
    final isIB     = provider.isInbound;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: t.navColor,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _confirmSwitch(context, provider),
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4), width: 1),
              ),
              child: const Center(
                child: Text('⇄',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
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
            icon: const Icon(Icons.refresh_rounded,
                color: Colors.white, size: 22),
            onPressed: () =>
                context.read<ShipmentGroupsProvider>().load(),
          ),
          // Settings — theme + language
          IconButton(
            icon: const Icon(Icons.tune_rounded,
                color: Colors.white, size: 22),
            onPressed: () => _showSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded,
                color: Colors.white, size: 22),
            onPressed: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final t = context.watch<LeapThemeProvider>().theme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      color: t.surface2,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: t.surface1,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: t.border, width: 1.5),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Icon(Icons.search_rounded, color: t.textMuted, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                onChanged: (q) =>
                    context.read<ShipmentGroupsProvider>().setSearch(q),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: t.text,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search group ID, source, destination…',
                  hintStyle: TextStyle(
                    color: t.textMuted.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                  isDense: true,
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchCtrl,
              builder: (_, value, __) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return GestureDetector(
                  onTap: () {
                    _searchCtrl.clear();
                    context.read<ShipmentGroupsProvider>().setSearch('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.close_rounded,
                        color: t.textMuted, size: 16),
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
    final t       = context.watch<LeapThemeProvider>().theme;
    final state   = context.select<ShipmentGroupsProvider, LoadState>((p) => p.state);
    final count   = context.select<ShipmentGroupsProvider, int>((p) => p.groups.length);
    // Don't show count while loading — prevents '0 GROUPS' flash
    if (state == LoadState.loading) return const SizedBox(height: 4);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
      child: Text(
        '$count GROUP${count != 1 ? 'S' : ''}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: t.textMuted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    final t = context.read<LeapThemeProvider>().theme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
              value: context.read<LeapThemeProvider>()),
          ChangeNotifierProvider.value(
              value: context.read<LocaleProvider>()),
        ],
        child: _SettingsSheet(theme: t),
      ),
    );
  }

  void _confirmSwitch(
      BuildContext context, ShipmentGroupsProvider provider) {
    final t = context.read<LeapThemeProvider>().theme;
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
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: t.text),
            ),
            const SizedBox(height: 6),
            Text(
              provider.isInbound
                  ? 'Show EXPORTER shipment groups'
                  : 'Show IMPORTER shipment groups',
              style: TextStyle(fontSize: 13, color: t.textMuted),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: t.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Cancel',
                        style: TextStyle(color: t.textMuted)),
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
                      backgroundColor: t.primary,
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

  Future<void> _logout(BuildContext context, {bool sessionExpired = false}) async {
    await AuthService.instance.logout();
    if (!context.mounted) return;
    if (sessionExpired) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Session expired — please sign in again',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: context.read<LeapThemeProvider>().theme.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(14),
        duration: const Duration(seconds: 3),
      ));
      await Future.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;
    }
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) => const LoginScreen(),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    ));
  }
}

// ─── Group List ────────────────────────────────────────────────────────────────

class _GroupList extends StatelessWidget {
  const _GroupList();

  @override
  Widget build(BuildContext context) {
    final t        = context.watch<LeapThemeProvider>().theme;
    final provider = context.watch<ShipmentGroupsProvider>();

    if (provider.state == LoadState.loading) {
      return Center(
        child: CircularProgressIndicator(
            color: t.primary, strokeWidth: 2.5),
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
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: t.primary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.load,
                style: ElevatedButton.styleFrom(
                    backgroundColor: t.primary),
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
                  color: t.surface3,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(Icons.inbox_outlined,
                      color: t.primary, size: 30),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'No ${provider.isInbound ? "Inbound" : "Outbound"} Groups',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: t.primary),
              ),
              const SizedBox(height: 6),
              Text(
                otherCount > 0
                    ? 'There are $otherCount $otherTeam group${otherCount > 1 ? "s" : ""} available.\nTap ⇄ to switch.'
                    : 'No shipment groups found.\nPull down to refresh.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: t.textMuted, height: 1.5),
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
                    backgroundColor: t.primary,
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
      color: t.primary,
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
    final t    = context.watch<LeapThemeProvider>().theme;
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
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => ShipmentGroupDetailScreen(group: g),
              transitionsBuilder: (_, animation, __, child) {
                final slide = Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation, curve: Curves.easeOutCubic));
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: slide, child: child),
                );
              },
              transitionDuration: const Duration(milliseconds: 280),
            ),
          );
        },
        onTapCancel: () => _scaleCtrl.forward(),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: t.border, width: 1.5),
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
                        : t.primary,
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
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: t.primary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${g.displaySource} → ${g.displayDest}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: t.textMuted,
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
                                      : t.primary,
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
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: t.primary,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    'Shipments',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: t.textMuted,
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
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: t.textMuted,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded,
                                size: 13, color: t.textMuted),
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
    final t = context.watch<LeapThemeProvider>().theme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: t.textMuted,
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


// ─── Settings sheet — theme + language in one place ───────────────────────────

class _SettingsSheet extends StatefulWidget {
  final AppThemeData theme;
  const _SettingsSheet({required this.theme});

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  int _tab = 0; // 0 = theme, 1 = language

  @override
  Widget build(BuildContext context) {
    final themeProvider  = context.watch<LeapThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final t              = themeProvider.theme;

    return Container(
      decoration: BoxDecoration(
        color: t.surface2,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Center(child: Container(
          width: 36, height: 4,
          decoration: BoxDecoration(
              color: t.border, borderRadius: BorderRadius.circular(2)),
        )),
        const SizedBox(height: 16),

        // Tab toggle
        Row(children: [
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _tab = 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _tab == 0 ? t.primary : t.surface1,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: _tab == 0 ? t.primary : t.border),
              ),
              child: Text('Theme', textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13, fontWeight: FontWeight.w700,
                  color: _tab == 0 ? Colors.white : t.textMuted)),
            ),
          )),
          const SizedBox(width: 8),
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _tab = 1),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _tab == 1 ? t.primary : t.surface1,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: _tab == 1 ? t.primary : t.border),
              ),
              child: Text('Language', textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13, fontWeight: FontWeight.w700,
                  color: _tab == 1 ? Colors.white : t.textMuted)),
            ),
          )),
        ]),
        const SizedBox(height: 16),

        // Theme grid
        if (_tab == 0)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10, mainAxisSpacing: 10,
              childAspectRatio: 2.6,
            ),
            itemCount: LeapThemes.all.length,
            itemBuilder: (_, i) {
              final theme    = LeapThemes.all[i];
              final selected = themeProvider.theme.id == theme.id;
              return GestureDetector(
                onTap: () => themeProvider.setTheme(theme),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? theme.navColor.withValues(alpha: 0.08)
                        : t.surface1,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? theme.primary : t.border,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(children: [
                    Row(mainAxisSize: MainAxisSize.min,
                      children: theme.swatchColors.map((c) => Container(
                        width: 13, height: 13,
                        margin: const EdgeInsets.only(right: 3),
                        decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(3)),
                      )).toList(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(theme.label,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 11, fontWeight: FontWeight.w700,
                            color: selected ? theme.primary : t.text),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                        Text(theme.description,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 9, color: t.textMuted,
                            fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      ],
                    )),
                    if (selected)
                      Container(
                        width: 18, height: 18,
                        decoration: BoxDecoration(
                            color: theme.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 12),
                      ),
                  ]),
                ),
              );
            },
          ),

        // Language grid
        if (_tab == 1)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10, mainAxisSpacing: 10,
              childAspectRatio: 3.2,
            ),
            itemCount: LocaleProvider.languages.length,
            itemBuilder: (_, i) {
              final lang     = LocaleProvider.languages[i];
              final code     = lang['code']!;
              final selected = localeProvider.locale.languageCode == code;
              return GestureDetector(
                onTap: () => localeProvider.setLocale(Locale(code)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? t.primary.withValues(alpha: 0.08)
                        : t.surface1,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? t.primary : t.border,
                      width: selected ? 2 : 1.5,
                    ),
                  ),
                  child: Row(children: [
                    Text(lang['flag']!,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(lang['name']!,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: selected ? t.primary : t.text),
                      overflow: TextOverflow.ellipsis)),
                    if (selected)
                      Icon(Icons.check_circle_rounded,
                          color: t.primary, size: 16),
                  ]),
                ),
              );
            },
          ),

        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity, height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: t.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
            ),
            child: const Text('Done',
              style: TextStyle(fontFamily: 'PlusJakartaSans',
                  fontSize: 16, fontWeight: FontWeight.w800)),
          ),
        ),
      ]),
    );
  }
}