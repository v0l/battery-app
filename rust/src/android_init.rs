//! Android-only: initialize btleplug's droidplug backend and keep worker
//! threads attached to the JVM.
//!
//! btleplug on Android is a hybrid Rust/Java library. Two things are required:
//!
//! 1. **One-time init** with a `JNIEnv` from the app classloader — done in
//!    `initBtleplug`, called from `MainActivity.onCreate`. This registers native
//!    methods and caches global refs to the bundled `com.nonpolynomial.*` /
//!    `io.github.gedgygedgy.*` classes.
//! 2. **Thread attachment** for every thread that touches BLE. droidplug's
//!    `global_jvm().get_env()` fails on threads that aren't attached to the JVM,
//!    and flutter_rust_bridge runs async calls on its own worker pool. So before
//!    any discovery/connection we attach the current worker thread (see
//!    [`ensure_thread_attached`]).

use jni::objects::JClass;
use jni::{JNIEnv, JavaVM};
use std::sync::OnceLock;

static VM: OnceLock<JavaVM> = OnceLock::new();

/// Called from `com.example.battery_app.MainActivity.initBtleplug()`.
#[no_mangle]
pub extern "system" fn Java_com_example_battery_1app_MainActivity_initBtleplug(
    env: JNIEnv,
    _class: JClass,
) {
    if let Ok(vm) = env.get_java_vm() {
        let _ = VM.set(vm);
    }
    match btleplug::platform::init(&env) {
        Err(e) => eprintln!("btleplug init failed: {e}"),
        Ok(()) => eprintln!("btleplug droidplug initialized"),
    }
}

/// Attach the current (FRB worker) thread to the JVM so droidplug's
/// `get_env()` succeeds. Permanent attachment is idempotent per thread.
pub fn ensure_thread_attached() {
    if let Some(vm) = VM.get() {
        if let Err(e) = vm.attach_current_thread_permanently() {
            eprintln!("JVM attach failed: {e}");
        }
    }
}
