import QtQuick 2.0
import QtCharts 2.0
import QtQml 2.2

ChartView {
    id: view
    visible: true
    title: "Two Series, Common Axes"
    anchors.fill: parent
    //@disable-check M17
    legend.visible: false
    antialiasing: true

    property bool wheelEnable
    property double originalAxisMinX: 0
    property double originalAxisMaxX: 50

    /*! \internal */
    property point hoveredPoint: Qt.point( 0, 0 )
    /*! \internal */
    property bool hovered: false
    /*! \internal */
    property LineSeries seriesOne
    /*! \internal */
    property var initLineColor: ["#8b0000", "#8b8b00", "#0b86b8", "#a9a9a9", "#006400", "#6bb7bd", "#8b008b", "#2f6b55", "#008cff", "#cc3299"]

    signal showToolTip(string text, double x, double y)

    /* \test function
      */
    function initSeries() {
        for (var i = 0; i <= 50; i++) {
            series1.append(i, Math.random());
            series2.append(i, Math.random());
            right_series.append(i, Math.random())
        }
        nonius_series.append( 25, -10 )
        nonius_series.append( 25, 50 )
    }

    function randomData() {
        var data = new Array
        for (var i = 0; i <= 50; i++) {
            var newPoint = Qt.point(i, Math.random())
            data.push(newPoint)
        }
        return data
    }

    /* \test function
      */
    function updateTestUnit() {
        var count = view.count
        var seriesArray = new Array
        for( var i = 2; i < count; ++i ) {
            var series = view.series(i)
            var name = series.name
            var seriesColor = series.color
            console.log("updateTestUnit()",seriesColor,name,i)

            var seriesObject = new Object
            seriesObject.name = name
            seriesObject.color = seriesColor
            seriesArray.push(seriesObject)
        }
        for( var j = 0; j < seriesArray.length; ++j ) {
            var data = randomData()
            removeLineSeries(seriesArray[j].name)
            addLineSeries(data,seriesArray[j].name)
            setSeriesColor(seriesArray[j].name,seriesArray[j].color)
        }
    }

    function setXAxis( min, max ) {
        axisX.min = min
        axisX.max = max
    }
    function setYAxis( min, max ) {
        axisY.min = min
        axisY.max = max
    }
    function addLineSeries( temperData, name ) {
        var newSeries = view.createSeries( ChartView.SeriesTypeLine, name, axisX, axisY )
        newSeries.pointsVisible = true
        newSeries.color = initLineColor[view.count%10]
        for( var i = 0; i < temperData.length; ++i ) {
            newSeries.append( temperData[i].x.toFixed(0), temperData[i].y.toFixed(1) )
        }
        //line_view_model.append( {"name":name, "line_color": initLineColor[view.count%10] } )
    }

    function updateLineValue(name,values) {
        var series = view.series( name )
        series.removePoints(0, series.count)
        for( var i = 0; i < values.length; ++i ) {
            series.append( values[i].x.toFixed(0), values[i].y.toFixed(1) )
        }
    }

    function addExtraLineSeries( temperData, name ) {
        for( var i = 0; i < temperData.length; ++i ) {
            right_series.append( temperData[i].x.toFixed(0), temperData[i].y.toFixed(1) )
        }
        right_series.visible = true
    }

    function removeLineSeries( name ) {
        var removedSeries = view.series( name )
        if( removedSeries ) {
            view.removeSeries( removedSeries )
        }
    }
    function setSeriesName( name, newName ) {
        if( !view.series( name ) ) {
            console.log( "setSeriesName err",name )
            return
        }
        view.series( name ).name = newName
    }
    function setSeriesColor( name, newColor ) {
        view.series( name ).color = newColor
    }
    function setSeriesShow( name, show ) {
        view.series( name ).visible = show
    }
    function clearSeries() {
        view.removeAllSeries()
    }
    function computeAxisValue() {
        if( view.count <= 2 ) {
            return
        }

        var max = view.series(2).at(0).y
        var min = view.series(2).at(0).y
        console.log("computeAxisValue max=",max,"min=",min,view.count,view.series(view.count-1).at(0))
        for( var i = 2; i < view.count; ++i ) {
            var series = view.series(i)
            for( var j = 0; j < series.count && series.visible; ++j ) {
                var point = series.at(j).y
                if( point === 0 ) console.log( j )
                if( point > max ) {
                    max = point;
                }
                if( point < min ) {
                    min = point
                }
            }
        }
        var value_width = parseFloat( (max - min) * 0.1 )
        if( value_width === 0 ) {
            value_width = max * 0.1
        }
        if( max === 0 && min === 0 ) {
            axisY.min = -1
            axisY.max = 1
        } else {
            axisY.min = min - value_width
            axisY.max = max + value_width
        }
        if( right_series.visible ) {
            max = view.series(1).at(0).y
            min = view.series(1).at(0).y
            series = view.series(1)
            for( j = 0; j < series.count && series.visible; ++j ) {
                point = series.at(j).y
                if( point === 0 ) console.log( j )
                if( point > max ) {
                    max = point;
                }
                if( point < min ) {
                    min = point
                }
            }
            value_width = parseFloat( (max - min) * 0.1 )
            if( value_width === 0 ) {
                value_width = max * 0.1
            }
            if( max === 0 && min === 0 ) {
                axisY_right.min = -1
                axisY_right.max = 1
            } else {
                axisY_right.min = min - value_width
                axisY_right.max = max + value_width
            }
        }
    }
    function setNonius( x ) {
        nonius_series.replace( nonius_series.at(0).x, nonius_series.at(0).y,
                                               x, nonius_series.at(0).y)
        nonius_series.replace( nonius_series.at(1).x, nonius_series.at(1).y,
                                               x, nonius_series.at(1).y)
    }

    ValueAxis {
        id: axisX
        min: 0
        max: 50
        tickCount: 5
        function scrollAxisXValue() {
            axisX.min = scrollButton.x * ( view.originalAxisMaxX - view.originalAxisMinX ) / scrollRect.width
            axisX.max = (scrollButton.x + scrollButton.width) * ( view.originalAxisMaxX - view.originalAxisMinX ) / scrollRect.width
        }
    }

    ValueAxis {
        id: axisY
        min: -0.5
        max: 1.5
    }

    ValueAxis {
        id: axisY_right
        min: -0.5
        max: 1.5
        titleText: " "
        gridVisible: false
        visible: right_series.visible
    }
    LineSeries {
        id: nonius_series
        axisX: axisX
        axisY: axisY
        name: "Nonius"
    }
    LineSeries {
        id: right_series
        width: 1
        axisX: axisX
        axisYRight: axisY_right
        pointsVisible: true
        color: "purple"
        visible: true
        style: Qt.DashDotLine
        name: qsTr("Load Current")
    }

    LineSeries {
        id: series1
        axisX: axisX
        axisY: axisY
        pointsVisible: true
        pointLabelsFormat: "(@xPoint, @yPoint)"
        name: "Series1"
        onHovered: {
            console.log("Point-=",point,state)
        }
    }
    LineSeries {
        id: series2
        axisX: axisX
        axisY: axisY
        pointsVisible: true
        name: "Series2"
        onHovered: {
            console.log( "Hovered Point=",view.mapToPosition(point,series2))
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        property bool insideNonius
        onPositionChanged: {
            var series
            if( view.count > 2 ) {
                series = view.series(2)
            }

            var point = Qt.point( 0, 0 )
            point.x = mouse.x
            point.y = mouse.y
            var hoveredPoint = view.mapToValue( point, series )
            if( hoveredPoint.x >= 0 && hoveredPoint.x <= 50 ) {
                view.hovered = true
                view.hoveredPoint = hoveredPoint
            } else {
                view.hovered = false
            }

            var x = nonius_series.at(0).x
            if( hoveredPoint.x >= x-5 && hoveredPoint.x < x+5 ) {
                insideNonius = true
                cursorShape = Qt.OpenHandCursor
            } else {
                insideNonius = false
                cursorShape = Qt.ArrowCursor
            }

            if( pressed && insideNonius ) {
                nonius_series.replace( nonius_series.at(0).x, nonius_series.at(0).y,hoveredPoint.x, nonius_series.at(0).y )
                nonius_series.replace( nonius_series.at(1).x, nonius_series.at(1).y,hoveredPoint.x, nonius_series.at(1).y )
                var show_text = "X:" + series.at(hoveredPoint.x).x.toFixed(2) + "\n" + "Y:" + series.at(hoveredPoint.x).y.toFixed(2)
                showToolTip(show_text, view.mapToPosition(series.at(hoveredPoint.x),series).x, view.mapToPosition(series.at(hoveredPoint.x),series).y )
            }
        }

        onWheel: {
            if( !wheelEnable ) {
                return
            }

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
                scrollRect.scrollSizeUpdate()
            }
        }
    }

    Rectangle {
        id: scrollRect
        width: view.plotArea.width
        height: 20
        x: view.plotArea.x
        y: view.plotArea.y + view.plotArea.height - 20
        border.color: "black"
        border.width: 1
        visible: wheelEnable
        Rectangle {
            id: scrollButton
            anchors.verticalCenter: parent.verticalCenter
            height: 18
            color: "green"
            MouseArea {
                anchors.fill: parent
                drag.target: parent
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: scrollRect.width - scrollButton.width
                onPositionChanged: {
                    axisX.scrollAxisXValue()
                }
            }
        }
        function scrollSizeUpdate() {
            scrollButton.x = scrollRect.width * axisX.min / (view.originalAxisMaxX - view.originalAxisMinX)
            scrollButton.width = (axisX.max - axisX.min) * scrollRect.width / (view.originalAxisMaxX - view.originalAxisMinX)
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
