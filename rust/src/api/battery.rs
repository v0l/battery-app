//! FRB bridge over `battery_control`: DTO mirrors of the normalized data
//! model, discovery via a process-global cache, and an opaque connection
//! handle wrapping `Box<dyn Battery>`.

use anyhow::{anyhow, Result};
use battery_control as bc;
use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use std::sync::Mutex as StdMutex;
use std::time::Duration;

// ---------------------------------------------------------------------------
// DTOs (translated to Dart classes)
// ---------------------------------------------------------------------------

pub struct DeviceInfo {
    pub backend: String,
    pub model: Option<String>,
    pub serial: Option<String>,
    pub firmware: Option<String>,
}

impl From<&bc::DeviceInfo> for DeviceInfo {
    fn from(i: &bc::DeviceInfo) -> Self {
        Self {
            backend: i.backend.clone(),
            model: i.model.clone(),
            serial: i.serial.clone(),
            firmware: i.firmware.clone(),
        }
    }
}

/// Flattened capability flags (Dart-friendly booleans).
pub struct Caps {
    pub read_basic: bool,
    pub read_cells: bool,
    pub read_ports: bool,
    pub read_temperature: bool,
    pub read_limits: bool,
    pub read_alarms: bool,
    pub toggle_charge: bool,
    pub toggle_discharge: bool,
    pub toggle_balancer: bool,
    pub set_charge_limit: bool,
    pub write_settings: bool,
    pub requires_auth: bool,
    pub controllable: bool,
}

impl From<bc::Capabilities> for Caps {
    fn from(c: bc::Capabilities) -> Self {
        use bc::Capabilities as C;
        Self {
            read_basic: c.contains(C::READ_BASIC),
            read_cells: c.contains(C::READ_CELLS),
            read_ports: c.contains(C::READ_PORTS),
            read_temperature: c.contains(C::READ_TEMPERATURE),
            read_limits: c.contains(C::READ_LIMITS),
            read_alarms: c.contains(C::READ_ALARMS),
            toggle_charge: c.contains(C::TOGGLE_CHARGE),
            toggle_discharge: c.contains(C::TOGGLE_DISCHARGE),
            toggle_balancer: c.contains(C::TOGGLE_BALANCER),
            set_charge_limit: c.contains(C::SET_CHARGE_LIMIT),
            write_settings: c.contains(C::WRITE_SETTINGS),
            requires_auth: c.contains(C::REQUIRES_AUTH),
            controllable: c.is_controllable(),
        }
    }
}

pub enum DeviceClass {
    Bms,
    PowerStation,
    Monitor,
}

impl From<bc::DeviceClass> for DeviceClass {
    fn from(c: bc::DeviceClass) -> Self {
        match c {
            bc::DeviceClass::Bms => DeviceClass::Bms,
            bc::DeviceClass::PowerStation => DeviceClass::PowerStation,
            bc::DeviceClass::Monitor => DeviceClass::Monitor,
        }
    }
}

pub struct DiscoveredDevice {
    pub id: String,
    pub label: String,
    pub backend: String,
    pub class: DeviceClass,
}

#[derive(Clone)]
pub struct CellInfo {
    pub index: u8,
    pub voltage: Option<f32>,
    pub resistance: Option<f32>,
    pub balancing: Option<bool>,
}

impl From<&bc::CellInfo> for CellInfo {
    fn from(c: &bc::CellInfo) -> Self {
        Self { index: c.index, voltage: c.voltage, resistance: c.resistance, balancing: c.balancing }
    }
}

#[derive(Clone)]
pub enum PortDirection {
    In,
    Out,
    Bidir,
}

#[derive(Clone)]
pub struct PortInfo {
    pub id: String,
    pub label: Option<String>,
    pub direction: Option<PortDirection>,
    pub on: Option<bool>,
    pub watts: Option<f32>,
    /// Whether this specific port accepts on/off control.
    pub settable: bool,
}

impl From<&bc::PortInfo> for PortInfo {
    fn from(p: &bc::PortInfo) -> Self {
        Self {
            id: p.id.clone(),
            label: p.label.clone(),
            direction: p.direction.map(|d| match d {
                bc::PortDirection::In => PortDirection::In,
                bc::PortDirection::Out => PortDirection::Out,
                bc::PortDirection::Bidir => PortDirection::Bidir,
            }),
            on: p.on,
            watts: p.watts,
            settable: p.settable,
        }
    }
}

/// Physical unit of a [`Sensor`]/numeric setting.
#[derive(Clone)]
pub enum SensorUnit {
    Percent,
    Volt,
    Amp,
    Watt,
    Celsius,
    AmpHour,
    Hour,
    Second,
    Minute,
    Count,
}

impl From<bc::Unit> for SensorUnit {
    fn from(u: bc::Unit) -> Self {
        match u {
            bc::Unit::Percent => SensorUnit::Percent,
            bc::Unit::Volt => SensorUnit::Volt,
            bc::Unit::Amp => SensorUnit::Amp,
            bc::Unit::Watt => SensorUnit::Watt,
            bc::Unit::Celsius => SensorUnit::Celsius,
            bc::Unit::AmpHour => SensorUnit::AmpHour,
            bc::Unit::Hour => SensorUnit::Hour,
            bc::Unit::Second => SensorUnit::Second,
            bc::Unit::Minute => SensorUnit::Minute,
            bc::Unit::Count => SensorUnit::Count,
        }
    }
}

/// A read-only scalar reading (SOC, voltage, a temperature probe, ...).
#[derive(Clone)]
pub struct Sensor {
    pub id: String,
    pub label: Option<String>,
    pub value: f64,
    pub unit: SensorUnit,
}

impl From<&bc::Sensor> for Sensor {
    fn from(s: &bc::Sensor) -> Self {
        Self { id: s.id.clone(), label: s.label.clone(), value: s.value, unit: s.unit.into() }
    }
}

/// A writable boolean (charge/discharge MOSFET, heater, ...).
#[derive(Clone)]
pub struct Switch {
    pub id: String,
    pub label: Option<String>,
    pub on: bool,
}

impl From<&bc::Switch> for Switch {
    fn from(w: &bc::Switch) -> Self {
        Self { id: w.id.clone(), label: w.label.clone(), on: w.on }
    }
}

/// Current value of a [`Setting`].
#[derive(Clone)]
pub enum SettingValue {
    Bool(bool),
    Number(f64),
    Text(String),
}

impl From<&bc::SettingValue> for SettingValue {
    fn from(v: &bc::SettingValue) -> Self {
        match v {
            bc::SettingValue::Bool(b) => SettingValue::Bool(*b),
            bc::SettingValue::Number(n) => SettingValue::Number(*n),
            bc::SettingValue::Text(t) => SettingValue::Text(t.clone()),
        }
    }
}

/// Type/constraints of a [`Setting`], for UI rendering.
#[derive(Clone)]
pub enum SettingKind {
    Bool,
    /// `unit` is a display symbol (e.g. `"V"`, `"%"`), empty for none.
    Number { min: Option<f64>, max: Option<f64>, step: Option<f64>, unit: String },
    Enum { options: Vec<String> },
    Text,
}

impl From<&bc::SettingKind> for SettingKind {
    fn from(k: &bc::SettingKind) -> Self {
        match k {
            bc::SettingKind::Bool => SettingKind::Bool,
            bc::SettingKind::Number { min, max, step, unit } => SettingKind::Number {
                min: *min,
                max: *max,
                step: *step,
                unit: unit.map(|u| u.symbol().to_string()).unwrap_or_default(),
            },
            bc::SettingKind::Enum { options } => SettingKind::Enum { options: options.clone() },
            bc::SettingKind::Text => SettingKind::Text,
        }
    }
}

/// A readable/writable configuration value (BMS thresholds, charge limits, ...).
#[derive(Clone)]
pub struct Setting {
    pub id: String,
    pub label: Option<String>,
    pub value: SettingValue,
    pub kind: SettingKind,
    pub writable: bool,
}

impl From<&bc::Setting> for Setting {
    fn from(s: &bc::Setting) -> Self {
        Self {
            id: s.id.clone(),
            label: s.label.clone(),
            value: (&s.value).into(),
            kind: (&s.kind).into(),
            writable: s.writable,
        }
    }
}

/// A snapshot of device state: free-form, id-addressed collections.
#[derive(Clone)]
pub struct BatteryStatus {
    pub sensors: Vec<Sensor>,
    pub switches: Vec<Switch>,
    pub ports: Vec<PortInfo>,
    pub cells: Vec<CellInfo>,
    pub settings: Vec<Setting>,
    pub alarms: Vec<String>,
}

impl From<bc::BatteryStatus> for BatteryStatus {
    fn from(s: bc::BatteryStatus) -> Self {
        Self {
            sensors: s.sensors.iter().map(Into::into).collect(),
            switches: s.switches.iter().map(Into::into).collect(),
            ports: s.ports.iter().map(Into::into).collect(),
            cells: s.cells.iter().map(Into::into).collect(),
            settings: s.settings.iter().map(Into::into).collect(),
            alarms: s.alarms,
        }
    }
}

// ---------------------------------------------------------------------------
// Discovery
// ---------------------------------------------------------------------------

/// Last discovery results, kept so `connect` can reuse the private locators.
static DISCOVERED: StdMutex<Vec<bc::Discovered>> = StdMutex::new(Vec::new());

/// Scan all enabled transports. `probe_serial` is ignored on platforms
/// without serial backends.
pub async fn discover_devices(ble_secs: u64, probe_serial: bool) -> Result<Vec<DiscoveredDevice>> {
    #[cfg(target_os = "android")]
    crate::android_init::ensure_thread_attached();
    let opts = bc::DiscoverOptions {
        ble_secs,
        probe_serial,
        ..Default::default()
    };
    let found = bc::discover(&opts).await.map_err(|e| anyhow!("{e}"))?;
    let out = found
        .iter()
        .map(|d| DiscoveredDevice {
            id: d.id.clone(),
            label: d.label.clone(),
            backend: d.backend.to_string(),
            class: d.class.into(),
        })
        .collect();
    *DISCOVERED.lock().unwrap() = found;
    Ok(out)
}

// ---------------------------------------------------------------------------
// Connection handle
// ---------------------------------------------------------------------------

/// The result of an authentication/binding step, mirrored for Dart.
pub enum AuthOutcome {
    /// Authenticated and ready.
    Authed,
    /// A physical confirmation is needed on the device (e.g. press & hold the
    /// power button), then call `authenticate` again.
    PendingApproval { message: String },
    /// A PIN/code is required; call `authenticate` again with it.
    PinCode { message: String },
}

impl From<bc::AuthState> for AuthOutcome {
    fn from(s: bc::AuthState) -> Self {
        match s {
            bc::AuthState::Authed => AuthOutcome::Authed,
            bc::AuthState::PendingApproval { message } => AuthOutcome::PendingApproval { message },
            bc::AuthState::PinCode { message } => AuthOutcome::PinCode { message },
        }
    }
}

/// An operation for the actor: a control command, an auth step, or forget-auth.
enum Op {
    Cmd(bc::Command),
    Auth(bc::AuthInput),
    Forget,
}

/// The successful result of an [`Op`].
enum OpOk {
    Done,
    Auth(AuthOutcome),
}

/// An operation plus a one-shot channel to report its result back to the caller.
struct CmdMsg {
    op: Op,
    ack: tokio::sync::oneshot::Sender<std::result::Result<OpOk, String>>,
}

/// A live connection to one battery (opaque to Dart; methods are async).
///
/// The BLE/serial connection is owned by a background **actor task**; this
/// handle just talks to it over channels. The actor keeps a running
/// [`bc::BatteryStatus`] (so [`status`](BatteryConn::status) works) and
/// broadcasts incremental [`StreamEvent`]s to every [`watch`](BatteryConn::watch)
/// subscriber.
#[frb(opaque)]
pub struct BatteryConn {
    info: DeviceInfo,
    caps: Caps,
    cmd_tx: tokio::sync::mpsc::Sender<CmdMsg>,
    /// Full running state, for one-shot `status()` and initial snapshots.
    current: tokio::sync::watch::Sender<bc::BatteryStatus>,
    /// Incremental updates fanned out to live subscribers.
    events: tokio::sync::broadcast::Sender<StreamEvent>,
}

/// Connect to a device from the last `discover_devices` call, by id (or
/// unambiguous prefix / label substring — same resolution as the CLI).
pub async fn connect(query: String, ble_secs: u64) -> Result<BatteryConn> {
    #[cfg(target_os = "android")]
    crate::android_init::ensure_thread_attached();
    let dev = {
        let devices = DISCOVERED.lock().unwrap();
        bc::resolve(&devices, &query)
            .map_err(|e| anyhow!("{e}"))?
            .clone()
    };
    let mut battery = dev.connect(ble_secs).await.map_err(|e| anyhow!("{e}"))?;
    let info: DeviceInfo = battery.info().into();
    let caps: Caps = battery.capabilities().into();

    // Prime a full snapshot before streaming so the first subscriber sees
    // complete state, rather than an empty view that fills in only as values
    // change. (For push backends this is the first full telemetry frame.)
    let init = battery.status().await.unwrap_or_default();

    let (cmd_tx, cmd_rx) = tokio::sync::mpsc::channel::<CmdMsg>(8);
    let (current, _) = tokio::sync::watch::channel(init.clone());
    let (events, _) = tokio::sync::broadcast::channel::<StreamEvent>(256);
    let current_tx = current.clone();
    let events_tx = events.clone();
    tokio::spawn(async move { actor(battery, cmd_rx, current_tx, events_tx, init).await });

    Ok(BatteryConn { info, caps, cmd_tx, current, events })
}

/// Explicitly close the transport (e.g. send a BLE disconnect) before the
/// actor drops the battery. Runs when the `BatteryConn` handle is dropped.
async fn shutdown(battery: &mut Box<dyn bc::Battery>) {
    #[cfg(target_os = "android")]
    crate::android_init::ensure_thread_attached();
    if let Err(e) = battery.disconnect().await {
        eprintln!("disconnect failed: {e}");
    }
}

/// Runs one command against the device and reports the result to its caller.
async fn run_cmd(battery: &mut Box<dyn bc::Battery>, msg: CmdMsg) {
    #[cfg(target_os = "android")]
    crate::android_init::ensure_thread_attached();
    // A BLE write can stall (e.g. the device doesn't ACK a with-response write
    // right after a port state change). Bound it so the UI never hangs.
    let r = match msg.op {
        Op::Cmd(cmd) => match tokio::time::timeout(Duration::from_secs(10), battery.execute(cmd)).await {
            Ok(res) => res.map(|_| OpOk::Done).map_err(|e| e.to_string()),
            Err(_) => Err("command timed out".to_string()),
        },
        // Auth (bind) can involve a physical button + handshake; allow longer.
        Op::Auth(input) => match tokio::time::timeout(Duration::from_secs(60), battery.authenticate(input)).await {
            Ok(res) => res.map(|st| OpOk::Auth(st.into())).map_err(|e| e.to_string()),
            Err(_) => Err("authentication timed out".to_string()),
        },
        Op::Forget => battery.forget_auth().await.map(|_| OpOk::Done).map_err(|e| e.to_string()),
    };
    let _ = msg.ack.send(r);
}

/// Publish one incremental update: fold it into the running state and broadcast.
fn publish(
    update: bc::StatusUpdate,
    cur: &mut bc::BatteryStatus,
    current: &tokio::sync::watch::Sender<bc::BatteryStatus>,
    events: &tokio::sync::broadcast::Sender<StreamEvent>,
) {
    cur.apply(&update);
    let _ = current.send(cur.clone());
    let _ = events.send(StreamEvent::Update((&update).into()));
}

/// Owns the connection: emits real-time [`StreamEvent`]s and interleaves control
/// commands. Ends when the handle (and thus `cmd_tx`) is dropped.
///
/// Commands are handled the instant they arrive (biased `select!` on the command
/// channel) so toggles are responsive even when telemetry is sparse. A command
/// is only *observed* in the select (that branch borrows the channel, not the
/// battery); the actual `&mut battery` work happens after the read future is
/// dropped. `run_cmd` bounds each command with a timeout so a stuck BLE write
/// can never wedge the UI.
async fn actor(
    mut battery: Box<dyn bc::Battery>,
    mut cmd_rx: tokio::sync::mpsc::Receiver<CmdMsg>,
    current: tokio::sync::watch::Sender<bc::BatteryStatus>,
    events: tokio::sync::broadcast::Sender<StreamEvent>,
    mut cur: bc::BatteryStatus,
) {
    loop {
        #[cfg(target_os = "android")]
        crate::android_init::ensure_thread_attached();

        // Run any already-queued commands first.
        loop {
            match cmd_rx.try_recv() {
                Ok(msg) => run_cmd(&mut battery, msg).await,
                Err(tokio::sync::mpsc::error::TryRecvError::Empty) => break,
                Err(tokio::sync::mpsc::error::TryRecvError::Disconnected) => {
                    shutdown(&mut battery).await;
                    return;
                }
            }
        }

        // Prefer the backend's real-time push stream (Anker telemetry, JK
        // cell-info broadcasts): updates arrive as the device emits them and
        // no polling commands are sent. The stream borrows the battery, so a
        // command tears it down (scope ends), runs, and the outer loop
        // re-subscribes — backends resume their push stream cheaply.
        // Unified real-time stream from battery_control: native push when the
        // backend has one, poll-and-diff otherwise. The stream borrows the
        // battery, so a command tears it down (scope ends), runs, and the
        // outer loop re-subscribes — push backends resume cheaply.
        let wake = {
            use futures_util::StreamExt;
            let mut updates = battery.updates(Duration::from_secs(1));
            loop {
                let w = tokio::select! {
                    biased;
                    maybe = cmd_rx.recv() => match maybe {
                        Some(msg) => Wake::Cmd(msg),
                        None => Wake::Closed,
                    },
                    u = updates.next() => Wake::Update(u),
                };
                // Publishing doesn't touch the battery, so stay in this inner
                // loop while updates flow; anything else drops the stream
                // (end of scope) to free the `&mut battery` borrow.
                if let Wake::Update(Some(Ok(u))) = w {
                    publish(u, &mut cur, &current, &events);
                    continue;
                }
                break w;
            }
        };
        match wake {
            Wake::Cmd(msg) => run_cmd(&mut battery, msg).await,
            Wake::Closed => {
                shutdown(&mut battery).await;
                return;
            }
            // Stream yielded an error or ended: report, back off, resubscribe.
            Wake::Update(Some(Err(e))) => {
                let _ = events.send(StreamEvent::Error(e.to_string()));
                tokio::time::sleep(Duration::from_millis(500)).await;
            }
            Wake::Update(Some(Ok(_))) => unreachable!("published in inner loop"),
            Wake::Update(None) => {
                tokio::time::sleep(Duration::from_millis(500)).await;
            }
        }
    }
}

/// What woke the actor's select.
enum Wake {
    Cmd(CmdMsg),
    Closed,
    Update(Option<bc::Result<bc::StatusUpdate>>),
}

impl BatteryConn {
    #[frb(sync)]
    pub fn info(&self) -> DeviceInfo {
        DeviceInfo {
            backend: self.info.backend.clone(),
            model: self.info.model.clone(),
            serial: self.info.serial.clone(),
            firmware: self.info.firmware.clone(),
        }
    }

    #[frb(sync)]
    pub fn capabilities(&self) -> Caps {
        Caps { ..Caps::from_ref(&self.caps) }
    }

    async fn command(&self, cmd: bc::Command) -> Result<()> {
        match self.run_op(Op::Cmd(cmd)).await? {
            OpOk::Done => Ok(()),
            OpOk::Auth(_) => Ok(()),
        }
    }

    async fn run_op(&self, op: Op) -> Result<OpOk> {
        let (ack, rx) = tokio::sync::oneshot::channel();
        self.cmd_tx
            .send(CmdMsg { op, ack })
            .await
            .map_err(|_| anyhow!("device disconnected"))?;
        rx.await
            .map_err(|_| anyhow!("device task ended"))?
            .map_err(|e| anyhow!(e))
    }

    /// Drive the device's authentication / binding flow. Pass `None` to start (or
    /// to retry after a physical approval), or a PIN when prompted. Returns the
    /// next [`AuthOutcome`]; loop until `Authed`.
    pub async fn authenticate(&self, pin: Option<String>) -> Result<AuthOutcome> {
        let input = match pin {
            Some(p) => bc::AuthInput::Pin(p),
            None => bc::AuthInput::None,
        };
        match self.run_op(Op::Auth(input)).await? {
            OpOk::Auth(a) => Ok(a),
            OpOk::Done => Ok(AuthOutcome::Authed),
        }
    }

    /// Forget the saved pairing so the next connect re-runs the flow. The
    /// on-device bond persists until the device itself is reset.
    pub async fn forget_pairing(&self) -> Result<()> {
        self.run_op(Op::Forget).await.map(|_| ())
    }

    /// Toggle a port or switch by id (`"ac"`, `"charging"`, `"heater"`, ...).
    pub async fn toggle(&self, id: String, on: bool) -> Result<()> {
        self.command(bc::Command::Toggle { id, on }).await
    }

    /// Set a named value (`"charge_limit"` = `"80"`, ...).
    pub async fn set(&self, id: String, value: String) -> Result<()> {
        self.command(bc::Command::Set { id, value }).await
    }

    /// Current full snapshot the actor has accumulated. Used for
    /// manual/pull-to-refresh; the live picture comes from [`watch`](Self::watch).
    #[frb(sync)]
    pub fn status(&self) -> BatteryStatus {
        self.current.borrow().clone().into()
    }

    /// Subscribe to the **real-time** stream. The first event is a full
    /// [`StreamEvent::Snapshot`] of current state; subsequent events are
    /// incremental [`StreamEvent::Update`]s (or [`StreamEvent::Error`]). Ends
    /// when Dart cancels the subscription.
    pub async fn watch(&self, sink: StreamSink<StreamEvent>) {
        let mut rx = self.events.subscribe();
        // Seed the subscriber with the full current state.
        let snapshot: BatteryStatus = self.current.borrow().clone().into();
        if sink.add(StreamEvent::Snapshot(snapshot)).is_err() {
            return;
        }
        loop {
            match rx.recv().await {
                Ok(ev) => {
                    if sink.add(ev).is_err() {
                        break; // Dart cancelled
                    }
                }
                // Dropped some updates under load: resync with a full snapshot.
                Err(tokio::sync::broadcast::error::RecvError::Lagged(_)) => {
                    let snap: BatteryStatus = self.current.borrow().clone().into();
                    if sink.add(StreamEvent::Snapshot(snap)).is_err() {
                        break;
                    }
                }
                Err(tokio::sync::broadcast::error::RecvError::Closed) => break,
            }
        }
    }
}

/// One event in the live device-state stream.
#[derive(Clone)]
pub enum StreamEvent {
    /// Full state; sent once when a subscriber attaches (and after a lag resync).
    Snapshot(BatteryStatus),
    /// A single incremental change.
    Update(StatusUpdate),
    /// A transient transport error.
    Error(String),
}

/// Incremental update DTO mirroring [`bc::StatusUpdate`] (Dart-facing): one
/// changed element of a collection, keyed by its id/index.
#[derive(Clone)]
pub enum StatusUpdate {
    Sensor(Sensor),
    Switch(Switch),
    Port(PortInfo),
    Cell(CellInfo),
    Setting(Setting),
    Alarms(Vec<String>),
}

impl From<&bc::StatusUpdate> for StatusUpdate {
    fn from(u: &bc::StatusUpdate) -> Self {
        use bc::StatusUpdate as U;
        match u {
            U::Sensor(s) => Self::Sensor(s.into()),
            U::Switch(w) => Self::Switch(w.into()),
            U::Port(p) => Self::Port(p.into()),
            U::Cell(c) => Self::Cell(c.into()),
            U::Setting(s) => Self::Setting(s.into()),
            U::Alarms(a) => Self::Alarms(a.clone()),
        }
    }
}

impl Caps {
    fn from_ref(c: &Caps) -> Caps {
        Caps {
            read_basic: c.read_basic,
            read_cells: c.read_cells,
            read_ports: c.read_ports,
            read_temperature: c.read_temperature,
            read_limits: c.read_limits,
            read_alarms: c.read_alarms,
            toggle_charge: c.toggle_charge,
            toggle_discharge: c.toggle_discharge,
            toggle_balancer: c.toggle_balancer,
            set_charge_limit: c.set_charge_limit,
            write_settings: c.write_settings,
            requires_auth: c.requires_auth,
            controllable: c.controllable,
        }
    }
}

/// True when this build can probe serial ports (desktop targets).
#[frb(sync)]
pub fn has_serial_support() -> bool {
    cfg!(not(any(target_os = "ios", target_os = "android")))
}
