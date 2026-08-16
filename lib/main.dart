import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/ad_service.dart';

// Splash now routes to LoginScreen (see splash_screen.dart), which itself
// routes to HomeScreen either after Google Sign-In or "Continue as Guest".

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.instance.init();
  runApp(const NoorVpnApp());
}

class NoorVpnApp extends StatelessWidget {
  const NoorVpnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noor VPN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
