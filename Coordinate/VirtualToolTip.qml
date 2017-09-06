import QtQuick 2.1
import QtQuick.Window 2.0

Item {
    id: toolTip

    property alias text: text.text
    property int margin: 4

    width: text.width + margin * 2
    height: text.height + margin * 2

    opacity: 0

    property Item originalParent: parent

    property int oldX: x
    property int oldY: y

    function show() {
        toolTip.originalParent = toolTip.parent;
        var p = toolTip.parent;
        while (p.parent != undefined && p.parent.parent != undefined)
            p = p.parent
        toolTip.parent = p;

        toolTip.oldX = toolTip.x
        toolTip.oldY = toolTip.y
        var globalPos = mapFromItem(toolTip.originalParent, toolTip.oldX, toolTip.oldY);

        toolTip.x = globalPos.x + toolTip.oldX
        toolTip.y = globalPos.y + toolTip.oldY

        toolTip.opacity = 1;
    }

    function hide() {
        toolTip.opacity = 0;
        var oldClip = originalParent.clip
        originalParent.clip = false
        toolTip.parent = originalParent
        originalParent.clip = true
        originalParent.clip = oldClip
        toolTip.x = toolTip.oldX
        toolTip.y = toolTip.oldY
    }

    Rectangle {
        anchors.fill: parent

        border.width: 1
        smooth: true
        radius: 2
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#ffffff";
            }
            GradientStop {
                position: 1.00;
                color: "#e4e5f0";
            }
        }
    }

    Text {
        x: toolTip.margin
        y: toolTip.margin
        id: text
        lineHeight: 1.2
//        font.pixelSize: 16
    }
}
