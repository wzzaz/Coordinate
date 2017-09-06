import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Window 2.1
import QtCharts 2.0

Window {
    id: popup_window
    visible: true
    width: 640
    height: 480
    modality: Qt.WindowModal
//    flags: Qt.Popup

    property bool wheelEnable: false

    /*! flag : { 1: LineView; 2: BarView }
    */
    property int viewFlag: 1

    Window {
        id: tool_tip
        flags: Qt.FramelessWindowHint
        visible: false
        VirtualToolTip {
            id: private_tool_tip
        }
        function show( value, x, y ) {
            private_tool_tip.text = value
            private_tool_tip.show()
            tool_tip.width = private_tool_tip.width
            tool_tip.height = private_tool_tip.height
            tool_tip.x = x + 10 + popup_window.x
            tool_tip.y = y + popup_window.y
            tool_tip.visible = true
            hide_timer.restart()
        }
    }

    Timer {
        id: hide_timer
        interval: 2000
        repeat: false
        running: false
        onTriggered: {
            private_tool_tip.hide()
            tool_tip.visible = false
        }
    }

    Button {
        id: test_func
        text: "Test"
        onClicked: {
            line_view.updateTestUnit()
        }
    }

    Rectangle {
        id: view_rect
        anchors.fill: parent
        anchors.topMargin: 40
        LineChartView {
            id: line_view
            anchors.fill: parent
            visible: viewFlag === 1
            wheelEnable: popup_window.wheelEnable
            onShowToolTip: {
                tool_tip.show( text, x, y )
            }
            Component.onCompleted: {
                line_view.initSeries()
            }
        }

        BarChartView {
            id: bar_view
            anchors.fill: parent
            visible: viewFlag === 2
            Component.onCompleted: {
                addBarSeries( [2, 2, 3, 4, 5, 5], ["2007","2008","2009","2010","2011","2012" ])
            }
        }

        // Add data dynamically to the series
    }
}

