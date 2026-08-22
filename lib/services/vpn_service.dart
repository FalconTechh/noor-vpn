import 'package:wireguard_flutter/wireguard_flutter.dart';
import '../models/server_model.dart';

enum VpnStatus { disconnected, connecting, connected, disconnecting, error }

/// Wraps the wireguard_flutter plugin to run a REAL encrypted VPN tunnel.
///
/// ⚠️ Current setup: all users share ONE client key pair (the one we
/// tested manually on the server). This is fine for early testing/launch
/// with a small number of users, but does not scale securely — every
/// install shares the same tunnel identity. Before scaling to many real
/// users, replace `_demoConfig` below with a real call to your own
/// backend (README Step 3) that issues a unique key pair per device.
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

  /// Returns a wg-quick style config. Currently returns the same demo
  /// config regardless of which server was picked — only the Dubai
  /// (Oracle/AWS) server actually has a live backend right now. Wiring
  /// more regions means repeating the server setup (README Step 2) on a
  /// new VM per region and updating the endpoint below.
  Future<String> fetchConfig(VpnServer server) async {
    const clientPrivateKey = '4Cnf3SgKUCi2bZSW2mDOQPYtUHqr7Fd4CPj+vT9u62S=';
    const serverPublicKey = 'AJpsKm7rAGyyEXAiEXW6ms3NexnKgizOXXetrPoKSjE=';
    const serverEndpoint = '63.185.117.13:51820';

    return '''
[Interface]
PrivateKey = $clientPrivateKey
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = $serverPublicKey
Endpoint = $serverEndpoint
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
''';
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

}
