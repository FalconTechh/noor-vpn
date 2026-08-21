class VpnServer {
  final String id;
  final String country;
  final String city;
  final String flagAsset;
  final String endpointConfigUrl;
  final bool isPremium;
  int pingMs;

  VpnServer({
    required this.id,
    required this.country,
    required this.city,
    required this.flagAsset,
    required this.endpointConfigUrl,
    this.isPremium = false,
    this.pingMs = 0,
  });
}

/// ⚠️ IMPORTANT: All servers below currently route through the SAME single
/// real backend (AWS Frankfurt, Germany) — see lib/services/vpn_service.dart.
/// The country/city labels are cosmetic for now. This means:
/// - The connection genuinely works (real encrypted tunnel) regardless of
///   which one is picked.
/// - The actual exit IP will always geolocate to Germany, no matter which
///   label is selected — so content that checks IP location (e.g.
///   region-locked streaming) will NOT match the picked label.
/// To make labels truthful, set up a real server in each region (repeat
/// README Step 2 on a new VM per region) and give each its own entry in
/// vpn_service.dart's fetchConfig().
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
  ),
  VpnServer(
    id: 'us-1',
    country: 'United States',
    city: 'New York',
    flagAsset: 'assets/flags/us.png',
    endpointConfigUrl: 'https://api.noorvpn.app/config/us-1',
    isPremium: true,
  ),
];
