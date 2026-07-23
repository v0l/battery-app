import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
  DiscoveredDevice? _connecting;
  String? _error;

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
      _error = null;
    });
    try {
      if (!await _ensurePermissions()) {
        setState(() {
          _error = 'Bluetooth permission denied. Enable it in Settings.';
          _scanning = false;
        });
        return;
      }
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

  /// Android 12+ requires runtime BLUETOOTH_SCAN/CONNECT; older versions use
  /// location. Desktop/iOS need no runtime request here.
  Future<bool> _ensurePermissions() async {
    if (!Platform.isAndroid) return true;
    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
    // Scan + connect are the ones that matter on 12+; location covers <= 11.
    return (statuses[Permission.bluetoothScan]?.isGranted ?? false) &&
            (statuses[Permission.bluetoothConnect]?.isGranted ?? false) ||
        (statuses[Permission.locationWhenInUse]?.isGranted ?? false);
  }

  Future<void> _connect(DiscoveredDevice d) async {
    setState(() => _connecting = d);
    try {
      final conn = await connect(query: d.id, bleSecs: BigInt.from(6));
      if (!mounted) return;
      setState(() => _connecting = null);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DashboardScreen(device: d, conn: conn),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _connecting = null);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Connect failed: $e')));
      }
    }
  }

  IconData _classIcon(DeviceClass c) => switch (c) {
        DeviceClass.bms => Icons.battery_std,
        DeviceClass.powerStation => Icons.power,
        DeviceClass.monitor => Icons.monitor_heart,
      };

  @override
  Widget build(BuildContext context) {
    final connecting = _connecting;
    return Scaffold(
      appBar: AppBar(title: const Text('Batteries')),
      body: Stack(
        children: [
          Column(
            children: [
              if (_scanning) const LinearProgressIndicator(),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_error!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
                ),
              Expanded(
                child: _devices.isEmpty && !_scanning
                    ? const Center(
                        child: Text('No devices. Tap scan to discover.'))
                    : ListView.builder(
                        itemCount: _devices.length,
                        itemBuilder: (context, i) {
                          final d = _devices[i];
                          final isConnecting = connecting?.id == d.id;
                          return ListTile(
                            leading: Icon(_classIcon(d.class_)),
                            title: Text(d.label),
                            subtitle: Text('${d.backend} · ${d.id}'),
                            trailing: isConnecting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Icons.chevron_right),
                            onTap: connecting != null
                                ? null
                                : () => _connect(d),
                          );
                        },
                      ),
              ),
            ],
          ),
          // Full-screen blocking overlay while connecting.
          if (connecting != null) _ConnectingOverlay(label: connecting.label),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanning || _connecting != null ? null : _scan,
        icon: const Icon(Icons.radar),
        label: Text(_scanning ? 'Scanning…' : 'Scan'),
      ),
    );
  }
}

/// A modal barrier + spinner shown while a connection is being established
/// (BLE connect + priming the first full status can take a few seconds).
class _ConnectingOverlay extends StatelessWidget {
  const _ConnectingOverlay({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black54,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Connecting to $label…'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
