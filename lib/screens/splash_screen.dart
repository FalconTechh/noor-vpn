import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

/// Splash screen — logo already contains the full "NoorVPN" wordmark and
/// tagline baked into the image, so we don't repeat text below it.
/// Uses BoxFit.contain (never crops) with an animated entrance + pulsing
/// glow. Note: this animated screen only appears AFTER the Flutter engine
/// loads — the very first frame (Android's native splash, before that)
/// is necessarily a single static image; no app can animate that part,
/// it's an Android platform limitation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _pulse;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _entrance, curve: Curves.easeOutBack),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.7)),
    );
    _entrance.forward();

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, anim, __) => const LoginScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.nightSky),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_entrance, _pulse]),
            builder: (context, child) {
              final glow = 0.35 + (_pulse.value * 0.25);
              return Opacity(
                opacity: _opacity.value,
                child: Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyanGlow.withOpacity(glow),
                          blurRadius: 50,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
