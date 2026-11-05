# Qt WebAssembly + GitHub Pages

HELIOS's browser edition is compiled from **the same C++ and QML source** as the desktop application. It is not an imitation of the desktop UI.

## Automatic GitHub Pages build

`.github/workflows/pages.yml` installs Qt 6.11.2 WebAssembly single-threaded with Emscripten 4.0.7, compiles HELIOS, copies the Qt WebAssembly loader and binary files, then deploys via GitHub Pages.

1. Open the GitHub repository **Settings → Pages**.
2. Under **Build and deployment**, select **GitHub Actions**.
3. Open **Actions → Build and deploy Qt WebAssembly**, and run the workflow if it has not started automatically.
4. Verify the build succeeds before sharing the public URL: https://sandeepariyar.github.io/HELIOS/

The workflow currently targets the official Qt 6.11.2 package. If its package layout changes, adjust the aqtinstall version/architecture and loader output mapping.

## Run locally with your Qt WebAssembly kit

In Qt Creator select a **Qt 6.11.x WebAssembly single-threaded kit**, configure the CMake project, and build in Release mode. Serve the generated browser files with a local web server (not directly from the file system). Qt normally generates `Helios.wasm`, `Helios.js`, `Helios.html` and its `qtloader.js` loader.

Open-Meteo requests depend on browser CORS/network policy. The energy simulator continues to work offline.

## Device mockup and viewport

The GitHub Pages launcher uses an optimized WebP render of a front-facing MCU-style display. The **real Qt WebAssembly canvas** is centered over the display opening, scaled uniformly without changing the QML scene or raster asset colors. The MCU enclosure is a presentation image, not an actual hardware target.

The browser viewport automatically scales the complete device for desktop and mobile screens. The native Qt window is 840×520; the black mat inside the bezel permits a precise aspect-preserving overlay.

## Sound on the browser

Qt Multimedia is optional on desktop and deliberately omitted from the WebAssembly build. The C++ simulator's existing sound events call a small Emscripten JavaScript bridge that plays the three original WAV effects with Web Audio.

**Browsers require a user action to unlock audio.** Click **ENABLE SOUND** on the upper-right of the page. This loads and decodes `sounds/confirm.wav`, `warning.wav`, and `trip.wav`. The app's own Settings sound toggle and volume still determine whether events are sent to the player. The external page button lets viewers mute browser output.

GitHub Actions now uses Chromium to check that the Qt canvas renders inside the centered hardware shell and that a real QML mode click triggers a C++ sound event.
