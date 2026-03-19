import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:leap_dockmate/features/auth/screens/splash_screen.dart';
import 'package:leap_dockmate/features/shipment_groups/providers/shipment_groups_provider.dart';

// ─── Unified LEAP theme system ────────────────────────────────────────────────
import 'package:leap_dockmate/core/theme/leap_theme.dart';

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

  // DockMate default theme: Forest Green (dock confirmed, calm authority)
  // Users can switch to any of the 9 themes via LeapThemePicker.
  final themeProvider = LeapThemeProvider(defaultTheme: LeapThemes.forest);
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
      home: const SplashScreen(),
    );
  }
}