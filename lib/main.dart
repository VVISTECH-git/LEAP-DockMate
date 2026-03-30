import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:leap_dockmate/core/services/api_client.dart';
import 'package:leap_dockmate/features/auth/screens/splash_screen.dart';
import 'package:leap_dockmate/features/auth/screens/login_screen.dart';
import 'package:leap_dockmate/features/shipment_groups/providers/shipment_groups_provider.dart';
import 'package:leap_dockmate/features/shipment_groups/screens/shipment_groups_screen.dart';
import 'package:leap_dockmate/core/theme/leap_theme.dart';
import 'package:leap_dockmate/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  final themeProvider = LeapThemeProvider(defaultTheme: LeapThemes.navy);
  unawaited(themeProvider.loadSavedTheme());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => ShipmentGroupsProvider()),
      ],
      child: const LeapDockMateApp(),
    ),
  );
}

class LeapDockMateApp extends StatelessWidget {
  const LeapDockMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<LeapThemeProvider>();

    return MaterialApp(
      title: 'LEAP DockMate',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.toMaterialTheme(),

      // ── Navigator key — lets ApiClient redirect to /login on 401 ──────────
      navigatorKey: ApiClient.navigatorKey,

      // ── Fixed English locale only ──────────────────────────────────────────
      locale: const Locale('en'),
      supportedLocales: const [Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ── Named routes ───────────────────────────────────────────────────────
      initialRoute: '/',
      routes: {
        '/':      (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home':  (_) => const ShipmentGroupsScreen(),
      },
    );
  }
}
