import QtQuick 2.0
import QtCharts 2.0

ChartView {
    id: view
    title: "Bar series"
    anchors.fill: parent
    //@disable-check M17
    legend.visible: false
    antialiasing: true

    function addBarSeries( temperData, axisData ) {
        updateSeries(temperData,axisData)
    }

    function removeBarSeries( temperData, axisData ) {
        updateSeries(temperData,axisData)
    }

    function setSeriesColor( index, newColor ) {
        mySeries.at(index).color = newColor
    }

    function updateSeries( valueData, axisData ) {
        axisX.categories = axisData
        mySeries.clear()
        for( var i = 0; i < valueData.length; ++i ) {
            var values = new Array(i+1)
            for( var j = 0; j < i+1; ++j ) {
                values[j] = 0
            }
            values[i] = valueData[i]
            mySeries.append( "Bob", values )
        }
    }

    ValueAxis {
        id: axisY
        min: 0
        max: 20
    }
    BarCategoryAxis {
        id: axisX
    }

    StackedBarSeries {
        id: mySeries
        axisX: axisX
        axisY: axisY
        labelsFormat: "@value"
        labelsVisible: true
        barWidth: 1
        Component.onCompleted: {
            console.log( "BarSeriesWindow.qml count",count,axisX.count,mySeries.barWidth,view.plotArea.width)
        }
    }
}
