import 'dart:io';

import 'package:flutter/services.dart';

/// Thin wrapper over the Android `MainActivity` Bluetooth method channel.
/// On non-Android platforms the radio is assumed available.
class Bluetooth {
  static const _channel = MethodChannel('io.v0l.my_battery/bluetooth');

  /// Whether the Bluetooth radio is currently on.
  static Future<bool> isEnabled() async {
    if (!Platform.isAndroid) return true;
    try {
      return await _channel.invokeMethod<bool>('isEnabled') ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Ask the system to turn Bluetooth on (shows the in-app system dialog).
  /// Returns false if the device has no Bluetooth hardware.
  static Future<bool> requestEnable() async {
    if (!Platform.isAndroid) return true;
    try {
      return await _channel.invokeMethod<bool>('requestEnable') ?? false;
    } on PlatformException {
      return false;
    }
  }
}
