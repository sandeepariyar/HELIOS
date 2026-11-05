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

Open-Meteo requests depend on browser CORS/network policy. Web audio may be unavailable, while the energy simulator continues to work offline.
