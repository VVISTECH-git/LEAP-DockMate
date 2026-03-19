import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:leap_dockmate/core/theme/leap_theme.dart';
import 'package:leap_dockmate/core/services/session_service.dart';
import 'package:leap_dockmate/features/shipment_groups/screens/shipment_groups_screen.dart';
import 'login_screen.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// LEAP DockMate — Splash Screen (theme-aware)
//
// Now reads primary color and wordmark accent from LeapThemeProvider,
// so the splash adapts to whichever theme the user last selected.
// Route grid seed: 77 (DockMate-specific pattern).
// ═══════════════════════════════════════════════════════════════════════════════

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _bgCtrl;
  late AnimationController _logoCtrl;
  late AnimationController _tagCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _bgAnim;
  late Animation<double> _logoFade;
  late Animation<Offset>  _logoSlide;
  late Animation<double> _tagFade;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _bgCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _logoCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _tagCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);

    _bgAnim    = CurvedAnimation(parent: _bgCtrl,   curve: Curves.easeInOut);
    _logoFade  = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut);
    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutCubic));
    _tagFade   = CurvedAnimation(parent: _tagCtrl,  curve: Curves.easeOut);
    _pulse     = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _bgCtrl.forward().then((_) {
      _logoCtrl.forward().then((_) => _tagCtrl.forward());
    });
    Future.delayed(const Duration(milliseconds: 2800), _checkSession);
  }

  @override
  void dispose() {
    _bgCtrl.dispose(); _logoCtrl.dispose();
    _tagCtrl.dispose(); _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkSession() async {
    bool isLoggedIn = false;
    try {
      isLoggedIn = await SessionService.instance.isLoggedIn;
    } catch (_) {
      try { await SessionService.instance.clear(); } catch (_) {}
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) =>
          isLoggedIn ? const ShipmentGroupsScreen() : const LoginScreen(),
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 500),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<LeapThemeProvider>().theme;
    final size  = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(children: [
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _RouteGridPainter(progress: _bgAnim.value, accentColor: theme.primary),
            ),
          ),
          AnimatedBuilder(
            animation: _logoFade,
            builder: (_, __) => Positioned(
              left: size.width / 2 - 140, top: size.height / 2 - 220,
              child: Opacity(
                opacity: _logoFade.value * 0.45,
                child: Container(
                  width: 280, height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      theme.primary.withValues(alpha: 0.35), Colors.transparent,
                    ]),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SlideTransition(
                position: _logoSlide,
                child: FadeTransition(
                  opacity: _logoFade,
                  child: AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, __) => Stack(alignment: Alignment.center, children: [
                      Container(
                        width: 104 + (18 * _pulse.value),
                        height: 104 + (18 * _pulse.value),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.primary.withValues(alpha: 0.12 * _pulse.value),
                            width: 1.5,
                          ),
                        ),
                      ),
                      Container(
                        width: 88, height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: theme.primary.withValues(alpha: 0.38), width: 1.5),
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1E1E1E),
                          boxShadow: [BoxShadow(
                            color: theme.primary.withValues(alpha: 0.3),
                            blurRadius: 24, spreadRadius: 2,
                          )],
                        ),
                        child: Center(child: _DockIcon(color: theme.primary)),
                      ),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              FadeTransition(
                opacity: _logoFade,
                child: SlideTransition(
                  position: _logoSlide,
                  child: Column(children: [
                    const Text('LEAP',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 52, fontWeight: FontWeight.w800,
                        color: Colors.white, letterSpacing: 10, height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 28, height: 1.5, color: theme.primary),
                      const SizedBox(width: 10),
                      Text('DOCKMATE',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13, fontWeight: FontWeight.w700,
                          color: theme.primary, letterSpacing: 6,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(width: 28, height: 1.5, color: theme.primary),
                    ]),
                  ]),
                ),
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _tagFade,
                child: Column(children: [
                  Text('Dock Operations · OTM',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans', fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.38),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: 7, height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: LeapPlatform.oracleOrange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Powered by Oracle OTM',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans', fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.42),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ]),
                  ),
                ]),
              ),
            ]),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: FadeTransition(
              opacity: _tagFade,
              child: AnimatedBuilder(
                animation: _bgCtrl,
                builder: (_, __) => LinearProgressIndicator(
                  value: _bgCtrl.value,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  valueColor: AlwaysStoppedAnimation(theme.primary),
                  minHeight: 2,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  const _DockIcon({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: const Size(36, 36), painter: _DockIconPainter(color: color));
}

class _DockIconPainter extends CustomPainter {
  final Color color;
  const _DockIconPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
    final w = size.width; final h = size.height;
    canvas.drawPath(Path()
      ..moveTo(w * .1, h * .55)..lineTo(w * .1, h * .9)
      ..lineTo(w * .9, h * .9)..lineTo(w * .9, h * .55)
      ..lineTo(w * .5, h * .2)..close(), p);
    canvas.drawRect(Rect.fromLTWH(w * .35, h * .62, w * .3, h * .28), p..strokeWidth = 2.0);
  }
  @override
  bool shouldRepaint(_DockIconPainter old) => old.color != color;
}

class _RouteGridPainter extends CustomPainter {
  final double progress;
  final Color accentColor;
  const _RouteGridPainter({required this.progress, required this.accentColor});
  @override
  void paint(Canvas canvas, Size size) {
    final rand = math.Random(77); // DockMate-unique seed
    final lp = Paint()..strokeWidth = 1.0..style = PaintingStyle.stroke;
    for (int i = 0; i < 20; i++) {
      final sx = rand.nextDouble() * size.width; final sy = rand.nextDouble() * size.height;
      final ex = rand.nextDouble() * size.width; final ey = rand.nextDouble() * size.height;
      final alpha = (0.025 + rand.nextDouble() * 0.055) * progress;
      lp.color = accentColor.withValues(alpha: alpha);
      final mx = rand.nextBool() ? ex : sx; final my = rand.nextBool() ? sy : ey;
      final path = Path()..moveTo(sx, sy)..lineTo(mx, my)..lineTo(ex, ey);
      final m = path.computeMetrics().first;
      canvas.drawPath(m.extractPath(0, m.length * progress), lp);
      if (progress > 0.65) {
        canvas.drawCircle(Offset(ex, ey), 1.8,
            Paint()..color = accentColor.withValues(alpha: alpha * 2.5));
      }
    }
    final gp = Paint()
      ..color = Colors.white.withValues(alpha: 0.018 * progress)
      ..strokeWidth = 0.5;
    const step = 42.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gp);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gp);
    }
  }
  @override
  bool shouldRepaint(_RouteGridPainter old) => old.progress != progress || old.accentColor != accentColor;
}