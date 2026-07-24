import 'dart:async';

// `Switch` is both a Flutter widget and one of our Rust model types; we use the
// model type here (and SwitchListTile for UI), so hide the widget.
import 'package:flutter/material.dart' hide Switch;
import 'package:battery_app/src/rust/api/battery.dart';

/// Mutable, incrementally-updated view of device state, driven by the Rust
/// `StreamEvent`s (a full Snapshot then individual Updates).
class LiveStatus {
  final Map<String, Sensor> sensors = {};
  final Map<String, Switch> switches = {};
  final Map<String, PortInfo> ports = {};
  final Map<int, CellInfo> cells = {};
  final Map<String, Setting> settings = {};
  List<String> alarms = [];

  void applySnapshot(BatteryStatus s) {
    sensors
      ..clear()
      ..addEntries(s.sensors.map((x) => MapEntry(x.id, x)));
    switches
      ..clear()
      ..addEntries(s.switches.map((x) => MapEntry(x.id, x)));
    ports
      ..clear()
      ..addEntries(s.ports.map((x) => MapEntry(x.id, x)));
    cells
      ..clear()
      ..addEntries(s.cells.map((x) => MapEntry(x.index, x)));
    settings
      ..clear()
      ..addEntries(s.settings.map((x) => MapEntry(x.id, x)));
    alarms = List.of(s.alarms);
  }

  void applyUpdate(StatusUpdate u) {
    switch (u) {
      case StatusUpdate_Sensor(:final field0):
        sensors[field0.id] = field0;
      case StatusUpdate_Switch(:final field0):
        switches[field0.id] = field0;
      case StatusUpdate_Port(:final field0):
        ports[field0.id] = field0;
      case StatusUpdate_Cell(:final field0):
        cells[field0.index] = field0;
      case StatusUpdate_Setting(:final field0):
        settings[field0.id] = field0;
      case StatusUpdate_Alarms(:final field0):
        alarms = field0;
    }
  }

  double? reading(String id) => sensors[id]?.value;
}

String unitSymbol(SensorUnit u) => switch (u) {
      SensorUnit.percent => '%',
      SensorUnit.volt => 'V',
      SensorUnit.amp => 'A',
      SensorUnit.watt => 'W',
      SensorUnit.celsius => '°C',
      SensorUnit.ampHour => 'Ah',
      SensorUnit.hour => 'h',
      SensorUnit.second => 's',
      SensorUnit.minute => 'min',
      SensorUnit.count => '',
    };

String prettyId(String id) {
  var s = id.replaceAll(RegExp(r'[_.]'), ' ');
  return s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

String fmtNum(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.device, required this.conn});

  final DiscoveredDevice device;
  final BatteryConn conn;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LiveStatus _live = LiveStatus();
  bool _seeded = false;
  String? _error;
  StreamSubscription<StreamEvent>? _sub;
  bool _busy = false;
  late final Caps _caps = widget.conn.capabilities();

  /// Optimistic overrides for switch/port ids, cleared once the live state
  /// reports the same value.
  final Map<String, bool> _pending = {};

  @override
  void initState() {
    super.initState();
    _sub = widget.conn.watch().listen(
      _onEvent,
      onError: (e) {
        if (mounted) setState(() => _error = '$e');
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    widget.conn.dispose();
    super.dispose();
  }

  void _onEvent(StreamEvent event) {
    if (!mounted) return;
    setState(() {
      switch (event) {
        case StreamEvent_Snapshot(:final field0):
          _live.applySnapshot(field0);
          _seeded = true;
          _error = null;
        case StreamEvent_Update(:final field0):
          _live.applyUpdate(field0);
          _error = null;
        case StreamEvent_Error(:final field0):
          _error = field0;
      }
      // Drop optimistic overrides the device has caught up to.
      _pending.removeWhere((id, want) => _liveBool(id) == want);
    });
  }

  /// Current device-reported bool for a switch or port id.
  bool? _liveBool(String id) =>
      _live.switches[id]?.on_ ?? _live.ports[id]?.on_;

  bool? _effective(String id) => _pending[id] ?? _liveBool(id);

  Future<void> _toggle(String id, bool on) async {
    setState(() {
      _pending[id] = on;
      _busy = true;
    });
    try {
      await widget.conn.toggle(id: id, on_: on);
    } catch (e) {
      if (mounted) {
        setState(() => _pending.remove(id));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Command failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _set(String id, String value) async {
    setState(() => _busy = true);
    try {
      await widget.conn.set_(id: id, value: value);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Set failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Whether this switch is toggleable *at all* (capability-based). While a
  /// command is in flight the tile stays a switch — merely disabled — so the
  /// row doesn't visually flip to the read-only badge on every tap.
  bool _canToggleSwitch(String id) {
    return switch (id) {
      'charging' => _caps.toggleCharge,
      'discharging' => _caps.toggleDischarge,
      'balancer' => _caps.toggleBalancer,
      _ => _caps.writeSettings,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_seeded) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.device.label)),
        body: Center(
          child: _error != null
              ? Text(_error!)
              : const CircularProgressIndicator(),
        ),
      );
    }

    // Order sensors: soc first is handled by the gauge; the rest go in a card.
    final otherSensors =
        _live.sensors.values.where((s) => s.id != 'soc').toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.device.label)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text('Last event error: $_error'),
              ),
            ),
          _SocCard(live: _live),
          if (otherSensors.isNotEmpty) ...[
            const SizedBox(height: 12),
            _ReadingsCard(sensors: otherSensors),
          ],
          const SizedBox(height: 12),
          _AlarmsCard(alarms: _live.alarms),
          if (_live.ports.isNotEmpty) ...[
            const SizedBox(height: 12),
            _PortsCard(
              ports: _live.ports.values.toList(),
              busy: _busy,
              effective: _effective,
              onToggle: _toggle,
            ),
          ],
          if (_live.switches.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SwitchesCard(
              switches: _live.switches.values.toList(),
              busy: _busy,
              effective: _effective,
              canToggle: _canToggleSwitch,
              onToggle: _toggle,
            ),
          ],
          if (_live.settings.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SettingsCard(
              settings: _live.settings.values.toList(),
              busy: _busy,
              onToggle: _toggle,
              onSet: _set,
            ),
          ],
          if (_live.cells.isNotEmpty) ...[
            const SizedBox(height: 12),
            _CellsCard(cells: _live.cells.values.toList()),
          ],
        ],
      ),
    );
  }
}

class _SocCard extends StatelessWidget {
  const _SocCard({required this.live});
  final LiveStatus live;

  @override
  Widget build(BuildContext context) {
    final soc = live.reading('soc');
    final current = live.reading('current') ?? 0;
    final timeH = live.reading('time_remaining_h');
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
            Text(current > 0
                ? 'Charging'
                : current < 0
                    ? 'Discharging'
                    : 'Idle'),
            if (timeH != null) Text('~${timeH.toStringAsFixed(1)} h remaining'),
          ],
        ),
      ),
    );
  }
}

class _ReadingsCard extends StatelessWidget {
  const _ReadingsCard({required this.sensors});
  final List<Sensor> sensors;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final s in sensors)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s.label ?? prettyId(s.id)),
                    Text(
                      '${fmtNum(s.value)}${unitSymbol(s.unit).isEmpty ? '' : ' ${unitSymbol(s.unit)}'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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
    final active = alarms.isNotEmpty;
    return Card(
      color: active ? Theme.of(context).colorScheme.errorContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(active ? Icons.warning : Icons.verified_outlined),
              const SizedBox(width: 8),
              const Text('Alarms', style: TextStyle(fontWeight: FontWeight.bold)),
            ]),
            if (!active)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('No active alarms',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ),
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
    required this.busy,
    required this.effective,
    required this.onToggle,
  });
  final List<PortInfo> ports;
  final bool busy;
  final bool? Function(String id) effective;
  final void Function(String id, bool on) onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const ListTile(
              title:
                  Text('Ports', style: TextStyle(fontWeight: FontWeight.bold))),
          for (final p in ports)
            if (p.settable && p.on_ != null)
              SwitchListTile(
                title: Text(p.label ?? prettyId(p.id)),
                subtitle: p.watts != null
                    ? Text('${p.watts!.toStringAsFixed(0)} W')
                    : null,
                value: effective(p.id) ?? false,
                onChanged: busy ? null : (v) => onToggle(p.id, v),
              )
            else
              ListTile(
                title: Text(p.label ?? prettyId(p.id)),
                subtitle: p.watts != null
                    ? Text('${p.watts!.toStringAsFixed(0)} W')
                    : null,
                trailing: _OnOffBadge(on: effective(p.id)),
              ),
        ],
      ),
    );
  }
}

/// Read-only ON/OFF indicator for ports/switches that can't be toggled.
class _OnOffBadge extends StatelessWidget {
  const _OnOffBadge({required this.on});
  final bool? on;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, fg, bg) = switch (on) {
      true => ('ON', scheme.onPrimary, scheme.primary),
      false => ('OFF', scheme.onSurfaceVariant, scheme.surfaceContainerHighest),
      null => ('—', scheme.onSurfaceVariant, scheme.surfaceContainerHighest),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class _SwitchesCard extends StatelessWidget {
  const _SwitchesCard({
    required this.switches,
    required this.busy,
    required this.effective,
    required this.canToggle,
    required this.onToggle,
  });
  final List<Switch> switches;
  final bool busy;
  final bool? Function(String id) effective;
  final bool Function(String id) canToggle;
  final void Function(String id, bool on) onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (final w in switches)
            if (canToggle(w.id))
              SwitchListTile(
                title: Text(w.label ?? prettyId(w.id)),
                value: effective(w.id) ?? w.on_,
                onChanged: busy ? null : (v) => onToggle(w.id, v),
              )
            else
              ListTile(
                title: Text(w.label ?? prettyId(w.id)),
                trailing: _OnOffBadge(on: effective(w.id) ?? w.on_),
              ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.settings,
    required this.busy,
    required this.onToggle,
    required this.onSet,
  });
  final List<Setting> settings;
  final bool busy;
  final void Function(String id, bool on) onToggle;
  final void Function(String id, String value) onSet;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const ListTile(
              title: Text('Settings',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          for (final s in settings) _row(context, s),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, Setting s) {
    final name = s.label ?? prettyId(s.id);
    switch (s.value) {
      case SettingValue_Bool(:final field0):
        return SwitchListTile(
          title: Text(name),
          value: field0,
          onChanged: s.writable && !busy ? (v) => onToggle(s.id, v) : null,
        );
      case SettingValue_Number(:final field0):
        final unit = switch (s.kind) {
          SettingKind_Number(:final unit) => unit,
          _ => '',
        };
        return ListTile(
          title: Text(name),
          trailing: Text('${fmtNum(field0)}${unit.isEmpty ? '' : ' $unit'}'),
          onTap: s.writable && !busy
              ? () => _editNumber(context, s, field0)
              : null,
        );
      case SettingValue_Text(:final field0):
        return ListTile(
          title: Text(name),
          trailing: Text(field0),
          onTap: s.writable && !busy
              ? () => _editText(context, s, field0)
              : null,
        );
    }
  }

  Future<void> _editNumber(
      BuildContext context, Setting s, double current) async {
    final controller = TextEditingController(text: fmtNum(current));
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.label ?? prettyId(s.id)),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Set')),
        ],
      ),
    );
    if (result != null) onSet(s.id, result);
  }

  Future<void> _editText(BuildContext context, Setting s, String current) async {
    final controller = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.label ?? prettyId(s.id)),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Set')),
        ],
      ),
    );
    if (result != null) onSet(s.id, result);
  }
}

class _CellsCard extends StatelessWidget {
  const _CellsCard({required this.cells});
  final List<CellInfo> cells;

  @override
  Widget build(BuildContext context) {
    final volts = cells.map((c) => c.voltage).whereType<double>().toList();
    final delta = volts.isEmpty
        ? null
        : (volts.reduce((a, b) => a > b ? a : b) -
            volts.reduce((a, b) => a < b ? a : b));
    final sorted = [...cells]..sort((a, b) => a.index.compareTo(b.index));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cells (${cells.length})',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (delta != null) Text('Δ ${(delta * 1000).toStringAsFixed(0)} mV'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in sorted)
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
