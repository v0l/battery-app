//! FRB bridge over `battery_control`: DTO mirrors of the normalized data
//! model, discovery via a process-global cache, and an opaque connection
//! handle wrapping `Box<dyn Battery>`.

use anyhow::{anyhow, Result};
use battery_control as bc;
use flutter_rust_bridge::frb;
use std::sync::Mutex as StdMutex;
use tokio::sync::Mutex;

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
    pub toggle_ports: bool,
    pub toggle_charge: bool,
    pub toggle_discharge: bool,
    pub toggle_balancer: bool,
    pub set_charge_limit: bool,
    pub write_settings: bool,
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
            toggle_ports: c.contains(C::TOGGLE_PORTS),
            toggle_charge: c.contains(C::TOGGLE_CHARGE),
            toggle_discharge: c.contains(C::TOGGLE_DISCHARGE),
            toggle_balancer: c.contains(C::TOGGLE_BALANCER),
            set_charge_limit: c.contains(C::SET_CHARGE_LIMIT),
            write_settings: c.contains(C::WRITE_SETTINGS),
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

pub struct CellInfo {
    pub index: u8,
    pub voltage: Option<f32>,
    pub resistance: Option<f32>,
    pub balancing: Option<bool>,
}

pub enum PortDirection {
    In,
    Out,
    Bidir,
}

pub struct PortInfo {
    pub id: String,
    pub label: Option<String>,
    pub direction: Option<PortDirection>,
    pub on: Option<bool>,
    pub watts: Option<f32>,
}

pub struct Sensor {
    pub id: String,
    pub label: Option<String>,
    pub celsius: f32,
}

pub struct Switch {
    pub id: String,
    pub label: Option<String>,
    pub on: bool,
}

pub struct BatteryStatus {
    pub soc: Option<f32>,
    pub soh: Option<f32>,
    pub voltage: Option<f32>,
    pub current: Option<f32>,
    pub power_in: Option<f32>,
    pub power_out: Option<f32>,
    pub temperatures: Vec<Sensor>,
    pub time_remaining_h: Option<f32>,
    pub capacity_remaining_ah: Option<f32>,
    pub capacity_full_ah: Option<f32>,
    pub cycles: Option<u32>,
    pub charging: Option<bool>,
    pub discharging: Option<bool>,
    pub switches: Vec<Switch>,
    pub charge_current_limit_a: Option<f32>,
    pub discharge_current_limit_a: Option<f32>,
    pub soc_limit_max: Option<f32>,
    pub soc_limit_min: Option<f32>,
    pub cells: Vec<CellInfo>,
    pub ports: Vec<PortInfo>,
    pub alarms: Vec<String>,
    /// Convenience: highest reported temperature.
    pub temperature_c: Option<f32>,
    /// Convenience: cell voltage spread (max - min).
    pub cell_delta: Option<f32>,
}

impl From<bc::BatteryStatus> for BatteryStatus {
    fn from(s: bc::BatteryStatus) -> Self {
        let temperature_c = s.temperature_c();
        let cell_delta = s.cell_delta();
        Self {
            soc: s.soc,
            soh: s.soh,
            voltage: s.voltage,
            current: s.current,
            power_in: s.power_in,
            power_out: s.power_out,
            temperatures: s
                .temperatures
                .into_iter()
                .map(|t| Sensor { id: t.id, label: t.label, celsius: t.celsius })
                .collect(),
            time_remaining_h: s.time_remaining_h,
            capacity_remaining_ah: s.capacity_remaining_ah,
            capacity_full_ah: s.capacity_full_ah,
            cycles: s.cycles,
            charging: s.charging,
            discharging: s.discharging,
            switches: s
                .switches
                .into_iter()
                .map(|w| Switch { id: w.id, label: w.label, on: w.on })
                .collect(),
            charge_current_limit_a: s.charge_current_limit_a,
            discharge_current_limit_a: s.discharge_current_limit_a,
            soc_limit_max: s.soc_limit_max,
            soc_limit_min: s.soc_limit_min,
            cells: s
                .cells
                .into_iter()
                .map(|c| CellInfo {
                    index: c.index,
                    voltage: c.voltage,
                    resistance: c.resistance,
                    balancing: c.balancing,
                })
                .collect(),
            ports: s
                .ports
                .into_iter()
                .map(|p| PortInfo {
                    id: p.id,
                    label: p.label,
                    direction: p.direction.map(|d| match d {
                        bc::PortDirection::In => PortDirection::In,
                        bc::PortDirection::Out => PortDirection::Out,
                        bc::PortDirection::Bidir => PortDirection::Bidir,
                    }),
                    on: p.on,
                    watts: p.watts,
                })
                .collect(),
            alarms: s.alarms,
            temperature_c,
            cell_delta,
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

/// A live connection to one battery (opaque to Dart; methods are async).
#[frb(opaque)]
pub struct BatteryConn {
    info: DeviceInfo,
    caps: Caps,
    inner: Mutex<Box<dyn bc::Battery>>,
}

/// Connect to a device from the last `discover_devices` call, by id (or
/// unambiguous prefix / label substring — same resolution as the CLI).
pub async fn connect(query: String, ble_secs: u64) -> Result<BatteryConn> {
    let dev = {
        let devices = DISCOVERED.lock().unwrap();
        bc::resolve(&devices, &query)
            .map_err(|e| anyhow!("{e}"))?
            .clone()
    };
    let battery = dev.connect(ble_secs).await.map_err(|e| anyhow!("{e}"))?;
    Ok(BatteryConn {
        info: battery.info().into(),
        caps: battery.capabilities().into(),
        inner: Mutex::new(battery),
    })
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

    /// Fetch a fresh status snapshot.
    pub async fn status(&self) -> Result<BatteryStatus> {
        let mut b = self.inner.lock().await;
        Ok(b.status().await.map_err(|e| anyhow!("{e}"))?.into())
    }

    /// Toggle a port or switch by id (`"ac"`, `"charging"`, `"heater"`, ...).
    pub async fn toggle(&self, id: String, on: bool) -> Result<()> {
        let mut b = self.inner.lock().await;
        b.execute(bc::Command::Toggle { id, on })
            .await
            .map_err(|e| anyhow!("{e}"))
    }

    /// Set a named value (`"charge_limit"` = `"80"`, ...).
    pub async fn set(&self, id: String, value: String) -> Result<()> {
        let mut b = self.inner.lock().await;
        b.execute(bc::Command::Set { id, value })
            .await
            .map_err(|e| anyhow!("{e}"))
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
            toggle_ports: c.toggle_ports,
            toggle_charge: c.toggle_charge,
            toggle_discharge: c.toggle_discharge,
            toggle_balancer: c.toggle_balancer,
            set_charge_limit: c.set_charge_limit,
            write_settings: c.write_settings,
            controllable: c.controllable,
        }
    }
}

/// True when this build can probe serial ports (desktop targets).
#[frb(sync)]
pub fn has_serial_support() -> bool {
    cfg!(not(any(target_os = "ios", target_os = "android")))
}
