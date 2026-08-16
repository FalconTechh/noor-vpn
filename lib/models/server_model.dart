class VpnServer {
  final String id;
  final String country;
  final String city;
  final String flagAsset; // e.g. assets/flags/ae.png
  final String endpointConfigUrl; // your backend endpoint that returns the wg config
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

/// Starter server list — Gulf-first since that's the target market.
/// Replace endpointConfigUrl with YOUR real backend once servers are live
/// (see README Step 2 & 3).
final List<VpnServer> demoServers = [
  VpnServer(
    id: 'ae-1',
    country: 'United Arab Emirates',
    city: 'Dubai',
    flagAsset: 'assets/flags/ae.png',
    endpointConfigUrl: 'https://api.noorvpn.app/config/ae-1',
  ),
  VpnServer(
    id: 'sa-1',
    country: 'Saudi Arabia',
    city: 'Riyadh',
    flagAsset: 'assets/flags/sa.png',
    endpointConfigUrl: 'https://api.noorvpn.app/config/sa-1',
  ),
  VpnServer(
    id: 'qa-1',
    country: 'Qatar',
    city: 'Doha',
    flagAsset: 'assets/flags/qa.png',
    endpointConfigUrl: 'https://api.noorvpn.app/config/qa-1',
  ),
  VpnServer(
    id: 'de-1',
    country: 'Germany',
    city: 'Frankfurt',
    flagAsset: 'assets/flags/de.png',
    endpointConfigUrl: 'https://api.noorvpn.app/config/de-1',
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
