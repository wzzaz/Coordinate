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
    Button {
        id: add
        text: "Add"
        onClicked: {
//            var new_serise = chart_view.createSeries( ChartView.SeriesTypeLine, axisX, axisY )
//            new_serise.name = "second_serise"
            for( var i = 0; i < 50; ++i ) {
                series1.replace( i, series1.at(i).y, i, Math.random() )
            }
        }
    }

    Rectangle {
        id: view_rect
        anchors.fill: parent
        anchors.topMargin: 40
        ChartView {
            id: view
            visible: true
            title: "Two Series, Common Axes"
            anchors.fill: parent
            //@disable-check M17
            legend.visible: false
            antialiasing: true
            property point hoveredPoint: Qt.point( 0, 0 )
            property bool hovered: false
            property LineSeries seriesOne

            ValueAxis {
                id: axisX
                min: 0
                max: 50
                tickCount: 5
            }

            ValueAxis {
                id: axisY
                min: -0.5
                max: 1.5
            }

            LineSeries {
                id: series1
                axisX: axisX
                axisY: axisY
                pointsVisible: true
                pointLabelsFormat: "(@xPoint, @yPoint)"
                onHovered: {
                    console.log("Point-=",point,state)
                }
            }
            LineSeries {
                id: series2
                axisX: axisX
                axisY: axisY
                pointsVisible: true
                onHovered: {
                    console.log( "Hovered Point=",view.mapToPosition(point,series2))
                    tool_tip.x = view.mapToPosition(point,series2).x
                    tool_tip.y = view.mapToPosition(point,series2).y
                }
            }
            LineSeries {
                id: series3
                axisX: axisX
                axisY: axisY
            }

            Rectangle {
                id: scrollRect
                width: view.plotArea.width
                height: 20
                x: view.plotArea.x
                y: view.plotArea.y + view.plotArea.height - 20
                border.color: "black"
                border.width: 2
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                property bool insideNonius
                onPositionChanged: {
                    var point = Qt.point( 0, 0 )
                    point.x = mouse.x
                    point.y = mouse.y
                    var hoveredPoint = view.mapToValue( point, series1 )
//                    console.log( view.mapToValue( point, series3 ),series3.at(0),series3.at(1),series3.at(2))
                    if( hoveredPoint.x >= 0 && hoveredPoint.x <= 50 ) {
                        view.hovered = true
                        view.hoveredPoint = hoveredPoint
                    } else {
                        view.hovered = false
                    }

                    var x = series3.at(0).x
                    if( hoveredPoint.x >= x-5 && hoveredPoint.x < x+5 ) {
                        insideNonius = true
                        cursorShape = Qt.OpenHandCursor
                    } else {
                        insideNonius = false
                        cursorShape = Qt.ArrowCursor
                    }

                    if( pressed && insideNonius ) {
                        series3.replace( series3.at(0).x, series3.at(0).y,hoveredPoint.x, series3.at(0).y )
                        series3.replace( series3.at(1).x, series3.at(1).y,hoveredPoint.x, series3.at(1).y )
                        tool_tip.x = view.mapToPosition(series2.at(hoveredPoint.x),series2).x + 10
                        tool_tip.y = view.mapToPosition(series2.at(hoveredPoint.x),series2).y
                        x_text.text = "X:" + series2.at(hoveredPoint.x).x.toFixed(2)
                        y_text.text = "Y:" + series2.at(hoveredPoint.x).y.toFixed(2)
                    }
                }
                Rectangle {
                    id: tool_tip
                    width: 40
                    height: 40
                    border.color: series2.color
                    border.width: 1
                    color: "white"
                    z: 11
                    Text {
                        id: x_text
                        anchors.left: parent.left
                        anchors.leftMargin: 2
                        anchors.top: parent.top
                        anchors.topMargin: 2
                    }
                    Text {
                        id: y_text
                        anchors.left: parent.left
                        anchors.leftMargin: 2
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 2
                    }
                }

                onWheel: {
                    if( view.hovered ) {
                        if( wheel.angleDelta.y > 0 ) {
                            if( axisX.max - axisX.min <= 2 ) {
                                return
                            }
                            view.zoomIn( view.hoveredPoint )
                        } else {
                            view.zoomOut( view.hoveredPoint )
                            if( axisX.min <= 0 ) {
                                axisX.min = 0
                            }
                            if( axisX.max >= 50 ) {
                                axisX.max = 50
                            }
                        }
                    }
                }
            }

            function zoomIn( hoveredPoint ) {
                if( hoveredPoint.x - axisX.min <= 1 ) {
                    return
                }
                var scale = parseFloat( ( hoveredPoint.x - axisX.min ) / ( axisX.max - axisX.min ) )
                axisX.min++
                axisX.max = ( hoveredPoint.x - axisX.min ) / scale + axisX.min
            }

            function zoomOut( hoveredPoint ) {
                var scale = parseFloat( ( hoveredPoint.x - axisX.min ) / ( axisX.max - axisX.min ) )
                axisX.min--
                axisX.max = ( hoveredPoint.x - axisX.min ) / scale + axisX.min
            }
        }

        // Add data dynamically to the series
        Component.onCompleted: {
            for (var i = 0; i <= 50; i++) {
                series1.append(i, Math.random());
                series2.append(i, Math.random());
            }
            series3.append( 25, -10 )
            series3.append( 25, 50 )
        }
    }
}

