import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/server_model.dart';
import '../services/ad_service.dart';

class ServersScreen extends StatefulWidget {
  const ServersScreen({super.key});

  @override
  State<ServersScreen> createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  final Set<String> _unlockedPremiumIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(
        title: Text('Choose location', style: GoogleFonts.cairo(fontSize: 18)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demoServers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final s = demoServers[i];
          final locked = s.isPremium && !_unlockedPremiumIds.contains(s.id);
          return _ServerTile(
            server: s,
            locked: locked,
            onTap: () {
              if (locked) {
                _showUnlockSheet(s);
              } else {
                Navigator.of(context).pop(s);
              }
            },
          );
        },
      ),
    );
  }

  void _showUnlockSheet(VpnServer s) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, color: AppColors.cyanGlow, size: 36),
            const SizedBox(height: 12),
            Text('${s.city} is a Premium server',
                style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              'Watch a short ad to unlock this location for 30 minutes.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  AdService.instance.showRewardedForServerUnlock(onReward: () {
                    setState(() => _unlockedPremiumIds.add(s.id));
                  });
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.cyanGlow,
                  foregroundColor: AppColors.midnight,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Watch ad to unlock'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerTile extends StatelessWidget {
  final VpnServer server;
  final bool locked;
  final VoidCallback onTap;

  const _ServerTile({required this.server, required this.locked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.panelLight,
              child: Text(server.country.substring(0, 1),
                  style: const TextStyle(color: AppColors.textPrimary)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(server.city,
                      style: GoogleFonts.inter(
                          color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  Text(server.country,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (locked)
              const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 18)
            else
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
