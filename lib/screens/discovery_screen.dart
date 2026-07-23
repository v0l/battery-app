import 'package:flutter/material.dart';
import 'package:battery_app/src/rust/api/battery.dart';
import 'package:battery_app/screens/dashboard_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  List<DiscoveredDevice> _devices = [];
  bool _scanning = false;
  bool _connecting = false;
  String? _error;

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
      _error = null;
    });
    try {
      final devices = await discoverDevices(
        bleSecs: BigInt.from(6),
        probeSerial: hasSerialSupport(),
      );
      if (mounted) setState(() => _devices = devices);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  Future<void> _connect(DiscoveredDevice d) async {
    setState(() => _connecting = true);
    try {
      final conn = await connect(query: d.id, bleSecs: BigInt.from(6));
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DashboardScreen(device: d, conn: conn),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Connect failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  IconData _classIcon(DeviceClass c) => switch (c) {
        DeviceClass.bms => Icons.battery_std,
        DeviceClass.powerStation => Icons.power,
        DeviceClass.monitor => Icons.monitor_heart,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Batteries')),
      body: Column(
        children: [
          if (_scanning) const LinearProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(_error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          Expanded(
            child: _devices.isEmpty && !_scanning
                ? const Center(child: Text('No devices. Tap scan to discover.'))
                : ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, i) {
                      final d = _devices[i];
                      return ListTile(
                        leading: Icon(_classIcon(d.class_)),
                        title: Text(d.label),
                        subtitle: Text('${d.backend} · ${d.id}'),
                        trailing: _connecting
                            ? null
                            : const Icon(Icons.chevron_right),
                        onTap: _connecting ? null : () => _connect(d),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanning ? null : _scan,
        icon: const Icon(Icons.radar),
        label: Text(_scanning ? 'Scanning…' : 'Scan'),
      ),
    );
  }
}
