import 'package:http/http.dart' as http;
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
    final res = await http
        .get(Uri.parse('http://63.185.117.13:8080/client1.conf'))
        .timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch VPN config (${res.statusCode})');
    }
    return res.body;
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
