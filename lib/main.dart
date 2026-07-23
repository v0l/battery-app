import 'package:flutter/material.dart';
import 'package:battery_app/src/rust/frb_generated.dart';
import 'package:battery_app/screens/discovery_screen.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const BatteryApp());
}

class BatteryApp extends StatelessWidget {
  const BatteryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery Control',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const DiscoveryScreen(),
    );
  }
}
