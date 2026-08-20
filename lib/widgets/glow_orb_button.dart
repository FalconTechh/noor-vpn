import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum VpnUiState { disconnected, connecting, connected }

class GlowOrbButton extends StatefulWidget {
  final VpnUiState state;
  final VoidCallback onTap;
  final double size;

  const GlowOrbButton({
    super.key,
    required this.state,
    required this.onTap,
    this.size = 240,
  });

  @override
  State<GlowOrbButton> createState() => _GlowOrbButtonState();
}

class _GlowOrbButtonState extends State<GlowOrbButton>
    with TickerProviderStateMixin {
  late final AnimationController _orbitController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color get _glowColor {
    switch (widget.state) {
      case VpnUiState.connected:
        return AppColors.connectedGreenCyan;
      case VpnUiState.connecting:
        return AppColors.cyanGlow;
      case VpnUiState.disconnected:
        return AppColors.cyanGlow.withOpacity(0.6);
    }
  }

  double get _orbitSpeedFactor {
    switch (widget.state) {
      case VpnUiState.connecting:
        return 3.2;
      case VpnUiState.connected:
        return 0.5;
      case VpnUiState.disconnected:
        return 0.18;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_orbitController, _pulseController]),
        builder: (context, _) {
          final pulse = 0.88 + (_pulseController.value * 0.12);
          final baseAngle =
              _orbitController.value * 2 * math.pi * _orbitSpeedFactor;

          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: widget.size * pulse,
                  height: widget.size * pulse,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _glowColor.withOpacity(0.30),
                        _glowColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),

                ...List.generate(3, (i) {
                  final angle = baseAngle + (i * (2 * math.pi / 3));
                  final radius = widget.size * 0.40;
                  final dx = math.cos(angle) * radius;
                  final dy = math.sin(angle) * radius;
                  final particleOpacity = 0.35 + (i * 0.2);
                  return Transform.translate(
                    offset: Offset(dx, dy),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _glowColor.withOpacity(particleOpacity + 0.4),
                        boxShadow: [
                          BoxShadow(
                            color: _glowColor.withOpacity(0.8),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                Container(
                  width: widget.size * 0.84,
                  height: widget.size * 0.84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _glowColor.withOpacity(0.28),
                      width: 1,
                    ),
                  ),
                ),

                Container(
                  width: widget.size * 0.64,
                  height: widget.size * 0.64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.35, -0.4),
                      radius: 1.1,
                      colors: [
                        AppColors.panelLight.withOpacity(1.0),
                        AppColors.panel,
                        AppColors.midnightDeep,
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _glowColor.withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 1,
                      ),
                      const BoxShadow(
                        color: Colors.black45,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: _glowColor.withOpacity(0.85),
                      width: 1.6,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: widget.size * 0.06,
                        left: widget.size * 0.08,
                        child: Container(
                          width: widget.size * 0.22,
                          height: widget.size * 0.12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.22),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.shield_outlined,
                        size: widget.size * 0.24,
                        color: _glowColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
