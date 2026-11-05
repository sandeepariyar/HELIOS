import QtQuick

// Qt 6 desktop arc control. Start/end angles and step map to the control settings.
// Background art can be supplied as an optimized asset; changing value remains dynamic.
Item {
    id: root
    width: 160
    height: 160
    property real from: 0
    property real to: 100
    property real value: 0
    property real stepSize: 1
    property bool controlledExternally: false
    property real startAngle: 135
    property real sweepAngle: 270
    property real strokeWidth: 10
    property color trackColor: "#233447"
    property color accentColor: "#06B6D4"
    property url backgroundSource: ""
    property url handleSource: ""
    property string centerText: ""
    property string subText: ""
    property color centerTextColor: "#E2E8F0"
    property string centerFontFamily: "JetBrains Mono"
    signal moved(real value)
    readonly property real progress: Math.max(0,Math.min(1,(value-from)/Math.max(.00001,to-from)))

    function updateValue(x,y) {
        const raw=Math.atan2(y-height/2,x-width/2)*180/Math.PI;
        const angle=(raw+360)%360;
        const delta=(angle-startAngle+360)%360;
        const clamped=(delta <= sweepAngle ? delta : (delta > sweepAngle+(360-sweepAngle)/2 ? 0 : sweepAngle));
        const val=from+(to-from)*clamped/Math.max(0.00001,sweepAngle);
        const snapped=stepSize>0 ? from+Math.round((val-from)/stepSize)*stepSize : val;
        const target=Math.max(from,Math.min(to,snapped));
        if (!controlledExternally) value=target;
        moved(target);
        dial.requestPaint();
    }
    Image {
        anchors.fill: parent
        source: root.backgroundSource
        visible: root.backgroundSource.toString().length>0
        fillMode: Image.PreserveAspectFit
    }
    Canvas {
        id: dial
        anchors.fill: parent
        onPaint: {
            const ctx=getContext('2d');ctx.reset();
            const r=Math.min(width,height)/2-root.strokeWidth;
            const cx=width/2,cy=height/2;
            const start=root.startAngle*Math.PI/180;
            const sweep=root.sweepAngle*Math.PI/180;
            ctx.lineWidth=root.strokeWidth;ctx.lineCap='round';
            ctx.beginPath();ctx.strokeStyle=root.trackColor;
            ctx.arc(cx,cy,r,start,start+sweep,false);ctx.stroke();
            ctx.beginPath();ctx.strokeStyle=root.accentColor;
            ctx.arc(cx,cy,r,start,start+sweep*root.progress,false);ctx.stroke();
        }
    }
    onValueChanged: dial.requestPaint()
    Column {
        id: dialCaption
        anchors.centerIn: parent
        spacing: 1
        visible: root.centerText.length > 0
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.centerText
            color: root.centerTextColor
            font.family: root.centerFontFamily
            font.pixelSize: 19
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.subText
            visible: root.subText.length > 0
            color: "#94AABD"
            font.family: root.centerFontFamily
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
        }
    }
    MouseArea {
        anchors.fill: parent
        preventStealing: true
        onPressed: mouse => root.updateValue(mouse.x,mouse.y)
        onPositionChanged: mouse => {if(pressed)root.updateValue(mouse.x,mouse.y)}
    }
}
