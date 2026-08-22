import 'package:wireguard_flutter/wireguard_flutter.dart';
import '../models/server_model.dart';

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
    const clientPrivateKey = 'EOKnmyhdR4t3NYP19aQ3n6YEqvuaPyks7SSK/d0r34=';
    const serverPublicKey = 'RJpsKa7rAGyyZXAiZXW6mu3NsxnKgjzOXXetrPoKzjE=';
    const serverEndpoint = '63.185.117.13:51820';

    return '[Interface]\n'
        'PrivateKey = $clientPrivateKey\n'
        'Address = 10.0.0.2/24\n'
        'DNS = 1.1.1.1\n'
        '\n'
        '[Peer]\n'
        'PublicKey = $serverPublicKey\n'
        'Endpoint = $serverEndpoint\n'
        'AllowedIPs = 0.0.0.0/0\n'
        'PersistentKeepalive = 25\n';
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
