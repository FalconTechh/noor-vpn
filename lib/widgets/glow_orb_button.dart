import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum VpnUiState { disconnected, connecting, connected }

/// The signature element of Noor VPN: a glowing orb button with an
/// orbiting ring — echoes the shield logo's rotating light band.
/// - Disconnected: dim, static ring.
/// - Connecting: ring spins fast, pulsing glow.
/// - Connected: ring settles into a slow steady orbit, teal-cyan glow.
class GlowOrbButton extends StatefulWidget {
  final VpnUiState state;
  final VoidCallback onTap;
  final double size;

  const GlowOrbButton({
    super.key,
    required this.state,
    required this.onTap,
    this.size = 220,
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
      duration: const Duration(seconds: 6),
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
        return AppColors.cyanGlow.withOpacity(0.5);
    }
  }

  double get _orbitSpeedFactor {
    switch (widget.state) {
      case VpnUiState.connecting:
        return 4.0; // fast spin while negotiating tunnel
      case VpnUiState.connected:
        return 0.6; // slow calm orbit once secured
      case VpnUiState.disconnected:
        return 0.15;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_orbitController, _pulseController]),
        builder: (context, _) {
          final pulse = 0.85 + (_pulseController.value * 0.15);
          final angle =
              _orbitController.value * 2 * math.pi * _orbitSpeedFactor;

          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ambient glow
                Container(
                  width: widget.size * pulse,
                  height: widget.size * pulse,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _glowColor.withOpacity(0.35),
                        _glowColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
                // Orbit ring (echoes the logo's rotating band)
                Transform.rotate(
                  angle: angle,
                  child: Container(
                    width: widget.size * 0.82,
                    height: widget.size * 0.82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _glowColor.withOpacity(0.0),
                      ),
                      gradient: SweepGradient(
                        colors: [
                          _glowColor.withOpacity(0.0),
                          _glowColor.withOpacity(0.9),
                          _glowColor.withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.15, 0.35],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: widget.size * 0.82 - 4,
                        height: widget.size * 0.82 - 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.midnight,
                        ),
                      ),
                    ),
                  ),
                ),
                // Core button
                Container(
                  width: widget.size * 0.62,
                  height: widget.size * 0.62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.panelLight,
                        AppColors.panel,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _glowColor.withOpacity(0.55),
                        blurRadius: 24,
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(
                      color: _glowColor.withOpacity(0.8),
                      width: 1.4,
                    ),
                  ),
                  child: Icon(
                    Icons.shield_outlined,
                    size: widget.size * 0.24,
                    color: _glowColor,
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
