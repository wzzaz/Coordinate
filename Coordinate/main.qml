import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import CurveItem 1.0

Window {
    id: main_window
    visible: true
    width: 800
    height: 400

    function xAxis_pos_to_point( pos ) {
        return curve.xAxis_pos_to_point( pos )
    }

    function xAxis_point_to_pos( point ) {
        return curve.xAxis_value_to_pos( point )
    }

    CurveItem {
        id: curve
        width: 500
        height: 400
        xAxisWidth: 500
        yAxisHeight: 400
        itemWidth: width
        onXChanged: {
            console.log( "CurveItem x=",x )
        }
        onWidthChanged: {
            console.log( "CurveItem width=", width )
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            drag.axis: Drag.XAxis
            drag.minimumX: parent.xAxisWidth - parent.width
            drag.maximumX: 0

            onWheel: {
                var hovered_point, change_pos, moved_pos
                var init_item_width = curve.width
                var init_item_x = curve.x
                if( wheel.angleDelta.y > 0 ) {
                    init_item_width += 500
                    if( init_item_width <= curve.xAxisWidth * 10 ) {
                        hovered_point = xAxis_pos_to_point( wheel.x )
                        curve.width = init_item_width

                        change_pos = xAxis_point_to_pos( hovered_point )
                        moved_pos = change_pos - wheel.x

                        curve.x -= moved_pos
                        console.log("onWheel moved_pos=", moved_pos, "curve.x=", curve.x , "hovered_point=",hovered_point, "change_pos=",change_pos )
                    }
                } else {
                    init_item_width -= 500
                    if( init_item_width >= curve.xAxisWidth ) {
                        hovered_point = xAxis_pos_to_point( wheel.x )
                        curve.width = init_item_width

                        change_pos = xAxis_point_to_pos( hovered_point )
                        moved_pos = change_pos - wheel.x
                        if( curve.x < 0 && curve.x + curve.width > curve.xAxisWidth ) {
                            curve.x -= moved_pos
                        } else if( curve.x + curve.width <= curve.xAxisWidth ) {
                            curve.x = curve.xAxisWidth - curve.width
                        }
                    } else if( init_item_width < 0 ) {
                        hovered_point = xAxis_pos_to_point( wheel.x )
                        curve.width = curve.xAxisWidth

                        change_pos = xAxis_point_to_pos( hovered_point )
                        moved_pos = change_pos - wheel.x
                        if( curve.x < 0 && curve.x + curve.width > curve.xAxisWidth ) {
                            curve.x -= moved_pos
                        } else if( curve.x + curve.width <= curve.xAxisWidth ) {
                            curve.x = curve.xAxisWidth - curve.width
                        }
                    }
                }

                if( curve.x > 0 ) {
                    curve.x = 0
                }
                curve.rePaint()
            }
        }
    }

    ComboBox {
        id: combo
        model: [ " ", "One", "Two","Three" ]
        onCurrentIndexChanged: {
            if( currentText === " " ) {
                radio_btn_one.enabled = true
                radio_btn_two.enabled = true
                radio_btn_one.checked = true
                return
            }
            radio_btn_one.enabled = false
            radio_btn_two.enabled = false
            if( currentText === "One" ) {
                radio_btn_one.checked = true
            } else if( currentText === "Two" ) {
                radio_btn_two.checked = true
            } else if( currentText === "Three" ) {
                radio_btn_one.checked = true
            }
        }
    }
    ExclusiveGroup { id: tabPositionGroup }
    RadioButton {
        id: radio_btn_one
        anchors.left: combo.right
        anchors.top: combo.bottom
        checked: true
        text: "One"
        exclusiveGroup: tabPositionGroup
    }
    RadioButton {
        id: radio_btn_two
        anchors.left: combo.right
        anchors.top: radio_btn_one.bottom
        checked: false
        text: "Two"
        exclusiveGroup: tabPositionGroup
    }

    SpreadView {
        id: view_rect
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 300
        color: "#ebebeb"
        clip: true
    }
    Component.onCompleted: {
        curve.rePaint()
    }
}

