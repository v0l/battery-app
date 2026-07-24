package io.v0l.my_battery

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val bluetoothChannel = "io.v0l.my_battery/bluetooth"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Ensure the Rust cdylib is loaded, then initialize btleplug's
        // droidplug backend with this classloader's JNIEnv.
        System.loadLibrary("rust_lib_battery_app")
        initBtleplug()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, bluetoothChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Whether the Bluetooth radio is currently on.
                    "isEnabled" -> result.success(adapter()?.isEnabled == true)
                    // Show the system dialog to turn Bluetooth on (in-app).
                    "requestEnable" -> {
                        val adapter = adapter()
                        if (adapter == null) {
                            result.success(false) // no BT hardware
                        } else if (adapter.isEnabled) {
                            result.success(true)
                        } else {
                            startActivity(Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE))
                            result.success(true)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun adapter(): BluetoothAdapter? =
        (getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager)?.adapter

    private external fun initBtleplug()
}
