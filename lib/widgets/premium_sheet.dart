import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum PremiumPlan { monthly, yearly }

/// Premium paywall bottom sheet.
///
/// ⚠️ Play Store policy: any subscription MUST go through Google Play
/// Billing (the `in_app_purchase` package). You cannot charge users via
/// an external payment link inside the app for digital content — that
/// is a hard Play Store policy violation and will get the app rejected.
/// See README "Step 8: Google Play Billing" for setup.
class PremiumSheet extends StatefulWidget {
  const PremiumSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const PremiumSheet(),
    );
  }

  @override
  State<PremiumSheet> createState() => _PremiumSheetState();
}

class _PremiumSheetState extends State<PremiumSheet> {
  PremiumPlan _plan = PremiumPlan.yearly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
      decoration: const BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColors.textSecondary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Text('⚡', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 6),
          Text('Noor VPN Premium',
              style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Unlock the full experience',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 18),

          _feature('All 30+ country servers unlocked'),
          _feature('No ads, ever'),
          _feature('10x faster priority servers'),
          _feature('Strict no-logs guarantee'),

          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _PlanCard(
                  label: 'Monthly',
                  price: '\$4.99',
                  period: '/ month',
                  selected: _plan == PremiumPlan.monthly,
                  onTap: () => setState(() => _plan = PremiumPlan.monthly),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PlanCard(
                  label: 'Yearly',
                  price: '\$23.99',
                  period: '/ year',
                  badge: 'SAVE 60%',
                  selected: _plan == PremiumPlan.yearly,
                  onTap: () => setState(() => _plan = PremiumPlan.yearly),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                // TODO: replace with real Google Play Billing purchase flow:
                // final ProductDetailsResponse response =
                //   await InAppPurchase.instance.queryProductDetails({productId});
                // InAppPurchase.instance.buyNonConsumable(purchaseParam: ...);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connect Google Play Billing here (see README Step 8)')),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.cyanGlow,
                foregroundColor: AppColors.midnight,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          Text('Cancel anytime · Billed via Google Play',
              style: GoogleFonts.inter(fontSize: 10.5, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _feature(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            const Icon(Icons.check_circle, size: 16, color: AppColors.connectedGreenCyan),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text, style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.textPrimary)),
            ),
          ],
        ),
      );
}

class _PlanCard extends StatelessWidget {
  final String label, price, period;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.label,
    required this.price,
    required this.period,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.cyanGlow : AppColors.divider,
            width: 1.4,
          ),
          color: selected ? AppColors.cyanGlow.withOpacity(0.08) : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            if (badge != null)
              Positioned(
                top: -22,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.cyanGlow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(badge!,
                      style: const TextStyle(
                          fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.midnight)),
                ),
              ),
            Column(
              children: [
                Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(price, style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.w700)),
                Text(period, style: GoogleFonts.inter(fontSize: 10.5, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
