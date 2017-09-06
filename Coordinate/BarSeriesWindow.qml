import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Window 2.1
import QtCharts 2.0

Window {
    id: barwindow
    visible: true
    width: 640
    height: 480
    modality: Qt.WindowModal

    Rectangle {
        id: view_rect
        anchors.fill: parent
        anchors.topMargin: 40
        ChartView {
            id: view
            title: "Bar series"
            anchors.fill: parent
            legend.visible: false
            antialiasing: true

            ValueAxis {
                id: axisY
                min: 0
                max: 20
            }
            BarCategoryAxis {
                id: axisX
                categories: ["2007","2008","2009","2010","2011","2012" ]
            }

            BarSeries {
                id: mySeries
                axisX: axisX
                axisY: axisY
                labelsFormat: "@value"
                labelsVisible: true
                barWidth: 1
                BarSet {
                    label: "Bob";
                    values: [2, 2, 3, 4, 5, 6]
                }
//                BarSet { label: "Susan"; values: [5, 1, 2, 4, 1, 7] }
//                BarSet { label: "James"; values: [3, 5, 8, 13, 5, 8] }
                Component.onCompleted: {
                    console.log( "BarSeriesWindow.qml count",count,axisX.count,mySeries.barWidth,view.plotArea.width)
                }
            }
        }

        // Add data dynamically to the series
        Component.onCompleted: {

        }
    }
}

