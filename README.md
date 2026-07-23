# battery_app

Cross-platform GUI (macOS / Linux / Windows / Android / iOS) for
[battery-control](https://github.com/v0l/battery-control) — discover, monitor
and control batteries, BMSes and power stations from one app.

Built with Flutter + [flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge);
the Rust library is the core and does all transport work (BLE, serial, CAN).

## Layout

- `rust/` — FRB bridge crate wrapping `battery_control` (expects the
  `battery-control` checkout as a sibling directory: `../battery-control`)
- `lib/` — Flutter UI (discovery + live dashboard)
- `lib/src/rust/` — generated bindings (`flutter_rust_bridge_codegen generate`)

Per-platform backend features (see `rust/Cargo.toml`):

| Target | `battery_control` features |
|--------|---------------------------|
| Desktop | `full` (BLE + serial backends) |
| Android / iOS | `anker` (BLE only) |

Controls in the UI are capability-gated: switches only appear/enable when the
connected device advertises the matching `Capabilities` flag.

## Run

```sh
flutter run -d macos   # or linux / windows / an attached device
```

After editing `rust/src/api/`, regenerate bindings:

```sh
flutter_rust_bridge_codegen generate
```
