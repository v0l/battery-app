import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery_app/src/rust/api/battery.dart';

/// Live dashboard for one connected battery. Polls `status()` periodically
/// and gates controls on the device's capabilities.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.device, required this.conn});

  final DiscoveredDevice device;
  final BatteryConn conn;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  BatteryStatus? _status;
  String? _error;
  Timer? _timer;
  bool _busy = false;
  late final Caps _caps = widget.conn.capabilities();

  @override
  void initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _refresh());
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.conn.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (_busy) return;
    try {
      final s = await widget.conn.status();
      if (mounted) {
        setState(() {
          _status = s;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  Future<void> _toggle(String id, bool on) async {
    setState(() => _busy = true);
    try {
      await widget.conn.toggle(id: id, on_: on);
      _busy = false;
      await _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Command failed: $e')));
      }
    } finally {
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _status;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.label),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
        ],
      ),
      body: s == null
          ? Center(
              child: _error != null
                  ? Text(_error!)
                  : const CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_error != null)
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('Last poll failed: $_error'),
                      ),
                    ),
                  _SocCard(status: s),
                  const SizedBox(height: 12),
                  _StatsCard(status: s),
                  if (s.alarms.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _AlarmsCard(alarms: s.alarms),
                  ],
                  if (s.ports.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _PortsCard(
                      ports: s.ports,
                      canToggle: _caps.togglePorts && !_busy,
                      onToggle: _toggle,
                    ),
                  ],
                  if (s.charging != null || s.discharging != null) ...[
                    const SizedBox(height: 12),
                    _MosfetCard(
                      status: s,
                      caps: _caps,
                      busy: _busy,
                      onToggle: _toggle,
                    ),
                  ],
                  if (s.cells.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _CellsCard(status: s),
                  ],
                ],
              ),
            ),
    );
  }
}

class _SocCard extends StatelessWidget {
  const _SocCard({required this.status});
  final BatteryStatus status;

  @override
  Widget build(BuildContext context) {
    final soc = status.soc;
    final charging = (status.current ?? 0) > 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              soc != null ? '${soc.toStringAsFixed(0)}%' : '—',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            if (soc != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(value: soc / 100, minHeight: 8),
              ),
            Text(charging ? 'Charging' : 'Discharging / idle'),
            if (status.timeRemainingH != null)
              Text('~${status.timeRemainingH!.toStringAsFixed(1)} h remaining'),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.status});
  final BatteryStatus status;

  @override
  Widget build(BuildContext context) {
    String fmt(double? v, String unit, [int dp = 1]) =>
        v != null ? '${v.toStringAsFixed(dp)} $unit' : '—';
    final rows = <(String, String)>[
      ('Voltage', fmt(status.voltage, 'V', 2)),
      ('Current', fmt(status.current, 'A', 2)),
      if (status.powerIn != null) ('Power in', fmt(status.powerIn, 'W', 0)),
      if (status.powerOut != null) ('Power out', fmt(status.powerOut, 'W', 0)),
      if (status.temperatureC != null)
        ('Temperature', fmt(status.temperatureC, '°C')),
      if (status.capacityRemainingAh != null)
        (
          'Capacity',
          '${fmt(status.capacityRemainingAh, '', 1)}/ ${fmt(status.capacityFullAh, 'Ah', 1)}'
        ),
      if (status.cycles != null) ('Cycles', '${status.cycles}'),
      if (status.soh != null) ('Health', fmt(status.soh, '%', 0)),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label),
                    Text(value,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AlarmsCard extends StatelessWidget {
  const _AlarmsCard({required this.alarms});
  final List<String> alarms;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Icon(Icons.warning),
              SizedBox(width: 8),
              Text('Alarms', style: TextStyle(fontWeight: FontWeight.bold)),
            ]),
            for (final a in alarms) Text('• $a'),
          ],
        ),
      ),
    );
  }
}

class _PortsCard extends StatelessWidget {
  const _PortsCard({
    required this.ports,
    required this.canToggle,
    required this.onToggle,
  });
  final List<PortInfo> ports;
  final bool canToggle;
  final void Function(String id, bool on) onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const ListTile(
              title: Text('Ports',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          for (final p in ports)
            SwitchListTile(
              title: Text(p.label ?? p.id),
              subtitle:
                  p.watts != null ? Text('${p.watts!.toStringAsFixed(0)} W') : null,
              value: p.on_ ?? false,
              onChanged: canToggle && p.on_ != null
                  ? (v) => onToggle(p.id, v)
                  : null,
            ),
        ],
      ),
    );
  }
}

class _MosfetCard extends StatelessWidget {
  const _MosfetCard({
    required this.status,
    required this.caps,
    required this.busy,
    required this.onToggle,
  });
  final BatteryStatus status;
  final Caps caps;
  final bool busy;
  final void Function(String id, bool on) onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          if (status.charging != null)
            SwitchListTile(
              title: const Text('Charging MOSFET'),
              value: status.charging!,
              onChanged: caps.toggleCharge && !busy
                  ? (v) => onToggle('charging', v)
                  : null,
            ),
          if (status.discharging != null)
            SwitchListTile(
              title: const Text('Discharging MOSFET'),
              value: status.discharging!,
              onChanged: caps.toggleDischarge && !busy
                  ? (v) => onToggle('discharging', v)
                  : null,
            ),
        ],
      ),
    );
  }
}

class _CellsCard extends StatelessWidget {
  const _CellsCard({required this.status});
  final BatteryStatus status;

  @override
  Widget build(BuildContext context) {
    final delta = status.cellDelta;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cells (${status.cells.length})',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (delta != null)
              Text('Δ ${(delta * 1000).toStringAsFixed(0)} mV'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in status.cells)
                  Chip(
                    avatar: c.balancing == true
                        ? const Icon(Icons.sync, size: 16)
                        : null,
                    label: Text(
                      '${c.index + 1}: ${c.voltage?.toStringAsFixed(3) ?? '—'} V',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
