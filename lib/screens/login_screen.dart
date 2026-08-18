import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

/// Login screen — real Google Sign-In, PLUS a mandatory "Continue as Guest"
/// option.
///
/// ⚠️ Play Store policy note: Google requires that login NEVER be forced
/// if the app's core function doesn't strictly need an account. A VPN's
/// core function (connecting) does not need an account, so guest access
/// must stay available — removing it risks rejection under the
/// "Account creation" policy in Play Console.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  String? _errorMessage;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        // User cancelled the picker — not an error, just stop loading.
        setState(() => _loading = false);
        return;
      }
      // Signed in successfully. account.email / account.displayName /
      // account.photoUrl are now available if you want to show them
      // elsewhere in the app (e.g. a profile section in Settings).
      if (!mounted) return;
      setState(() => _loading = false);
      _goHome();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = 'Sign-in failed. Please try again.';
      });
    }
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.nightSky),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 3),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyanGlow.withOpacity(0.35),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset('assets/images/app_logo.png', fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Welcome to Noor VPN',
                  style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to sync your servers, settings and\nPremium plan across devices.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.textSecondary, height: 1.6),
                ),
                const Spacer(flex: 2),

                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: GoogleFonts.inter(color: AppColors.redAlert, fontSize: 12.5),
                  ),
                  const SizedBox(height: 10),
                ],

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1F1F1F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 2,
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                height: 19,
                                errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 22),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Continue with Google',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.divider)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('OR', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
                    ),
                    Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),
                const SizedBox(height: 18),

                TextButton(
                  onPressed: _loading ? null : _goHome,
                  child: Text(
                    'Continue as Guest',
                    style: GoogleFonts.inter(
                      color: AppColors.cyanGlow,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),

                const Spacer(flex: 3),
                Text.rich(
                  TextSpan(
                    style: GoogleFonts.inter(fontSize: 10.5, color: AppColors.textSecondary, height: 1.6),
                    children: [
                      const TextSpan(text: "By continuing, you agree to Noor VPN's "),
                      TextSpan(text: 'Terms of Service', style: TextStyle(color: AppColors.cyanGlow)),
                      const TextSpan(text: ' and '),
                      TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.cyanGlow)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
