import QtQuick
import QtQuick.Window

Window {
    id: root
    visible: true
    width: 840
    height: 520
    minimumWidth: 840
    minimumHeight: 520
    title: "HELIOS — Energy Cockpit Simulator | Sandeep Pariyar"
    color: "#07090D"
    property string currentView: "main"
    readonly property string currentMode: backend.mode
    property real batteryLevel: backend.soc
    property string liveClock: Qt.formatTime(new Date(), "hh:mm:ss")
    property bool settingsOpen: false
    property bool devOpen: false
    property int devPixelBytes: 2
    property int devBuffers: 2
    property bool tripConfirm: false
    property bool resetConfirm: false
    property string settingsTab: "controls"
    // Original UI text is always QML Text. Graphics are separate optimized sprites.
    FontLoader { id: fontMono; source: Qt.resolvedUrl("fonts/JetBrainsMono.ttf") }
    FontLoader { id: fontGrotesk; source: Qt.resolvedUrl("fonts/SpaceGrotesk.ttf") }
    Timer { interval: 1000; running: true; repeat: true; onTriggered: root.liveClock = Qt.formatTime(new Date(), "hh:mm:ss") }
    Behavior on batteryLevel { NumberAnimation { duration: 400 } }
    function changeMode(name) { backend.selectMode(name) }
    function changePage(name) { root.currentView = name; backend.playTap() }
    readonly property bool actuator_inverter_boost: backend.boost
    readonly property bool actuator_island_isolation: backend.island
    readonly property bool actuator_aux_ev_charge: backend.evCharge
    Item {
        id: scene
        x: 20; y: 20; width: 800; height: 480
        clip: true
        Item {
            visible: root.currentView === "main"
            anchors.fill: parent
            clip: true
            BorderImage {
                x: 0.0; y: 0.0; width: 800; height: 480
                source: "assets/slice_359b0f433a4b7316.png"
                border.left: 9
                border.right: 9
                border.top: 9
                border.bottom: 9
                cache: true
            }
            BorderImage {
                x: 1.0; y: 1.0; width: 798; height: 46
                source: "assets/slice_5d0b7f7fa0bb4b01.png"
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
                cache: true
            }
            BorderImage {
                x: 17.0; y: 10.5; width: 130.7; height: 26
                source: "assets/slice_7689bd57393136b1.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Image {
                x: 28.0; y: 20.5; width: 6; height: 6
                source: "assets/sprite_24777f95dc4a0046.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 42.0; y: 15.5; width: 70.61; height: 18.0
                text: "HELIOS-9"
                color: "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.6
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 112.61; y: 17.0; width: 32.09; height: 15.0
                text: "v2.4"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 159.7; y: 15.25; width: 14.629999999999999; height: 17.0
                text: "|"
                color: "#45556C"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 174.33; y: 15.25; width: 87.48; height: 17.0
                text: backend.isolated ? "BUS TRIPPED" : (backend.island ? "ISLANDED BUS" : "GRID LINKED")
                color: "#FFB900"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 500
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 261.81; y: 15.25; width: 14.629999999999999; height: 17.0
                text: "•"
                color: "#45556C"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 276.44; y: 15.25; width: 87.48; height: 17.0
                text: backend.isolated ? "0V DC LINK" : "400V DC LINK"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 407.72; y: 3.25; width: 203.63; height: 40.5
                source: "assets/slice_e0dd51f7fc96a562.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 412.72; y: 8.25; width: 47.53; height: 30.5
                source: click_main_11.pressed ? "assets/slice_ec071827d55d536e.png" : ((root.currentMode === "eco") ? "assets/slice_0f1b1c0a28b30e24.png" : "assets/slice_efb6e64e267ec8c0.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 425.72; y: 15.25; width: 29.53; height: 17.0
                text: "ECO"
                color: (root.currentMode === "eco") ? "#22D3EE" : "#CAD5E2"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.55
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 464.25; y: 8.25; width: 83.39; height: 30.5
                source: click_main_13.pressed ? "assets/slice_9a254162ff68d63e.png" : ((root.currentMode === "balanced") ? "assets/slice_71437b2ddae35c82.png" : "assets/slice_4e8b116d4a5a5aea.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 477.25; y: 15.25; width: 65.39; height: 17.0
                text: "BALANCED"
                color: (root.currentMode === "balanced") ? "#22D3EE" : "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.55
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 551.64; y: 8.25; width: 54.7; height: 30.5
                source: click_main_15.pressed ? "assets/slice_9a254162ff68d63e.png" : ((root.currentMode === "perf") ? "assets/slice_71437b2ddae35c82.png" : "assets/slice_4e8b116d4a5a5aea.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 564.64; y: 15.25; width: 36.7; height: 17.0
                text: "PERF"
                color: (root.currentMode === "perf") ? "#22D3EE" : "#CAD5E2"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.55
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 676.39; y: 9.5; width: 70.61; height: 18.0
                text: root.liveClock
                color: "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.6
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 663.14; y: 25.5; width: 83.86; height: 14.0
                text: backend.location.toUpperCase() + " // WX"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 751.0; y: 7.5; width: 32; height: 32
                source: "assets/slice_fbe9b1f18964bf4a.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Image {
                x: 759.0; y: 15.5; width: 16; height: 16
                source: "assets/sprite_1149a20d805005bd.png"
                fillMode: Image.Stretch
                cache: true
            }
            BorderImage {
                x: 1.0; y: 47.0; width: 798; height: 384
                source: "assets/slice_0a3b99e420c61a0b.png"
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
                cache: true
            }
            Image {
                x: 15.0; y: 61.0; width: 248.66; height: 74
                source: "assets/sprite_ca889b8e8ed08478.png"
                fillMode: Image.Stretch
                cache: true
            }
            Image {
                x: 26.0; y: 74.0; width: 14; height: 14
                source: "assets/sprite_5a6e491b55f6488c.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 46.0; y: 74.5; width: 86.25; height: 15.0
                text: "PV SOLAR GEN"
                color: "#FFB900"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 600
                font.letterSpacing: 0.5
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
                font.capitalization: Font.AllUppercase
            }
            Text {
                x: 26.0; y: 91.5; width: 63.41; height: 32.0
                text: backend.solarKW.toFixed(2)
                color: "#FFFFFF"
                font.family: "JetBrains Mono"
                font.pixelSize: 24.0
                font.weight: 700
                font.letterSpacing: -0.6
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 85.41; y: 103.5; width: 26.27; height: 16.0
                text: "kW"
                color: "#FFD230"
                font.family: "Space Grotesk"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.88
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 193.05; y: 79.25; width: 67.61; height: 14.0
                text: "PEAK 7.1 kW"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 180.41; y: 99.75; width: 80.25; height: 15.0
                text: "+18% OPTIMAL"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 275.66; y: 61.0; width: 248.67; height: 74
                source: "assets/sprite_80ef8d6bda0043e2.png"
                fillMode: Image.Stretch
                cache: true
            }
            Image {
                x: 286.66; y: 74.0; width: 14; height: 14
                source: "assets/sprite_69acc86135784f2a.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 306.66; y: 74.5; width: 125.38; height: 15.0
                text: "VESSEL / RESIDENCE"
                color: "#00D3F3"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 600
                font.letterSpacing: 0.5
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
                font.capitalization: Font.AllUppercase
            }
            Text {
                x: 286.66; y: 91.5; width: 63.41; height: 32.0
                text: backend.loadKW.toFixed(2)
                color: "#FFFFFF"
                font.family: "JetBrains Mono"
                font.pixelSize: 24.0
                font.weight: 700
                font.letterSpacing: -0.6
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 346.06; y: 103.5; width: 26.27; height: 16.0
                text: "kW"
                color: "#53EAFD"
                font.family: "Space Grotesk"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.88
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 453.72; y: 79.25; width: 67.61; height: 14.0
                text: "BASE 0.8 kW"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 447.09; y: 99.75; width: 74.23; height: 15.0
                text: "NORMAL LOAD"
                color: "#00D3F3"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 536.33; y: 61.0; width: 248.67; height: 74
                source: "assets/sprite_48a914b1ef6192bf.png"
                fillMode: Image.Stretch
                cache: true
            }
            Image {
                x: 547.33; y: 74.0; width: 14; height: 14
                source: "assets/sprite_d0232858a3426dc7.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 567.33; y: 74.5; width: 92.78; height: 15.0
                text: "GRID INTERTIE"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 600
                font.letterSpacing: 0.5
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
                font.capitalization: Font.AllUppercase
            }
            Text {
                x: 547.33; y: 91.5; width: 63.41; height: 32.0
                text: Math.abs(backend.gridKW).toFixed(2)
                color: "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 24.0
                font.weight: 700
                font.letterSpacing: -0.6
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 606.73; y: 103.5; width: 26.27; height: 16.0
                text: "kW"
                color: "#90A1B9"
                font.family: "Space Grotesk"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.88
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 692.72; y: 79.25; width: 89.28; height: 14.0
                text: backend.island ? "GRID ISOLATED" : (backend.gridKW>=0 ? "IMPORT" : "EXPORT")
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 683.69; y: 99.75; width: 98.31; height: 15.0
                text: backend.island ? "GRID OFFLINE" : "50 Hz MODEL"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 19.0; y: 154.0; width: 210; height: 216
                source: "assets/sprite_29e1b6af0e4871ca.png"
                fillMode: Image.Stretch
                cache: true
            }
            Image {
                x: 32.0; y: 171.5; width: 6; height: 6
                source: "assets/sprite_e1165027d68c27e8.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 42.0; y: 168.0; width: 112.33; height: 15.0
                text: "STORAGE BANK A+B"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 600
                font.letterSpacing: 0.5
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 173.84; y: 168.0; width: 50.16; height: 15.0
                text: "LFP 48V"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 68.0; y: 189.25; width: 112; height: 112
                source: "assets/sprite_d4700079cea0de22.png"
                fillMode: Image.Stretch
                cache: true
            }
            Canvas {
                id: batteryGaugeCanvas
                x: 68.0; y: 189.25; width: 112.0; height: 112.0
                onPaint: {
                    const ctx = getContext("2d"); ctx.reset();
                    const cx=width/2, cy=height/2, radius=Math.min(width,height)*0.41;
                    ctx.lineWidth=7; ctx.lineCap="round";
                    ctx.beginPath(); ctx.strokeStyle="#161D2B";
                    ctx.arc(cx,cy,radius,0,2*Math.PI);ctx.stroke();
                    ctx.beginPath();ctx.strokeStyle="#10B981";
                    ctx.arc(cx,cy,radius,-Math.PI/2,-Math.PI/2+2*Math.PI*root.batteryLevel/100);ctx.stroke();
                }
                Connections { target: root; function onBatteryLevelChanged(){ batteryGaugeCanvas.requestPaint() } }
            }
            Text {
                x: 100.5; y: 216.0; width: 44.13; height: 39.0
                text: Math.round(backend.soc).toString()
                color: "#FFFFFF"
                font.family: "JetBrains Mono"
                font.pixelSize: 30.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 136.63; y: 227.0; width: 18.84; height: 25.0
                text: "%"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 18.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 94.19; y: 257.0; width: 67.61; height: 14.0
                text: "State of Ch"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
                font.capitalization: Font.AllUppercase
            }
            Text {
                x: 32.0; y: 309.5; width: 68.22; height: 15.0
                text: "AVAILABLE:"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 125.69; y: 309.5; width: 98.31; height: 15.0
                text: backend.availableKWh.toFixed(1) + " / 28.8 kWh"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 32.0; y: 329.5; width: 184; height: 8
                source: "assets/sprite_c52fad8f5ec547e0.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 32.0; y: 343.5; width: 67.61; height: 14.0
                text: "TEMP " + backend.temperature.toFixed(1) + "°C"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 150.97; y: 343.5; width: 73.03; height: 14.0
                text: "SOH 99.8% (DEMO)"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 245.0; y: 154.0; width: 310; height: 216
                source: "assets/sprite_baa032b98fc466a4.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 274; y: 161; width: 251; height: 16
                text: "SYS_FLOW // ACTIVE INVERSION"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.9
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
                font.capitalization: Font.AllUppercase
            }
            Text {
                x: 274; y: 181; width: 251; height: 15
                text: backend.flowDirection
                horizontalAlignment: Text.AlignRight
                color: "#00D3F3"
                font.family: "JetBrains Mono"
                font.pixelSize: 8.0
                font.weight: 700
                font.letterSpacing: 0.0
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 303.73; y: 206.5; width: 200.5; height: 15.0
                text: "Net Solar Surplus Inflow"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 600
                font.letterSpacing: 2.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
                font.capitalization: Font.AllUppercase
            }
            Text {
                x: 317.0; y: 218.5; width: 143.0; height: 74.0
                text: backend.surplusKW.toFixed(1)
                color: "#FFFFFF"
                font.family: "JetBrains Mono"
                font.pixelSize: 60.0
                font.weight: 800
                font.letterSpacing: -3.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 439.22; y: 252.5; width: 36.91; height: 32.0
                text: "kW"
                color: "#00D3F3"
                font.family: "JetBrains Mono"
                font.pixelSize: 24.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 300.64; y: 292.5; width: 44.13; height: 18.0
                text: "SOLAR"
                color: "#FFB900"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 344.77; y: 297.5; width: 96; height: 6
                source: "assets/sprite_554c8662b4c33695.png"
                fillMode: Image.Stretch
                cache: true
            }
            Image {
                x: 344.77; y: 297.5; width: 32; height: 6
                source: "assets/sprite_1cf32d75c0086887.png"
                fillMode: Image.Stretch
                cache: true
            }
            // One moving indicator: charge flows toward the battery, discharge moves back.
            Rectangle {
                x: 345; y: 295; width: 6; height: 6; radius: 3
                color: backend.batteryKW >= 0 ? "#10B981" : "#F59E0B"
                visible: !backend.isolated && Math.abs(backend.batteryKW) > 0.01
                opacity: 0.95
                SequentialAnimation on x {
                    running: root.currentView === "main" && !root.settingsOpen && !root.devOpen && !backend.isolated
                    loops: Animation.Infinite
                    NumberAnimation {
                        from: backend.batteryKW >= 0 ? 347 : 432
                        to: backend.batteryKW >= 0 ? 432 : 347
                        duration: 1550
                        easing.type: Easing.InOutSine
                    }
                }
            }
            Text {
                x: 448.77; y: 292.5; width: 58.58; height: 18.0
                text: "BATTERY"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 258.0; y: 318.0; width: 284; height: 39
                source: "assets/slice_829e0a22c095def2.png"
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
                cache: true
            }
            Text {
                x: 272.55; y: 328.0; width: 68.22; height: 15.0
                text: "EFFICIENCY"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 275.56; y: 343.0; width: 62.19; height: 15.0
                text: backend.efficiency.toFixed(1) + "% SiC"
                color: "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 375.91; y: 328.0; width: 56.17; height: 15.0
                text: "AUTONOMY"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 378.91; y: 343.0; width: 50.16; height: 15.0
                text: backend.timeToFull
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 479.27; y: 328.0; width: 44.13; height: 15.0
                text: "DC BUS"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 476.25; y: 343.0; width: 50.16; height: 15.0
                text: backend.busVoltage.toFixed(1) + " V"
                color: "#00D3F3"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 571.0; y: 154.0; width: 210; height: 216
                source: "assets/sprite_78ce7cd28aaba745.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 584.0; y: 168.0; width: 118.86; height: 15.0
                text: "CONTROL ACTUATORS"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 600
                font.letterSpacing: 0.5
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
                font.capitalization: Font.AllUppercase
            }
            Text {
                x: 746.31; y: 167.75; width: 29.69; height: 14.0
                text: "SIM"
                color: "#FFB900"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 584.0; y: 188.75; width: 184; height: 44
                source: click_main_78.pressed ? "assets/slice_8b1b5edb159dba20.png" : ((root.actuator_inverter_boost) ? "assets/slice_b2dcddeaebf96626.png" : "assets/slice_8ab2c6844e99cf45.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Image {
                x: 597.0; y: 206.75; width: 8; height: 8
                source: "assets/sprite_6858657d5b817275.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 613.0; y: 202.75; width: 58.58; height: 18.0
                text: (root.actuator_inverter_boost ? "ACTIVE" : "STANDBY")
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 718.88; y: 204.25; width: 44.13; height: 15.0
                text: backend.boost ? "BOOST" : "ONLINE"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 584.0; y: 240.75; width: 184; height: 44
                source: click_main_82.pressed ? "assets/slice_8b1b5edb159dba20.png" : ((root.actuator_island_isolation) ? "assets/slice_b2dcddeaebf96626.png" : "assets/slice_8ab2c6844e99cf45.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Image {
                x: 597.0; y: 258.75; width: 8; height: 8
                source: "assets/sprite_6c22b2a6f229dfbf.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 613.0; y: 254.75; width: 58.58; height: 18.0
                text: (root.actuator_island_isolation ? "ACTIVE" : "STANDBY")
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 712.84; y: 256.25; width: 50.16; height: 15.0
                text: backend.island ? "ISLANDED" : "GRID"
                color: "#00D3F3"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 584.0; y: 292.75; width: 184; height: 44
                source: click_main_86.pressed ? "assets/slice_8b1b5edb159dba20.png" : ((root.actuator_aux_ev_charge) ? "assets/slice_b2dcddeaebf96626.png" : "assets/slice_8ab2c6844e99cf45.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Image {
                x: 597.0; y: 310.75; width: 8; height: 8
                source: "assets/sprite_b0a38f86c46e2d60.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 613.0; y: 306.75; width: 51.36; height: 18.0
                text: (root.actuator_aux_ev_charge ? "ACTIVE" : "STANDBY")
                color: "#CAD5E2"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 712.84; y: 308.25; width: 50.16; height: 15.0
                text: backend.evCharge ? "CHARGING" : "STANDBY"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 584.0; y: 343.5; width: 100.13; height: 14.0
                text: "DEMO — NO CANBUS"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 686.72; y: 343.5; width: 89.28; height: 14.0
                text: backend.weatherReady ? "WX DATA RECEIVED" : "WX OFFLINE"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 15.0; y: 389.0; width: 770; height: 28
                source: "assets/slice_c95432aaee43aa21.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 28.0; y: 396.5; width: 104.33; height: 15.0
                text: "● SYSTEM NOMINAL"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 132.33; y: 396.5; width: 14.030000000000001; height: 15.0
                text: "|"
                color: "#45556C"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 146.36; y: 396.5; width: 224.75; height: 15.0
                text: backend.isolated ? "Simulation trip active" : "Solar model: " + (backend.weatherSolar ? "weather" : "manual")
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 495.05; y: 396.5; width: 284.95; height: 15.0
                text: "QT 6 DESKTOP // SIMULATED TELEMETRY"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }

















            // Live three-color flow: amber=PV, cyan=DC bus, emerald=battery.
            // Not another separate bitmap for every telemetry value.
            Item {
                x: 348; y: 296; width: 96; height: 6
                Rectangle { x: 0; width: 31; height: 5; radius: 2; color: backend.solarKW > 0 ? "#F59E0B" : "#35445C" }
                Rectangle { x: 32; width: 31; height: 5; radius: 2; color: backend.isolated ? "#35445C" : "#06B6D4" }
                Rectangle { x: 64; width: 31; height: 5; radius: 2; color: backend.batteryKW > 0 ? "#10B981" : "#35445C" }
            }
            MouseArea {
                id: click_main_11
                x: 412.72; y: 8.25; width: 47.53; height: 30.5
                cursorShape: Qt.PointingHandCursor
                onClicked: root.changeMode("eco")
            }
            MouseArea {
                id: click_main_13
                x: 464.25; y: 8.25; width: 83.39; height: 30.5
                cursorShape: Qt.PointingHandCursor
                onClicked: root.changeMode("balanced")
            }
            MouseArea {
                id: click_main_15
                x: 551.64; y: 8.25; width: 54.7; height: 30.5
                cursorShape: Qt.PointingHandCursor
                onClicked: root.changeMode("perf")
            }
            MouseArea {
                id: click_main_78
                x: 584.0; y: 188.75; width: 184.0; height: 44.0
                cursorShape: Qt.PointingHandCursor
                onClicked: backend.setActuator("boost", !backend.boost)
            }
            MouseArea {
                id: click_main_82
                x: 584.0; y: 240.75; width: 184.0; height: 44.0
                cursorShape: Qt.PointingHandCursor
                onClicked: backend.setActuator("island", !backend.island)
            }
            MouseArea {
                id: click_main_86
                x: 584.0; y: 292.75; width: 184.0; height: 44.0
                cursorShape: Qt.PointingHandCursor
                onClicked: backend.setActuator("ev", !backend.evCharge)
            }





        }
        Item {
            visible: root.currentView === "topology"
            anchors.fill: parent
            clip: true
            BorderImage {
                x: 0.0; y: 0.0; width: 800; height: 480
                source: "assets/slice_359b0f433a4b7316.png"
                border.left: 9
                border.right: 9
                border.top: 9
                border.bottom: 9
                cache: true
            }
            BorderImage {
                x: 1.0; y: 1.0; width: 798; height: 46
                source: "assets/slice_5d0b7f7fa0bb4b01.png"
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
                cache: true
            }
            BorderImage {
                x: 17.0; y: 10.5; width: 130.7; height: 26
                source: "assets/slice_7689bd57393136b1.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Image {
                x: 28.0; y: 20.5; width: 6; height: 6
                source: "assets/sprite_24777f95dc4a0046.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 42.0; y: 15.5; width: 70.61; height: 18.0
                text: "HELIOS-9"
                color: "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.6
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 112.61; y: 17.0; width: 32.09; height: 15.0
                text: "v2.4"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 159.7; y: 15.25; width: 14.629999999999999; height: 17.0
                text: "|"
                color: "#45556C"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 174.33; y: 15.25; width: 87.48; height: 17.0
                text: backend.isolated ? "BUS TRIPPED" : (backend.island ? "ISLANDED BUS" : "GRID LINKED")
                color: "#FFB900"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 500
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 261.81; y: 15.25; width: 14.629999999999999; height: 17.0
                text: "•"
                color: "#45556C"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 276.44; y: 15.25; width: 87.48; height: 17.0
                text: backend.isolated ? "0V DC LINK" : "400V DC LINK"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 407.72; y: 3.25; width: 203.63; height: 40.5
                source: "assets/slice_e0dd51f7fc96a562.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 412.72; y: 8.25; width: 47.53; height: 30.5
                source: click_topology_11.pressed ? "assets/slice_ec071827d55d536e.png" : ((root.currentMode === "eco") ? "assets/slice_0f1b1c0a28b30e24.png" : "assets/slice_efb6e64e267ec8c0.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 425.72; y: 15.25; width: 29.53; height: 17.0
                text: "ECO"
                color: (root.currentMode === "eco") ? "#22D3EE" : "#CAD5E2"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.55
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 464.25; y: 8.25; width: 83.39; height: 30.5
                source: click_topology_13.pressed ? "assets/slice_9a254162ff68d63e.png" : ((root.currentMode === "balanced") ? "assets/slice_71437b2ddae35c82.png" : "assets/slice_4e8b116d4a5a5aea.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 477.25; y: 15.25; width: 65.39; height: 17.0
                text: "BALANCED"
                color: (root.currentMode === "balanced") ? "#22D3EE" : "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.55
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 551.64; y: 8.25; width: 54.7; height: 30.5
                source: click_topology_15.pressed ? "assets/slice_9a254162ff68d63e.png" : ((root.currentMode === "perf") ? "assets/slice_71437b2ddae35c82.png" : "assets/slice_4e8b116d4a5a5aea.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 564.64; y: 15.25; width: 36.7; height: 17.0
                text: "PERF"
                color: (root.currentMode === "perf") ? "#22D3EE" : "#CAD5E2"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.55
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 676.39; y: 9.5; width: 70.61; height: 18.0
                text: root.liveClock
                color: "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.6
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 663.14; y: 25.5; width: 83.86; height: 14.0
                text: backend.location.toUpperCase() + " // WX"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 751.0; y: 7.5; width: 32; height: 32
                source: "assets/slice_fbe9b1f18964bf4a.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Image {
                x: 759.0; y: 15.5; width: 16; height: 16
                source: "assets/sprite_1149a20d805005bd.png"
                fillMode: Image.Stretch
                cache: true
            }
            BorderImage {
                x: 1.0; y: 47.0; width: 798; height: 384
                source: "assets/slice_0a3b99e420c61a0b.png"
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
                cache: true
            }
            BorderImage {
                x: 17.0; y: 63.0; width: 766; height: 33
                source: "assets/slice_8b49078bc768edb0.png"
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
                cache: true
            }
            Text {
                x: 17.0; y: 68.0; width: 274.05; height: 18.0
                text: "ENERGY TOPOLOGY DETAILED SCHEMATIC"
                color: "#00D3F3"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.6
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
                font.capitalization: Font.AllUppercase
            }
            Text {
                x: 299.5; y: 70.0; width: 158.52; height: 15.0
                text: "REALTIME VECTOR BALANCING"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 680.7; y: 64.5; width: 102.3; height: 21
                source: "assets/sprite_eaa90d0550710c43.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 689.7; y: 68.5; width: 92.3; height: 15.0
                text: "LOSSES: < 1.2%"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 17.0; y: 104.0; width: 182.5; height: 263
                source: "assets/slice_1a6c05608eb37446.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }


            // Bounded two-line header avoids Chromium-vs-Qt font metric collisions.
            Item {
                x: 30; y: 116; width: 156; height: 43
                Text {
                    x:0; y:0; width:parent.width; height:18
                    text:"1. PHOTOVOLTAIC"; font.family:"JetBrains Mono"; font.pixelSize:11
                    font.bold:true; color:"#FFB900"; elide:Text.ElideRight
                    wrapMode:Text.NoWrap
                }
                Text {
                    x:0; y:21; width:parent.width; height:15
                    text:"MPPT 1+2"; font.family:"JetBrains Mono"; font.pixelSize:9
                    horizontalAlignment:Text.AlignRight; color:"#FFB900"
                    elide:Text.ElideRight; wrapMode:Text.NoWrap
                }
            }
            Text {
                x: 30; y: 206; width: 156; height: 42
                text: Math.round(backend.solarKW*1000).toLocaleString(Qt.locale("en_US"),"f",0)
                color: "#FFFFFF"
                font.family: "JetBrains Mono"
                font.pixelSize: 29.0
                font.weight: 800
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                fontSizeMode: Text.Fit
                minimumPixelSize: 22
                renderType: Text.QtRendering
            }
            Text {
                x: 30; y: 246; width: 156; height: 16
                text: "W"
                color: "#FFB900"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 30.0; y: 254.5; width: 146.48; height: 15.0
                text: "PV INPUT / SOFTWARE MODEL"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 30.0; y: 269.5; width: 140.45; height: 15.0
                text: backend.weatherSolar ? ("Irradiance: " + backend.irradiance.toFixed(0) + " W/m²") : "Manual solar input"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 30.0; y: 348.0; width: 156.5; height: 6
                source: "assets/sprite_91654c82b0ae5860.png"
                fillMode: Image.Stretch
                cache: true
            }
            Image {
                x: 30.0; y: 348.0; width: 125.19; height: 6
                source: "assets/sprite_09293981aedab5da.png"
                fillMode: Image.Stretch
                cache: true
            }
            BorderImage {
                x: 211.5; y: 104.0; width: 182.5; height: 263
                source: "assets/slice_57cb3cf06b37ad71.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }


            // Bounded two-line header avoids Chromium-vs-Qt font metric collisions.
            Item {
                x: 224.5; y: 116; width: 156; height: 43
                Text {
                    x:0; y:0; width:parent.width; height:18
                    text:"2. HYBRID CORE"; font.family:"JetBrains Mono"; font.pixelSize:11
                    font.bold:true; color:"#00D3F3"; elide:Text.ElideRight
                    wrapMode:Text.NoWrap
                }
                Text {
                    x:0; y:21; width:parent.width; height:15
                    text:backend.isolated ? "BUS TRIPPED" : "400V LINK"; font.family:"JetBrains Mono"; font.pixelSize:9
                    horizontalAlignment:Text.AlignRight; color:"#00D3F3"
                    elide:Text.ElideRight; wrapMode:Text.NoWrap
                }
            }
            Text {
                x: 272.64; y: 208.25; width: 68.22; height: 15.0
                text: "Throughput"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
                font.capitalization: Font.AllUppercase
            }
            Text {
                x: 230.5; y: 210; width: 151; height: 42
                text: backend.surplusKW.toFixed(2)
                color: "#FFFFFF"
                font.family: "JetBrains Mono"
                font.pixelSize: 29.0
                font.weight: 800
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                fontSizeMode: Text.Fit
                minimumPixelSize: 22
                renderType: Text.QtRendering
            }
            Text {
                x: 230.5; y: 247; width: 151; height: 16
                text: "kW NET"
                color: "#00D3F3"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 230.5; y: 263.25; width: 152.5; height: 15.0
                text: "Inverter Core Temp: " + (backend.temperature+14).toFixed(1) + "°C"
                color: "#53EAFD"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 224.5; y: 335.5; width: 156.5; height: 18.5
                source: "assets/sprite_fd120a4ad63e33b6.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 224.5; y: 340.5; width: 67.61; height: 14.0
                text: "SiC MOSFETS"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 332.22; y: 340.5; width: 56.78; height: 14.0
                text: backend.efficiency.toFixed(1) + "% EFF"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 406.0; y: 104.0; width: 182.5; height: 263
                source: "assets/slice_b0bcea903cc40575.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }


            // Bounded two-line header avoids Chromium-vs-Qt font metric collisions.
            Item {
                x: 419; y: 116; width: 156; height: 43
                Text {
                    x:0; y:0; width:parent.width; height:18
                    text:"3. LFP BATTERY"; font.family:"JetBrains Mono"; font.pixelSize:11
                    font.bold:true; color:"#00D492"; elide:Text.ElideRight
                    wrapMode:Text.NoWrap
                }
                Text {
                    x:0; y:21; width:parent.width; height:15
                    text:Math.round(backend.soc) + "% SOC"; font.family:"JetBrains Mono"; font.pixelSize:9
                    horizontalAlignment:Text.AlignRight; color:"#00D492"
                    elide:Text.ElideRight; wrapMode:Text.NoWrap
                }
            }
            Text {
                x: 419; y: 195; width: 156; height: 42
                text: (backend.batteryKW>=0 ? "+" : "") + backend.batteryKW.toFixed(2)
                color: "#FFFFFF"
                font.family: "JetBrains Mono"
                font.pixelSize: 29.0
                font.weight: 800
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                fontSizeMode: Text.Fit
                minimumPixelSize: 22
                renderType: Text.QtRendering
            }
            Text {
                x: 419; y: 237; width: 156; height: 16
                text: backend.batteryKW >= 0 ? "kW CHARGE" : "kW DISCHARGE"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 419.0; y: 258.5; width: 122.39; height: 15.0
                text: "Pack Voltage: " + (48 + backend.soc*0.067).toFixed(1) + "V"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 419.0; y: 273.5; width: 128.42000000000002; height: 15.0
                text: "Time to 100%: " + backend.timeToFull
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 419.0; y: 348.0; width: 156.5; height: 6
                source: "assets/sprite_91654c82b0ae5860.png"
                fillMode: Image.Stretch
                cache: true
            }
            Image {
                x: 419.0; y: 348.0; width: 122.06; height: 6
                source: "assets/sprite_f9050db8fbcac18b.png"
                fillMode: Image.Stretch
                cache: true
            }
            BorderImage {
                x: 600.5; y: 104.0; width: 182.5; height: 263
                source: "assets/slice_2e4fc54571a85a5e.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }


            // Bounded two-line header avoids Chromium-vs-Qt font metric collisions.
            Item {
                x: 613.5; y: 116; width: 156; height: 43
                Text {
                    x:0; y:0; width:parent.width; height:18
                    text:"4. AC LOADS"; font.family:"JetBrains Mono"; font.pixelSize:11
                    font.bold:true; color:"#CAD5E2"; elide:Text.ElideRight
                    wrapMode:Text.NoWrap
                }
                Text {
                    x:0; y:21; width:parent.width; height:15
                    text:backend.isolated ? "AC OFF" : "230V 50Hz"; font.family:"JetBrains Mono"; font.pixelSize:9
                    horizontalAlignment:Text.AlignRight; color:"#CAD5E2"
                    elide:Text.ElideRight; wrapMode:Text.NoWrap
                }
            }
            Text {
                x: 613.5; y: 205; width: 156; height: 42
                text: Math.round(backend.loadKW*1000).toString()
                color: "#FFFFFF"
                font.family: "JetBrains Mono"
                font.pixelSize: 29.0
                font.weight: 800
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                fontSizeMode: Text.Fit
                minimumPixelSize: 22
                renderType: Text.QtRendering
            }
            Text {
                x: 613.5; y: 243; width: 156; height: 16
                text: "W"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 613.5; y: 246.5; width: 122.39; height: 15.0
                text: "HVAC / Galley / Aux"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 613.5; y: 261.5; width: 116.38; height: 15.0
                text: "Power Factor: 0.98"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Image {
                x: 613.5; y: 348.0; width: 156.5; height: 6
                source: "assets/sprite_91654c82b0ae5860.png"
                fillMode: Image.Stretch
                cache: true
            }
            Image {
                x: 613.5; y: 348.0; width: 39.13; height: 6
                source: "assets/sprite_1b5890e132223713.png"
                fillMode: Image.Stretch
                cache: true
            }
            BorderImage {
                x: 17.0; y: 375.0; width: 766; height: 40
                source: "assets/slice_c278e08bb689fcb0.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 34.0; y: 387.0; width: 174.17; height: 18.0
                text: "GRID INTERFACE STATUS:"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 200.17; y: 387.0; width: 224.75; height: 18.0
                text: backend.island ? "ISLANDED / GRID DISCONNECTED" : "GRID CONNECTED"
                color: "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 602.72; y: 382.0; width: 163.28; height: 26
                source: click_topology_67.pressed ? "assets/slice_6130b84fb72f0812.png" : ((root.currentView === "main") ? "assets/slice_9b48f99203fc5578.png" : "assets/slice_ee0a7df79e275aee.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 615.72; y: 387.0; width: 145.28; height: 18.0
                text: "← RETURN TO COCKPIT"
                color: (root.currentView === "main") ? "#22D3EE" : "#00D3F3"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }

















            // Native progress layers change continuously; the source image skins remain reused.
            Rectangle {x:30; y:348; width:156.5; height:6; color:"#1B2230"; radius:3
                Rectangle {width:parent.width*Math.min(1,backend.solarKW/7.1);height:6;radius:3;color:"#F59E0B"}}
            Rectangle {x:419; y:348; width:156.5; height:6; color:"#1B2230"; radius:3
                Rectangle {width:parent.width*backend.soc/100;height:6;radius:3;color:"#10B981"}}
            Rectangle {x:613.5; y:348; width:156.5; height:6; color:"#1B2230"; radius:3
                Rectangle {width:parent.width*Math.min(1,backend.loadKW/5.75);height:6;radius:3;color:"#06B6D4"}}
            MouseArea {
                id: click_topology_11
                x: 412.72; y: 8.25; width: 47.53; height: 30.5
                cursorShape: Qt.PointingHandCursor
                onClicked: root.changeMode("eco")
            }
            MouseArea {
                id: click_topology_13
                x: 464.25; y: 8.25; width: 83.39; height: 30.5
                cursorShape: Qt.PointingHandCursor
                onClicked: root.changeMode("balanced")
            }
            MouseArea {
                id: click_topology_15
                x: 551.64; y: 8.25; width: 54.7; height: 30.5
                cursorShape: Qt.PointingHandCursor
                onClicked: root.changeMode("perf")
            }
            MouseArea {
                id: click_topology_67
                x: 602.72; y: 382.0; width: 163.28; height: 26.0
                cursorShape: Qt.PointingHandCursor
                onClicked: root.changePage("main")
            }





        }
        Item {
            visible: root.currentView === "battery"
            anchors.fill: parent
            clip: true
            BorderImage {
                x: 0.0; y: 0.0; width: 800; height: 480
                source: "assets/slice_359b0f433a4b7316.png"
                border.left: 9
                border.right: 9
                border.top: 9
                border.bottom: 9
                cache: true
            }
            BorderImage {
                x: 1.0; y: 1.0; width: 798; height: 46
                source: "assets/slice_5d0b7f7fa0bb4b01.png"
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
                cache: true
            }
            BorderImage {
                x: 17.0; y: 10.5; width: 130.7; height: 26
                source: "assets/slice_7689bd57393136b1.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Image {
                x: 28.0; y: 20.5; width: 6; height: 6
                source: "assets/sprite_24777f95dc4a0046.png"
                fillMode: Image.Stretch
                cache: true
            }
            Text {
                x: 42.0; y: 15.5; width: 70.61; height: 18.0
                text: "HELIOS-9"
                color: "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.6
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 112.61; y: 17.0; width: 32.09; height: 15.0
                text: "v2.4"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 159.7; y: 15.25; width: 14.629999999999999; height: 17.0
                text: "|"
                color: "#45556C"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 174.33; y: 15.25; width: 87.48; height: 17.0
                text: backend.isolated ? "BUS TRIPPED" : (backend.island ? "ISLANDED BUS" : "GRID LINKED")
                color: "#FFB900"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 500
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 261.81; y: 15.25; width: 14.629999999999999; height: 17.0
                text: "•"
                color: "#45556C"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 276.44; y: 15.25; width: 87.48; height: 17.0
                text: backend.isolated ? "0V DC LINK" : "400V DC LINK"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 407.72; y: 3.25; width: 203.63; height: 40.5
                source: "assets/slice_e0dd51f7fc96a562.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 412.72; y: 8.25; width: 47.53; height: 30.5
                source: click_battery_11.pressed ? "assets/slice_ec071827d55d536e.png" : ((root.currentMode === "eco") ? "assets/slice_0f1b1c0a28b30e24.png" : "assets/slice_efb6e64e267ec8c0.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 425.72; y: 15.25; width: 29.53; height: 17.0
                text: "ECO"
                color: (root.currentMode === "eco") ? "#22D3EE" : "#CAD5E2"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.55
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 464.25; y: 8.25; width: 83.39; height: 30.5
                source: click_battery_13.pressed ? "assets/slice_9a254162ff68d63e.png" : ((root.currentMode === "balanced") ? "assets/slice_71437b2ddae35c82.png" : "assets/slice_4e8b116d4a5a5aea.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 477.25; y: 15.25; width: 65.39; height: 17.0
                text: "BALANCED"
                color: (root.currentMode === "balanced") ? "#22D3EE" : "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.55
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 551.64; y: 8.25; width: 54.7; height: 30.5
                source: click_battery_15.pressed ? "assets/slice_9a254162ff68d63e.png" : ((root.currentMode === "perf") ? "assets/slice_71437b2ddae35c82.png" : "assets/slice_4e8b116d4a5a5aea.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 564.64; y: 15.25; width: 36.7; height: 17.0
                text: "PERF"
                color: (root.currentMode === "perf") ? "#22D3EE" : "#CAD5E2"
                font.family: "JetBrains Mono"
                font.pixelSize: 11.0
                font.weight: 700
                font.letterSpacing: 0.55
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 676.39; y: 9.5; width: 70.61; height: 18.0
                text: root.liveClock
                color: "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.6
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 663.14; y: 25.5; width: 83.86; height: 14.0
                text: backend.location.toUpperCase() + " // WX"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 751.0; y: 7.5; width: 32; height: 32
                source: "assets/slice_fbe9b1f18964bf4a.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Image {
                x: 759.0; y: 15.5; width: 16; height: 16
                source: "assets/sprite_1149a20d805005bd.png"
                fillMode: Image.Stretch
                cache: true
            }
            BorderImage {
                x: 1.0; y: 47.0; width: 798; height: 384
                source: "assets/slice_0a3b99e420c61a0b.png"
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
                cache: true
            }
            BorderImage {
                x: 17.0; y: 63.0; width: 766; height: 33
                source: "assets/slice_8b49078bc768edb0.png"
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
                cache: true
            }
            Text {
                x: 17.0; y: 68.0; width: 328.81; height: 18.0
                text: "BATTERY MANAGEMENT SYSTEM (BMS) TELEMETRY"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.6
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
                font.capitalization: Font.AllUppercase
            }
            Text {
                x: 354.27; y: 70.0; width: 182.61; height: 15.0
                text: "16-CELL LFP SERIATION MONITOR"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 573.48; y: 67.0; width: 217.52; height: 18.0
                text: "PACK DELTA: DEMO MODEL"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 17.0; y: 117.72; width: 766; height: 146.5
                source: "assets/slice_faf2047cd8f57c76.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 30.0; y: 131.72; width: 242.81; height: 15.0
                text: "CELL VOLTAGES (SIMULATED / 16 CELLS)"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 637.55; y: 131.72; width: 140.45; height: 15.0
                text: "CYCLE COUNT: DEMO / NOT A SENSOR"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 30.0; y: 153.72; width: 740; height: 80
                source: "assets/slice_de09bab7dcce159a.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 39.0; y: 173.89; width: 41.38; height: 50.83
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 39.0; y: 157.89; width: 27.27; height: 13.0
                text: backend.cellVoltage(0).toFixed(2)
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 8.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 84.38; y: 172.64; width: 41.38; height: 52.08
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 129.75; y: 173.27; width: 41.38; height: 51.45
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 175.13; y: 173.89; width: 41.38; height: 50.83
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 220.5; y: 172.03; width: 41.38; height: 52.69
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 265.88; y: 172.64; width: 41.38; height: 52.08
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 311.25; y: 173.27; width: 41.38; height: 51.45
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 356.63; y: 173.27; width: 41.38; height: 51.45
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 402.0; y: 172.64; width: 41.38; height: 52.08
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 447.38; y: 172.03; width: 41.38; height: 52.69
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 492.75; y: 173.89; width: 41.38; height: 50.83
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 538.13; y: 173.27; width: 41.38; height: 51.45
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 583.5; y: 172.64; width: 41.38; height: 52.08
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 628.88; y: 172.03; width: 41.38; height: 52.69
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 674.25; y: 173.27; width: 41.38; height: 51.45
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            BorderImage {
                x: 719.63; y: 172.64; width: 41.38; height: 52.08
                source: "assets/slice_9245f5cf21d01f50.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 30.0; y: 237.72; width: 45.94; height: 14.0
                text: "CELL #1"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 332.27; y: 237.72; width: 138.05; height: 14.0
                text: "PASSIVE BALANCING ACTIVE"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 726.64; y: 237.72; width: 51.36; height: 14.0
                text: "CELL #16"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 17.0; y: 285.95; width: 247.33; height: 81.33
                source: "assets/slice_f03010fd3f2a8fcc.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 28.0; y: 296.95; width: 104.33; height: 15.0
                text: "THERMAL ENVELOPE"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 28.0; y: 314.28; width: 83.86; height: 25.0
                text: backend.temperature.toFixed(1) + "°C"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 18.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 103.86; y: 320.28; width: 29.69; height: 18.0
                text: "AVG"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 28.0; y: 343.28; width: 165.14; height: 14.0
                text: "COOLING FANS: PASSIVE (0 RPM)"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 276.33; y: 285.95; width: 247.33; height: 81.33
                source: "assets/slice_f03010fd3f2a8fcc.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 287.33; y: 296.95; width: 86.28; height: 15.0
                text: "CURRENT LIMIT"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 287.33; y: 314.28; width: 94.7; height: 25.0
                text: "120.0 A"
                color: "#00D3F3"
                font.family: "JetBrains Mono"
                font.pixelSize: 18.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 374.03; y: 320.28; width: 29.69; height: 18.0
                text: "MAX"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 287.33; y: 343.28; width: 121.8; height: 14.0
                text: "MODELED CURRENT: " + backend.currentAmps.toFixed(1) + " A"
                color: "#90A1B9"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 535.66; y: 285.95; width: 247.33; height: 81.33
                source: "assets/slice_f03010fd3f2a8fcc.png"
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 546.66; y: 296.95; width: 134.44; height: 15.0
                text: "INSULATION RESISTANCE"
                color: "#62748E"
                font.family: "JetBrains Mono"
                font.pixelSize: 10.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 546.66; y: 314.28; width: 94.7; height: 25.0
                text: "> 500 MΩ"
                color: "#E2E8F0"
                font.family: "JetBrains Mono"
                font.pixelSize: 18.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            Text {
                x: 546.66; y: 343.28; width: 116.38; height: 14.0
                text: backend.isolated ? "SIMULATED BUS TRIPPED" : "CHASSIS ISOLATION OK"
                color: "#00D492"
                font.family: "JetBrains Mono"
                font.pixelSize: 9.0
                font.weight: 400
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }
            BorderImage {
                x: 626.17; y: 385.0; width: 156.83; height: 30
                source: click_battery_64.pressed ? "assets/slice_d0dd5272a753372a.png" : ((root.currentView === "main") ? "assets/slice_0f1b1c0a28b30e24.png" : "assets/slice_850fac8c24dc1263.png")
                border.left: 7
                border.right: 7
                border.top: 7
                border.bottom: 7
                cache: true
            }
            Text {
                x: 643.17; y: 392.0; width: 130.82999999999998; height: 18.0
                text: "← BACK TO COCKPIT"
                color: (root.currentView === "main") ? "#22D3EE" : "#00D3F3"
                font.family: "JetBrains Mono"
                font.pixelSize: 12.0
                font.weight: 700
                font.letterSpacing: 0.0
                wrapMode: Text.NoWrap
                renderType: Text.QtRendering
            }

















            Rectangle {
                x: 30; y: 153.72; width: 740; height: 80
                color: "#07090E"; border.color: "#1B2838"; radius: 3
                Row {
                    x: 9; y: 8; spacing: 4
                    Repeater {
                        model: 16
                        Item {
                            width: 41.375; height: 64
                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: Math.max(8, 10 + 51*backend.soc/100 + 2*Math.sin(index*2.5))
                                radius: 2
                                color: backend.soc < 15 ? "#F59E0B" : "#10B981"
                                border.color: "#246C58"
                            }
                            Text {anchors.horizontalCenter: parent.horizontalCenter; y: -6;
                                text: backend.cellVoltage(index).toFixed(2); font.pixelSize:7;
                                color:"#A8BDC8"; font.family:"JetBrains Mono" }
                        }
                    }
                }
            }
            MouseArea {
                id: click_battery_11
                x: 412.72; y: 8.25; width: 47.53; height: 30.5
                cursorShape: Qt.PointingHandCursor
                onClicked: root.changeMode("eco")
            }
            MouseArea {
                id: click_battery_13
                x: 464.25; y: 8.25; width: 83.39; height: 30.5
                cursorShape: Qt.PointingHandCursor
                onClicked: root.changeMode("balanced")
            }
            MouseArea {
                id: click_battery_15
                x: 551.64; y: 8.25; width: 54.7; height: 30.5
                cursorShape: Qt.PointingHandCursor
                onClicked: root.changeMode("perf")
            }
            MouseArea {
                id: click_battery_64
                x: 626.17; y: 385.0; width: 156.83; height: 30.0
                cursorShape: Qt.PointingHandCursor
                onClicked: root.changePage("main")
            }





        }

        Rectangle {
            x:0; y:430; width:800; height:50; color:"#0A0E15"; z:40
            Rectangle {anchors.top:parent.top; width:parent.width; height:1; color:"#1A273A"}
            UiButton {x:12; y:7; width:133; height:36; label:"1. COCKPIT"; active:root.currentView==="main"; onClicked:root.changePage("main")}
            UiButton {x:151; y:7; width:180; height:36; label:"2. FLOW TOPOLOGY"; active:root.currentView==="topology"; onClicked:root.changePage("topology")}
            UiButton {x:337; y:7; width:184; height:36; label:"3. BMS STORAGE ("+Math.round(backend.soc)+"%)"; active:root.currentView==="battery"; onClicked:root.changePage("battery")}
            UiButton {x:527; y:7; width:114; height:36; label:backend.alarmCount > 0 ? "⚠ ALARMS ("+backend.alarmCount+")" : "⚙ SETTINGS"; active:root.settingsOpen; onClicked:{root.settingsOpen=!root.settingsOpen; backend.playTap()}}
            UiButton {x:648; y:7; width:140; height:36;
                label:backend.isolated?"● RESET BUS":"● ISOLATE BUS"
                labelColor:backend.isolated?"#FFBE61":"#FF7B8F"
                onClicked:{if(backend.isolated)root.resetConfirm=true; else root.tripConfirm=true; backend.playTap()}
            }
        }

        Rectangle {
            id: settingsScrim
            x:0; y:0; width:parent.width; height:parent.height
            visible:root.settingsOpen
            z:65; color:"#03060C"; opacity:0.82
            MouseArea { anchors.fill:parent; onClicked:{} }
        }
        Rectangle {
            id: settingsPanel
            visible: root.settingsOpen
            z:75; x:26; y:52; width:748; height:369
            radius:7; color:"#0C121D"; border.width:1; border.color:"#2D4D68"
            MouseArea {anchors.fill:parent; onClicked:{} }
            Rectangle {x:0; y:0; width:parent.width; height:40; color:"#121E2D"; radius:7}
            Text {x:18;y:11;text:"SIMULATION SETTINGS // DIAGNOSTICS"; color:"#E7F0FD"; font.family:"JetBrains Mono"; font.pixelSize:13; font.bold:true}
            UiButton {x:502;y:5;width:112;height:29;label:root.settingsTab==="events"?"CONTROLS":"EVENT LOG";onClicked:root.settingsTab=root.settingsTab==="events"?"controls":"events"}
            UiButton {x:622;y:5;width:112;height:29;label:"× CLOSE";onClicked:root.settingsOpen=false}
            Text {x:18;y:50;text:"POWER CONTROLS";color:"#06B6D4";font.pixelSize:11;font.bold:true;font.family:"JetBrains Mono"}
            Text {x:18;y:72;text:"Load demand";color:"#CBD5E1";font.pixelSize:11;font.family:"JetBrains Mono"}
            Text {x:307;y:72;text:backend.loadSetpoint.toFixed(2)+" kW";color:"#FFFFFF";font.pixelSize:11;font.family:"JetBrains Mono"}
            McuSlider {x:18;y:92;width:340;height:30;from:0.25;to:4.5;stepSize:0.05;value:backend.loadSetpoint;controlledExternally:true;onMoved:val=>backend.setLoadSetpoint(val)}
            Text {x:18;y:130;text:"Solar availability (demo model)";color:"#CBD5E1";font.pixelSize:10;font.family:"JetBrains Mono"}
            Text {x:305;y:130;text:Math.round(backend.solarAvailability)+"%";color:"#F59E0B";font.pixelSize:11;font.family:"JetBrains Mono"}
            McuSlider {x:18;y:150;width:340;height:30;from:0;to:100;stepSize:1;value:backend.solarAvailability;controlledExternally:true;activeColor:"#F59E0B";onMoved:val=>backend.setSolarAvailability(val)}
            Text {x:18;y:187;text:"Battery SOC / draggable dial";color:"#CBD5E1";font.pixelSize:10;font.family:"JetBrains Mono"}
            McuRadialSlider {
                x:22; y:207; width:123; height:123
                from:5; to:100; stepSize:1; value:backend.soc
                controlledExternally:true; accentColor:"#10B981"; strokeWidth:9
                centerText: Math.round(backend.soc) + "%"
                subText: "SOC"
                onMoved: val => backend.setSoc(val)
            }
            Text {x:161;y:212;text:"Simulation speed";color:"#CBD5E1";font.pixelSize:10;font.family:"JetBrains Mono"}
            UiButton {x:158;y:232;width:56;height:31;label:"1×";active:backend.simulationSpeed===1;onClicked:backend.setSimulationSpeed(1)}
            UiButton {x:222;y:232;width:56;height:31;label:"60×";active:backend.simulationSpeed===60;onClicked:backend.setSimulationSpeed(60)}
            UiButton {x:286;y:232;width:66;height:31;label:"600×";active:backend.simulationSpeed===600;onClicked:backend.setSimulationSpeed(600)}
            UiButton {x:158;y:276;width:195;height:35;label:"RESET DEMO VALUES";onClicked:backend.resetDemo()}

            Rectangle {x:372;y:48;width:1;height:305;color:"#2B384B"}
            Text {x:390;y:50;text:"WEATHER / OPEN-METEO";color:"#06B6D4";font.pixelSize:11;font.bold:true;font.family:"JetBrains Mono"}
            Text {x:390;y:74;text:"Location: "+backend.location; color:"#CBD5E1";font.pixelSize:11;font.family:"JetBrains Mono"}
            UiButton {x:390;y:94;width:91;height:31;label:"SVALBARD";active:backend.location==="Svalbard";onClicked:backend.setLocation("Svalbard")}
            UiButton {x:485;y:94;width:89;height:31;label:"OULU";active:backend.location==="Oulu";onClicked:backend.setLocation("Oulu")}
            UiButton {x:578;y:94;width:100;height:31;label:"HELSINKI";active:backend.location==="Helsinki";onClicked:backend.setLocation("Helsinki")}
            Text {x:390;y:132;text:backend.weatherStatus; color:backend.weatherReady?"#10B981":"#F59E0B";font.pixelSize:10;font.family:"JetBrains Mono"}
            Text {x:390;y:150;text:backend.weatherReady?("T "+backend.outsideC.toFixed(1)+"°C   CLOUD "+backend.cloudCover.toFixed(0)+"%   SOLAR "+backend.irradiance.toFixed(0)+" W/m²"):"No weather data / demo model retained";
                color:"#ADBFD4";font.pixelSize:9;font.family:"JetBrains Mono"}
            Text {x:390;y:170;text:"Updated: "+backend.weatherUpdated; color:"#7389A8";font.pixelSize:9;font.family:"JetBrains Mono"}
            UiButton {x:390;y:189;width:150;height:31;label:backend.weatherSolar?"WEATHER SOLAR: ON":"WEATHER SOLAR: OFF";active:backend.weatherSolar;onClicked:backend.setWeatherSolar(!backend.weatherSolar)}
            UiButton {x:546;y:189;width:132;height:31;label:backend.networkBusy?"FETCHING...":"REFRESH WEATHER";onClicked:backend.refreshWeather()}
            Text {x:390;y:232;text:"AUDIO";color:"#06B6D4";font.pixelSize:11;font.bold:true;font.family:"JetBrains Mono"}
            UiButton {x:390;y:251;width:128;height:32;label:backend.soundEnabled?"SOUND: ON":"SOUND: OFF";active:backend.soundEnabled;onClicked:backend.setSoundEnabled(!backend.soundEnabled)}
            Text {x:532;y:255;text:"VOL "+backend.soundVolume+"%"; color:"#D6E6F7";font.pixelSize:11;font.family:"JetBrains Mono"}
            McuSlider {x:525;y:274;width:153;height:24;from:0;to:100;stepSize:5;value:backend.soundVolume;controlledExternally:true;onMoved:val=>backend.setSoundVolume(val)}
            Text {x:390;y:313;text:"Weather data: Open-Meteo.com • CC BY 4.0";color:"#869AB2";font.pixelSize:9;font.family:"JetBrains Mono"}
            Text {x:18;y:344;text:"LOCAL SIMULATION ONLY — no inverter, CAN or contactor hardware is connected";color:"#F59E0B";font.pixelSize:9;font.family:"JetBrains Mono"}
            Rectangle {
                visible:root.settingsTab==="events"; x:10;y:43;width:728;height:296;z:7;radius:4;color:"#0B111B";border.color:"#24384F"
                Text {x:15;y:12;text:"EVENT LOG / ALARMS";color:"#06B6D4";font.pixelSize:12;font.bold:true;font.family:"JetBrains Mono"}
                Text {x:15;y:36;text:backend.alarm.length>0?backend.alarm:"NO ACTIVE ALARMS";
                    color:backend.alarm.length>0?"#FF7F96":"#10B981";font.pixelSize:10;font.family:"JetBrains Mono"}
                Repeater {model:backend.events
                    Text {x:15;y:61+index*16;text:modelData; color:index===0?"#CFDFEF":"#7990AA";
                        font.pixelSize:9;font.family:"JetBrains Mono"}
                }
                UiButton {x:535;y:8;width:174;height:31;label:"ACKNOWLEDGE";onClicked:backend.acknowledgeAlarm()}
            }
        }

        Rectangle {
            visible:root.tripConfirm || root.resetConfirm
            x:0;y:0;width:800;height:480;z:100;color:"#BB02040A"
            MouseArea {anchors.fill:parent; onClicked:{root.tripConfirm=false;root.resetConfirm=false}}
            Rectangle {
                anchors.centerIn:parent; width:522;height:180;radius:8;color:"#1E131D";border.color:"#D44E61";border.width:1
                Text {x:24;y:20;text:root.resetConfirm?"RESET SIMULATED ISOLATION?":"EMERGENCY SIMULATION TRIP";font.family:"JetBrains Mono";font.bold:true;font.pixelSize:17;color:"#FF9AAE"}
                Text {x:24;y:58;width:474;wrapMode:Text.WordWrap;lineHeight:1.3; font.pixelSize:12;color:"#E2E8F0";
                    text:root.resetConfirm?"This resets the simulated bus; no physical contactors are controlled.":"This will disconnect simulated generation and load immediately. No real equipment is connected."}
                UiButton {x:24;y:120;width:192;height:38;label:"CANCEL";onClicked:{root.tripConfirm=false;root.resetConfirm=false}}
                UiButton {x:300;y:120;width:198;height:38;label:root.resetConfirm?"CONFIRM RESET":"CONFIRM ISOLATION";active:true;
                    onClicked:{if(root.resetConfirm)backend.resetTrip();else backend.emergencyTrip();root.tripConfirm=false;root.resetConfirm=false;root.settingsOpen=false}}
            }
        }

    }

    DevMetricsPanel {
        anchors.fill: parent
        z: 210
        visible: root.devOpen
        assetCount: backend.assetCount
        assetSourceBytes: backend.assetSourceBytes
        executableBytes: backend.executableBytes
        releaseZipBytes: backend.releaseZipBytes
        pixelBytes: root.devPixelBytes
        frameBuffers: root.devBuffers
        onPixelBytesChosen: value => root.devPixelBytes = value
        onFrameBuffersChosen: value => root.devBuffers = value
        onDismiss: root.devOpen = false
    }

    // Real bezel inscription (not painted on top of the 800x480 touchscreen).
    Rectangle {x:0; y:0; width:840; height:20; color:"#111722"; z:120}
    Text {x:26; y:4; text:"MCU-INSPIRED // QT 6 DESKTOP"; color:"#697B94"; font.family:"JetBrains Mono"; font.pixelSize:8; font.letterSpacing:1.1; z:121}
    Text {x:301; y:4; text:"HELIOS SYSTEMS  ◈  SANDEEP PARIYAR"; color:"#A1AEC3"; font.family:"JetBrains Mono"; font.pixelSize:9; font.weight:Font.Bold; font.letterSpacing:0.6; z:121}
    Text {x:699; y:4; text:"800 × 480  WVGA"; color:"#697B94"; font.family:"JetBrains Mono"; font.pixelSize:8; z:121}
    Rectangle {x:0; y:500; width:840; height:20; color:"#111722"; z:120}
    Text {x:24; y:505; text:"DESIGNED & DEVELOPED BY SANDEEP PARIYAR"; color:"#667A95"; font.family:"JetBrains Mono"; font.pixelSize:8; z:121}
    Text {x:529; y:505; text:"Qt 6 • SIMULATED SYSTEM"; color:"#667A95"; font.family:"JetBrains Mono"; font.pixelSize:8; z:121}
    Rectangle {
        x:750; y:500; width:86; height:20; z:130
        color: root.devOpen ? "#163448" : "#172232"
        border.color: root.devOpen ? "#35D8E8" : "#2A4054"
        Text {anchors.centerIn:parent; text:"◈ DEV"; font.family:"JetBrains Mono";
              font.pixelSize:9; font.bold:true; color:"#53DAEE"}
        MouseArea {anchors.fill:parent; cursorShape:Qt.PointingHandCursor;
            onClicked:{root.devOpen=!root.devOpen;root.settingsOpen=false;backend.playTap()}}
    }

}
