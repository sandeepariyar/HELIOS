# Optimized image assets

The graphics in `assets/` use pre-Qt palette reduction, asset deduplication and validated nine-slice resources. All visible UI labels and dynamic values remain native QML text.

`asset_manifest.json` records the optimization pass. CMake also measures the asset source bytes at configuration time.

The workflow is designed for MCU-like memory constraints, while this public project is built and demonstrated with Qt 6.
