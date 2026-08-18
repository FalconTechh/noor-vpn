import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(title: Text('Privacy Policy', style: GoogleFonts.cairo(fontSize: 18))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(
              'What We Collect',
              'Noor VPN collects only what is needed to run the service: '
                  'basic device diagnostics (crash logs, app version) to fix bugs, '
                  'and an advertising ID (via Google AdMob) to show ads that keep '
                  'the app free.',
            ),
            _section(
              'What We Don\'t Do',
              'We do not log or monitor the websites you visit while connected. '
                  'We do not sell your personal data to third parties.',
            ),
            _section(
              'Permissions',
              'The VPN Service permission is required to create the secure '
                  'encrypted tunnel — this is the core function of the app. '
                  'Internet access is required to connect to servers and load ads.',
            ),
            _section(
              'Third-Party Services',
              'Google AdMob (advertising), and our VPN server infrastructure '
                  '(routes your encrypted traffic).',
            ),
            _section(
              'Your Rights',
              'You can request deletion of any data linked to your account by '
                  'contacting support (see Settings > Contact Support).',
            ),
            _section(
              'Children\'s Privacy',
              'Noor VPN is not directed at children under 13.',
            ),
            const SizedBox(height: 20),
            Text(
              'Last updated: 2026',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(body, style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.textSecondary, height: 1.6)),
        ],
      ),
    );
  }
}
