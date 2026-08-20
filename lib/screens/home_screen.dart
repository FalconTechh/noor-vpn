import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../theme/app_theme.dart';
import '../widgets/glow_orb_button.dart';
import '../models/server_model.dart';
import '../services/ad_service.dart';
import '../widgets/premium_sheet.dart';
import 'servers_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VpnUiState _state = VpnUiState.disconnected;
  VpnServer _selectedServer = demoServers.first;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = AdService.instance.createBannerAd(onLoaded: () {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _onOrbTap() {
    if (_state == VpnUiState.disconnected) {
      setState(() => _state = VpnUiState.connecting);
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _state = VpnUiState.connected);
      });
    } else if (_state == VpnUiState.connected) {
      setState(() => _state = VpnUiState.disconnected);
      AdService.instance.showInterstitialAfterDisconnect();
    }
  }

  String get _statusLabel {
    switch (_state) {
      case VpnUiState.connected:
        return 'Protected';
      case VpnUiState.connecting:
        return 'Securing your connection…';
      case VpnUiState.disconnected:
        return 'Tap to connect';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: AppTheme.nightSky)),
          Positioned(
            top: -80,
            right: -60,
            child: _blob(280, AppColors.cyanGlow.withOpacity(0.10)),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: _blob(320, AppColors.connectedGreenCyan.withOpacity(0.06)),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                const SizedBox(height: 12),
                _buildPremiumBanner(context),
                const SizedBox(height: 10),
                _buildServerPill(context),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _statusLabel,
                    key: ValueKey(_statusLabel),
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _state == VpnUiState.connected
                          ? AppColors.connectedGreenCyan
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                GlowOrbButton(state: _state, onTap: _onOrbTap, size: 250),
                const SizedBox(height: 28),
                if (_state == VpnUiState.connected) _buildStatsRow(),
                const Spacer(),
                if (_bannerAd != null)
                  SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Image.asset('assets/images/app_logo_transparent.png',
              width: 36, height: 36, fit: BoxFit.contain),
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(
              style: GoogleFonts.cairo(
                  fontSize: 18, fontWeight: FontWeight.w700),
              children: [
                TextSpan(text: 'Noor', style: TextStyle(color: AppColors.silver)),
                TextSpan(text: 'VPN', style: TextStyle(color: AppColors.cyanGlow)),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.panel.withOpacity(0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => PremiumSheet.show(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cyanGlow.withOpacity(0.35)),
                gradient: LinearGradient(
                  colors: [
                    AppColors.cyanGlow.withOpacity(0.20),
                    AppColors.connectedGreenCyan.withOpacity(0.10),
                  ],
                ),
              ),
              child: Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Go Premium',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13.5)),
                        Text('All countries · No ads · 10x faster',
                            style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServerPill(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () async {
          final picked = await Navigator.of(context).push<VpnServer>(
            MaterialPageRoute(builder: (_) => const ServersScreen()),
          );
          if (picked != null) setState(() => _selectedServer = picked);
        },
        child: _glassCard(
          child: Row(
            children: [
              const Icon(Icons.public, size: 18, color: AppColors.cyanGlow),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${_selectedServer.city}, ${_selectedServer.country}',
                  style: GoogleFonts.inter(
                      color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                ),
              ),
              if (_selectedServer.isPremium)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.cyanGlow.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('PREMIUM',
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.cyanGlow,
                          fontWeight: FontWeight.w700)),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: _glassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statItem(Icons.speed, '48 Mbps'),
            Container(width: 1, height: 26, color: Colors.white.withOpacity(0.08)),
            _statItem(Icons.timer_outlined, '00:00:12'),
            Container(width: 1, height: 26, color: Colors.white.withOpacity(0.08)),
            _statItem(Icons.lock_outline, 'AES-256'),
          ],
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.cyanGlow),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
