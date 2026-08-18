import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(title: Text('Terms of Service', style: GoogleFonts.cairo(fontSize: 18))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(
              'Acceptance',
              'By using Noor VPN, you agree to these terms. If you do not '
                  'agree, please do not use the app.',
            ),
            _section(
              'Service Description',
              'Noor VPN provides an encrypted VPN connection to help protect '
                  'your privacy online. Some server locations require watching '
                  'a rewarded ad or a Premium subscription to unlock.',
            ),
            _section(
              'Acceptable Use',
              'You agree not to use Noor VPN for illegal activities, including '
                  'but not limited to fraud, unauthorized access to systems, or '
                  'distribution of harmful content.',
            ),
            _section(
              'Subscriptions',
              'Premium subscriptions are billed through Google Play Billing and '
                  'renew automatically unless cancelled at least 24 hours before '
                  'the renewal date, via Google Play > Subscriptions.',
            ),
            _section(
              'Disclaimer',
              'Noor VPN is provided "as is" without warranties of any kind. We '
                  'do not guarantee uninterrupted or error-free service.',
            ),
            _section(
              'Changes to Terms',
              'We may update these terms from time to time. Continued use of '
                  'the app after changes constitutes acceptance of the new terms.',
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
