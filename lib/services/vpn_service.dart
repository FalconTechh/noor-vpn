import 'package:wireguard_flutter/wireguard_flutter.dart';
import '../models/server_model.dart';

enum VpnStatus { disconnected, connecting, connected, disconnecting, error }

/// Wraps the wireguard_flutter plugin.
///
/// HOW REAL CONNECTION WORKS:
/// 1. Your backend server (see README Step 2) generates a WireGuard
///    config (private/public keys + server endpoint) per user/device.
/// 2. `fetchConfig()` below calls YOUR api and gets that config text.
/// 3. The plugin starts a real encrypted tunnel using Android's
///    VpnService API (this is what makes it a REAL vpn, not a fake one).
///
/// You must not ship this pointing at fake/non-existent servers — Play
/// Store will reject (or later suspend) apps that claim VPN functionality
/// without actually tunneling traffic.
class VpnService {
  VpnService._();
  static final VpnService instance = VpnService._();

  final _wireguard = WireGuardFlutter.instance;
  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    await _wireguard.initialize(interfaceName: 'noor_vpn');
    _initialized = true;
  }

  Future<String> fetchConfig(VpnServer server) async {
    // TODO: replace with a real HTTP call to your backend, e.g.:
    // final res = await http.get(Uri.parse(server.endpointConfigUrl));
    // return res.body;
    throw UnimplementedError(
      'Connect fetchConfig() to your backend endpoint before going live. '
      'See README Step 2 (server) and Step 3 (issuing per-user configs).',
    );
  }

  Future<void> connect(VpnServer server) async {
    await _ensureInit();
    final config = await fetchConfig(server);
    await _wireguard.startVpn(
      serverAddress: server.city,
      wgQuickConfig: config,
      providerBundleIdentifier: 'app.noorvpn.android',
    );
  }

  Future<void> disconnect() async {
    await _wireguard.stopVpn();
  }

  Stream<VpnState> get stateStream => _wireguard.vpnStageSnapshot;
}
