import QtQuick

// Reuses the same preoptimized nine-slice button assets across all instances.
Item {
    id: control
    property string label: ""
    property bool active: false
    property color labelColor: active ? "#22D3EE" : "#CBD5E1"
    signal clicked()
    BorderImage {
        anchors.fill: parent
        border.left: 7; border.right: 7; border.top: 7; border.bottom: 7
        source: hit.pressed ? "assets/slice_6cd4903169a33037.png" :
                (control.active ? "assets/slice_72cb8de5f543e4cc.png" : "assets/slice_ff666beac64d5b91.png")
    }
    Text {
        anchors.centerIn: parent
        text: control.label
        font.family: "JetBrains Mono"
        font.pixelSize: 10
        font.weight: Font.Bold
        color: control.labelColor
        renderType: Text.QtRendering
    }
    MouseArea {
        id: hit
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: control.clicked()
    }
}
