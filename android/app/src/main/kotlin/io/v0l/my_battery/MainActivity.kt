package io.v0l.my_battery

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Ensure the Rust cdylib is loaded, then initialize btleplug's
        // droidplug backend with this classloader's JNIEnv.
        System.loadLibrary("rust_lib_battery_app")
        initBtleplug()
    }

    private external fun initBtleplug()
}
