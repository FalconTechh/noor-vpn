import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _pulse;
  late final AnimationController _orbit;
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
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _entrance, curve: Curves.easeOutBack),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entrance, curve: const Interval(0.0, 0.7)),
    );
    _entrance.forward();

    Future.delayed(const Duration(milliseconds: 2400), () {
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
    _orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.nightSky),
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (context, _) {
                  final size = 340 + (_pulse.value * 40);
                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.cyanGlow.withOpacity(0.10),
                          AppColors.cyanGlow.withOpacity(0.0),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_entrance, _pulse, _orbit]),
                builder: (context, child) {
                  final glow = 0.35 + (_pulse.value * 0.25);
                  final angle = _orbit.value * 2 * math.pi;
                  return Opacity(
                    opacity: _opacity.value,
                    child: Transform.scale(
                      scale: _scale.value,
                      child: SizedBox(
                        width: 260,
                        height: 260,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.rotate(
                              angle: angle,
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: SweepGradient(
                                    colors: [
                                      AppColors.cyanGlow.withOpacity(0.0),
                                      AppColors.cyanGlow.withOpacity(0.8),
                                      AppColors.cyanGlow.withOpacity(0.0),
                                    ],
                                    stops: const [0.0, 0.15, 0.35],
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 216,
                                    height: 216,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.midnight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 190,
                              height: 190,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.cyanGlow.withOpacity(glow),
                                    blurRadius: 40,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                      'assets/images/app_logo_transparent.png',
                      fit: BoxFit.contain,
                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 64,
              child: AnimatedBuilder(
                animation: _entrance,
                builder: (context, child) => Opacity(
                  opacity: _opacity.value,
                  child: child,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation(
                          AppColors.cyanGlow.withOpacity(0.8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Establishing secure session…',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        letterSpacing: 0.4,
                        color: AppColors.textSecondary,
                      ),
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
}
