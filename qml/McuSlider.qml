import QtQuick

// Custom Qt 6 range slider for embedded-style interfaces. Native text labels live outside this component.
// Background and thumb may use the auto-extracted, preoptimized PNG sprites.
Item {
    id: root
    width: 240
    height: 40
    property real from: 0
    property real to: 100
    property real value: 0
    property real stepSize: 1
    property bool controlledExternally: false
    property bool live: true
    property url trackSource: ""
    property url fillSource: ""
    property url thumbSource: ""
    property color baseColor: "#24334A"
    property color activeColor: "#06B6D4"
    property real thumbDiameter: 22
    signal moved(real value)
    readonly property real progress: Math.max(0, Math.min(1, (value-from) / Math.max(0.00001, to-from)))

    function setFromPointer(pointerX) {
        const p=Math.max(0,Math.min(1,(pointerX-thumbDiameter/2)/Math.max(1,width-thumbDiameter)));
        const proposed=from+(to-from)*p;
        const snapped=stepSize>0 ? from+Math.round((proposed-from)/stepSize)*stepSize : proposed;
        const target=Math.max(from,Math.min(to,snapped));
        if (!controlledExternally) value=target;
        moved(target);
    }

    Rectangle {
        x: root.thumbDiameter/2
        width: root.width-root.thumbDiameter
        height: 6
        radius: 3
        anchors.verticalCenter: parent.verticalCenter
        color: root.baseColor
    }
    Image {
        anchors.fill: parent
        source: root.trackSource
        visible: root.trackSource.toString().length > 0
        fillMode: Image.Stretch
    }
    Rectangle {
        x: root.thumbDiameter/2
        width: (root.width-root.thumbDiameter)*root.progress
        height: 6
        radius: 3
        anchors.verticalCenter: parent.verticalCenter
        color: root.activeColor
    }
    Image {
        x: root.thumbDiameter/2
        y: (root.height-height)/2
        width: (root.width-root.thumbDiameter)*root.progress
        height: 6
        source: root.fillSource
        visible: root.fillSource.toString().length > 0
        fillMode: Image.Stretch
    }
    Rectangle {
        x: (root.width-root.thumbDiameter)*root.progress
        anchors.verticalCenter: parent.verticalCenter
        width: root.thumbDiameter
        height: root.thumbDiameter
        radius: root.thumbDiameter/2
        color: "#FFFFFF"
        border.color: root.activeColor
        visible: root.thumbSource.toString().length === 0
    }
    Image {
        x: (root.width-root.thumbDiameter)*root.progress
        anchors.verticalCenter: parent.verticalCenter
        width: root.thumbDiameter
        height: root.thumbDiameter
        source: root.thumbSource
        visible: root.thumbSource.toString().length > 0
        fillMode: Image.PreserveAspectFit
    }
    MouseArea {
        anchors.fill: parent
        preventStealing: true
        onPressed: mouse => root.setFromPointer(mouse.x)
        onPositionChanged: mouse => { if(pressed && root.live) root.setFromPointer(mouse.x) }
        onReleased: mouse => root.setFromPointer(mouse.x)
    }
}
