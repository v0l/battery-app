# btleplug's droidplug backend (com.nonpolynomial.*) and jni-utils
# (io.github.gedgygedgy.*) are referenced only from Rust via JNI, so R8 sees
# them as unused and strips them from release builds — crashing startup with
# ClassNotFoundException in MainActivity.initBtleplug. Keep them all.
-keep class com.nonpolynomial.** { *; }
-keep class io.github.gedgygedgy.** { *; }
