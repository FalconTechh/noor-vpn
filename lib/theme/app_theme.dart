import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Noor VPN brand tokens — matched to the official app logo:
/// deep navy shield + electric cyan-blue glow, silver "Noor" / cyan "VPN".
class AppColors {
  static const Color midnight = Color(0xFF060B18); // background
  static const Color midnightDeep = Color(0xFF03060D); // gradient base
  static const Color panel = Color(0xFF0F1B33); // cards / sheets
  static const Color panelLight = Color(0xFF16264A);

  static const Color cyanGlow = Color(0xFF3EC6F0); // signature glow (idle/connect)
  static const Color cyanDeep = Color(0xFF1E90D6);
  static const Color connectedGreenCyan = Color(0xFF2FE0C0); // connected state
  static const Color redAlert = Color(0xFFE0556F); // disconnect / error
  static const Color silver = Color(0xFFE9EEF5); // "Noor" wordmark tone

  static const Color textPrimary = Color(0xFFE8ECF6);
  static const Color textSecondary = Color(0xFF8B9AB3);
  static const Color divider = Color(0xFF1C2A48);
}

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.midnight,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.cyanGlow,
        secondary: AppColors.connectedGreenCyan,
        surface: AppColors.panel,
        error: AppColors.redAlert,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.cairo(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 0.2,
        ),
        headlineMedium: GoogleFonts.cairo(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      dividerColor: AppColors.divider,
    );
  }

  static const LinearGradient nightSky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.midnightDeep, AppColors.midnight, Color(0xFF0B1730)],
  );

  static RadialGradient cyanGlowGradient({double opacity = 0.35}) => RadialGradient(
        colors: [
          AppColors.cyanGlow.withOpacity(opacity),
          AppColors.cyanGlow.withOpacity(0.0),
        ],
      );
}
