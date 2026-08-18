import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _killSwitch = true;
  bool _autoConnect = false;

  Future<void> _openMailSupport() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'grapxo@gmail.com',
      query: 'subject=Noor VPN Support',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openPlayStoreListing() async {
    // TODO: once published, replace with your real Play Store package name.
    final uri = Uri.parse(
      'https://play.google.com/store/apps/details?id=app.noorvpn.android',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(title: Text('Settings', style: GoogleFonts.cairo(fontSize: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionLabel('Protection'),
          _switchTile(
            title: 'Kill Switch',
            subtitle: 'Block internet if VPN drops unexpectedly',
            value: _killSwitch,
            onChanged: (v) => setState(() => _killSwitch = v),
          ),
          _switchTile(
            title: 'Auto-connect',
            subtitle: 'Connect automatically on untrusted Wi-Fi',
            value: _autoConnect,
            onChanged: (v) => setState(() => _autoConnect = v),
          ),
          const SizedBox(height: 20),
          _sectionLabel('About'),
          _navTile(
            'Privacy Policy',
            Icons.privacy_tip_outlined,
            () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            ),
          ),
          _navTile(
            'Terms of Service',
            Icons.description_outlined,
            () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TermsScreen()),
            ),
          ),
          _navTile('Rate Noor VPN', Icons.star_outline, _openPlayStoreListing),
          _navTile('Contact Support', Icons.mail_outline, _openMailSupport),
          const SizedBox(height: 24),
          Center(
            child: Text('Noor VPN v1.0.0',
                style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4, left: 4),
        child: Text(text.toUpperCase(),
            style: GoogleFonts.inter(
                fontSize: 12,
                letterSpacing: 1.2,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600)),
      );

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: SwitchListTile(
        activeColor: AppColors.cyanGlow,
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _navTile(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.cyanGlow),
        title: Text(title, style: GoogleFonts.inter(color: AppColors.textPrimary)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
