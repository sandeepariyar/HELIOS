import QtQuick

Item {
    id: panel
    property int assetCount: 0
    property double assetSourceBytes: 0
    property double executableBytes: 0
    property double releaseZipBytes: 0
    property int pixelBytes: 2
    property int frameBuffers: 2
    signal pixelBytesChosen(int value)
    signal frameBuffersChosen(int value)
    signal dismiss()
    readonly property double bufferKiB: 800 * 480 * pixelBytes * frameBuffers / 1024
    function sizeText(bytes) {
        if (bytes < 1) return "UNAVAILABLE"
        return bytes >= 1024*1024 ? (bytes/1024/1024).toFixed(2) + " MiB" : (bytes/1024).toFixed(1) + " KiB"
    }
    Rectangle {
        anchors.fill:parent
        color:"#03060A"; opacity:0.90
        MouseArea { anchors.fill:parent; onClicked:panel.dismiss() }
    }
    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 700; height: 436; radius: 9
        color: "#0D1622"; border.width: 1; border.color: "#35627B"
        MouseArea {anchors.fill:parent; onClicked:{}}
        Rectangle {x:0;y:0;width:parent.width;height:44;radius:9;color:"#14283B"}
        Text {x:20;y:13;text:"HELIOS  //  DEVELOPER METRICS";font.family:"JetBrains Mono";
              font.pixelSize:14;font.bold:true;color:"#DDF5FD"}
        UiButton {x:584;y:7;width:102;height:30;label:"× CLOSE";onClicked:panel.dismiss()}
        Rectangle {
            x:18;y:54;width:664;height:95;radius:5;color:"#103029";border.color:"#246C58"
            Text {x:15;y:11;text:"OPTIMIZED RELEASE SOURCE ARCHIVE";font.family:"JetBrains Mono";
                  font.pixelSize:11;font.bold:true;color:"#A9DCCE"}
            Text {x:15;y:32;text:panel.sizeText(panel.releaseZipBytes);font.family:"JetBrains Mono";
                  font.pixelSize:27;font.bold:true;color:"#42E3B1"}
            Text {x:260;y:42;width:380;height:40;wrapMode:Text.WordWrap;
                  text:"Distribution ZIP snapshot. Not the executable, installed Qt runtime or MCU firmware.";
                  font.family:"JetBrains Mono";font.pixelSize:9;color:"#9FB9B0"}
        }
        Rectangle {x:18;y:159;width:213;height:70;radius:5;color:"#152334";border.color:"#293D53"
            Text {x:12;y:10;text:"UNIQUE UI PNGs";color:"#9EB2CE";font.pixelSize:10;font.family:"JetBrains Mono"}
            Text {x:12;y:29;text:String(panel.assetCount);color:"#EEF6FF";font.pixelSize:23;font.bold:true;font.family:"JetBrains Mono"}
        }
        Rectangle {x:242;y:159;width:213;height:70;radius:5;color:"#152334";border.color:"#293D53"
            Text {x:12;y:10;text:"PNG SOURCE BYTES";color:"#9EB2CE";font.pixelSize:10;font.family:"JetBrains Mono"}
            Text {x:12;y:29;text:panel.sizeText(panel.assetSourceBytes);color:"#EEF6FF";font.pixelSize:23;font.bold:true;font.family:"JetBrains Mono"}
        }
        Rectangle {x:466;y:159;width:216;height:70;radius:5;color:"#152334";border.color:"#293D53"
            Text {x:12;y:10;text:"RUNNING .EXE SIZE";color:"#9EB2CE";font.pixelSize:10;font.family:"JetBrains Mono"}
            Text {x:12;y:29;text:panel.sizeText(panel.executableBytes);color:"#EEF6FF";font.pixelSize:23;font.bold:true;font.family:"JetBrains Mono"}
        }
        Text {x:20;y:244;text:"MCU FRAMEBUFFER ESTIMATOR";color:"#55D9E9";
              font.family:"JetBrains Mono";font.bold:true;font.pixelSize:12}
        Text {x:20;y:265;text:"800 × 480, selected pixel depth and buffer count";color:"#94A7C0";
              font.family:"JetBrains Mono";font.pixelSize:9}
        UiButton {x:20;y:289;width:128;height:34;label:"RGB565 / 16-bit";active:panel.pixelBytes===2;onClicked:panel.pixelBytesChosen(2)}
        UiButton {x:153;y:289;width:130;height:34;label:"ARGB8888 / 32";active:panel.pixelBytes===4;onClicked:panel.pixelBytesChosen(4)}
        UiButton {x:293;y:289;width:102;height:34;label:"1 BUFFER";active:panel.frameBuffers===1;onClicked:panel.frameBuffersChosen(1)}
        UiButton {x:400;y:289;width:102;height:34;label:"2 BUFFERS";active:panel.frameBuffers===2;onClicked:panel.frameBuffersChosen(2)}
        Rectangle {x:517;y:281;width:165;height:54;radius:5;color:"#15302E";border.color:"#26766B"
            Text {x:9;y:7;text:"EST. FRAMEBUFFER";color:"#9CBFB9";font.family:"JetBrains Mono";font.pixelSize:9}
            Text {x:9;y:23;text:panel.bufferKiB.toFixed(0)+" KiB";color:"#4BE0BD";font.family:"JetBrains Mono";font.pixelSize:20;font.bold:true}
        }
        Rectangle {x:20;y:351;width:660;height:1;color:"#2B4157"}
        Text {x:20;y:361;width:650;height:33;wrapMode:Text.WordWrap;lineHeight:1.2;
              text:"SIMULATED MEMORY MODEL ONLY. Actual MCU flash, caches, heap, stack, render memory and compiled resources require a specific board and Qt for MCUs build.";
              font.family:"JetBrains Mono";font.pixelSize:9;color:"#A9B8CB"}
        Text {x:20;y:406;text:"DESIGNED & DEVELOPED BY SANDEEP PARIYAR";color:"#668EA8";font.pixelSize:9;font.family:"JetBrains Mono"}
        Text {x:535;y:405;text:"Qt 6 / QML / C++";color:"#668EA8";font.pixelSize:9;font.family:"JetBrains Mono"}
    }
}
