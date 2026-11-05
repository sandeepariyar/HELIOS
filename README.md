# HELIOS — Energy Management Cockpit

**Designed & Developed by Sandeep Pariyar**  
**Qt 6 · QML · C++ · Optimized Embedded-Inspired UI**

HELIOS is a desktop energy-system cockpit and interactive portfolio simulator. The application presents an 800 × 480 embedded-inspired marine/residential energy interface with power-flow visualizations, battery monitoring, actuator controls, and an engineering diagnostics panel.

> **Simulator, not a hardware controller.** PV generation, battery pack values, contactor states, CAN status, and safety functions are simulated. Weather and irradiance may be retrieved from Open-Meteo; those are external weather/model data, not measured electrical telemetry.

## Highlights

- Native **Qt Quick / QML** user interface with a **C++** energy simulation backend
- Cockpit, Flow Topology, and BMS Storage views
- ECO / BALANCED / PERF modes, configurable demand and PV settings
- Interactive radial battery SOC control and simulated 16-cell pack visualization
- Simulated bus isolation, reset, alarms, and event log
- Optional audio feedback and real Open-Meteo weather / solar irradiance
- MCU-oriented graphics: **pre-Qt palette reduction**, reusable assets, validated nine-slice backgrounds and native QML text
- Developer metrics showing source-asset usage and explicitly labeled framebuffer estimates
- Designed for **Qt 6 Community Edition**; no Qt for MCUs commercial license needed

## Build on Windows

Use **Qt 6.5+**, CMake 3.21+, a C++17 compiler, and Qt modules **Quick** and **Network**. Qt Multimedia is optional.

1. Clone this repository.
2. Open `CMakeLists.txt` in Qt Creator.
3. Select your desktop Qt kit (tested by the author using Qt 6.11.2 MinGW on Windows).
4. Configure and build.

The CMake project uses `NO_CACHEGEN` to avoid a MinGW object-size issue with large generated QML sources.

## Project structure

```text
src/         C++ backend and simulation logic
qml/         Native QML screens, controls and DEV panel
assets/      Reusable optimized PNG graphics
sounds/      Original short WAV effects
prototype/   HTML design reference
tooling/     Asset optimization manifest
references/  Screen reference images
```

The source project is designed to stay lightweight. **PNG file bytes are not equivalent to MCU flash or RAM use**. A true MCU firmware size requires an MCU-targeted build.

## WebAssembly

A native **Qt WebAssembly** browser build is a planned enhancement. GitHub Pages hosting is **not live yet**; a desktop Qt build is the current implementation. The original HTML reference is not a substitute for a Qt WebAssembly build.

## Licensing

Original HELIOS code is licensed under **MIT** (see [LICENSE](LICENSE)). Qt and the free fonts used by the application have their own licenses. Open-Meteo data/API usage is subject to Open-Meteo terms.

---

© 2026 **Sandeep Pariyar** — Designed & Developed by Sandeep Pariyar.
