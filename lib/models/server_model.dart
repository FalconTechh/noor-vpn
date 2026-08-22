class VpnServer {
  final String id;
  final String country;
  final String city;
  final String flagAsset;
  final String endpointConfigUrl;
  final bool isPremium;
  final bool isVirtual;
  int pingMs;

  VpnServer({
    required this.id,
    required this.country,
    required this.city,
    required this.flagAsset,
    required this.endpointConfigUrl,
    this.isPremium = false,
    this.isVirtual = false,
    this.pingMs = 0,
  });
}

/// ⚠️ IMPORTANT: All servers below currently route through the SAME single
/// real backend (AWS Frankfurt, Germany) — see lib/services/vpn_service.dart.
/// Only ONE physical server exists right now.
///
/// `isVirtual: true` marks locations where the exit IP does NOT match the
/// label (a common industry practice, but must be disclosed — see the
/// "Virtual location" badge shown in servers_screen.dart). Undisclosed
/// mismatched labels risk Google Play's "Deceptive Behavior" policy.
/// To make a location truthful (non-virtual), set up a real server
/// physically in that region (repeat README Step 2) and give it its own
/// entry in vpn_service.dart's fetchConfig().
final List<VpnServer> demoServers = [
  VpnServer(
    id: 'eu-1',
    country: 'Germany',
    city: 'Frankfurt',
    flagAsset: 'assets/flags/de.png',
    endpointConfigUrl: 'https://api.noorvpn.app/config/eu-1',
  ),
  VpnServer(
    id: 'as-1',
    country: 'Singapore',
    city: 'Singapore',
    flagAsset: 'assets/flags/sg.png',
    endpointConfigUrl: 'https://api.noorvpn.app/config/as-1',
    isPremium: true,
    isVirtual: true,
  ),
  VpnServer(
    id: 'as-2',
    country: 'Japan',
    city: 'Tokyo',
    flagAsset: 'assets/flags/jp.png',
    endpointConfigUrl: 'https://api.noorvpn.app/config/as-2',
    isPremium: true,
    isVirtual: true,
  ),
  VpnServer(
    id: 'as-3',
    country: 'India',
    city: 'Mumbai',
    flagAsset: 'assets/flags/in.png',
    endpointConfigUrl: 'https://api.noorvpn.app/config/as-3',
    isPremium: true,
    isVirtual: true,
  ),
  VpnServer(
    id: 'us-1',
    country: 'United States',
    city: 'New York',
    flagAsset: 'assets/flags/us.png',
    endpointConfigUrl: 'https://api.noorvpn.app/config/us-1',
    isPremium: true,
    isVirtual: true,
  ),
];
