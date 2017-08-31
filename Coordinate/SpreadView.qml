import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: view_rect
//    anchors.right: parent.right
//    anchors.top: parent.top
//    anchors.bottom: parent.bottom
//    width: 300
//    color: "#ebebeb"
//    clip: true

    ScrollView {
        anchors.fill: parent
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        Rectangle {
            id: view_background
            anchors.top: parent.top
            anchors.left: parent.left
            width: 300
            height: view_rect.height
            color: "#006c76"
            clip: true
            function updateHeight() {
                var total_height = 0
                for( var i = 0; i < main_view.count; ++i ) {
                    main_view.currentIndex = i
                    var crt_view = main_view.currentItem
                    if( crt_view ) {
                        total_height += crt_view.height
                    }
                }
                height = total_height
            }
            ListView {
                id: main_view
                anchors.fill: parent
                boundsBehavior: Flickable.StopAtBounds
                delegate: main_view_delegate
                model: view_model
                Component.onCompleted: {
                    view_background.updateHeight()
                }
                onCountChanged: {
                    view_background.updateHeight()
                }
            }
        }
    }
    ListModel {
        id: view_model
        ListElement {
            titleName: "Query"
        }
        ListElement {
            titleName: "Number"
        }
        ListElement {
            titleName: "Time"
        }
        ListElement {
            titleName: "Name"
        }
        ListElement {
            titleName: "Kind"
        }
        ListElement {
            titleName: "Cool"
        }
        ListElement {
            titleName: "Home"
        }
        ListElement {
            titleName: "Shift"
        }
        ListElement {
            titleName: "Enter"
        }
        ListElement {
            titleName: "Ctrl"
        }
    }
    Component {
        id: main_view_delegate
        Item {
            id: wrapper
            width: parent.width
            height: spread ? 24 * (sub_model.count + 1) : 24
            property bool spread: false
            clip: true
            onHeightChanged: {
                view_background.updateHeight()
            }

            Rectangle {
                id: background
                anchors.fill: parent
                width: parent.width
                height: parent.height
                color: "#006c76"
                property var colorDlg: null
                Button {
                    id: spread_btn
                    width: 18
                    height: 18
                    text: wrapper.spread ? "-" : "+"
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    anchors.left: parent.left
                    anchors.leftMargin: 3
                    onClicked: {
                        wrapper.spread = !wrapper.spread
                    }
                }
                Text {
                    id: title
                    anchors.verticalCenter: spread_btn.verticalCenter
                    anchors.left: spread_btn.right
                    anchors.leftMargin: 5
                    color: "white"
                    text: titleName
                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: spread_btn.bottom
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 20
                    anchors.topMargin: 3
                    color: "#ebebeb"
                    ListView {
                        id: sub_view
                        anchors.fill: parent
                        model: sub_model
                        delegate: sub_view_delegate
                    }
                    ListModel {
                        id: sub_model
                        ListElement {
                            headName: "Color"
                            realValue: "red"
                        }
                        ListElement {
                            headName: "Setting Mode"
                            realValue: "Auto"
                        }
                    }

                    Component {
                        id: sub_view_delegate
                        Item {
                            id: wrapper
                            width: parent.width
                            height: 24
                            Rectangle {
                                id: sub_background
                                anchors.fill: parent
                                color: "#ebebeb"
                                Text {
                                    id: head_name
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 5
                                    text: headName
                                }
                                Rectangle {
                                    id: row_trans
                                    height: parent.height
                                    width: 1
                                    color: "#006c76"
                                    anchors.left: parent.left
                                    anchors.leftMargin: 80
                                }
                                Rectangle {
                                    id: color_area
                                    visible: index === 0
                                    width: 20
                                    height: 20
                                    color: String( realValue )
                                    border.color: "black"
                                    border.width: 1
                                    anchors.left: row_trans.right
                                    anchors.leftMargin: 5
                                    anchors.verticalCenter: parent.verticalCenter
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            sub_background.selectionColor()
                                        }
                                    }
                                }
                                Button {
                                    id: show_window
                                    visible: index === 0
                                    width: 50
                                    height: 24
                                    text: "Show"
                                    anchors.left: color_area.right
                                    anchors.leftMargin: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    onClicked: {
                                        popup_win.visible = true
                                    }
                                }

                                ComboBox {
                                    id: setting_combobox
                                    width: 200
                                    height: 24
                                    anchors.left: row_trans.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: index === 1
                                    model: ListModel {
                                        ListElement {
                                            text: "Auto"
                                        }
                                        ListElement {
                                            text: "Manual"
                                        }
                                    }
                                    onCurrentIndexChanged: {
                                        if(  currentText === "Manual" ) {
                                            sub_model.append( {"headName": "Max", "realValue": "10" } )
                                            sub_model.append( {"headName": "Min", "realValue": "0" } )
                                        } else if( currentText === "Auto" ) {
                                            if( sub_model.count > 2 ) {
                                                sub_model.remove( 2, 2 )
                                            }
                                        }
                                    }
                                }
                                Text {
                                    id: real_value
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: row_trans.right
                                    anchors.leftMargin: 5
                                    text: realValue
                                    visible: index > 1
                                }

                                Rectangle {
                                    id: bottom_trans
                                    height: 1
                                    width: parent.width
                                    color: "#006c76"
                                    anchors.bottom: parent.bottom
                                }
                                function selectionColor() {
                                    if( background.colorDlg === null ) {
                                        background.colorDlg = Qt.createQmlObject(
                                                    'import QtQuick 2.2;import QtQuick.Dialogs 1.1;ColorDialog{}',
                                                    background, "colorDlg");
                                        background.colorDlg.accepted.connect(setColor);
                                        background.colorDlg.accepted.connect(onColorDlgClosed);
                                        background.colorDlg.rejected.connect(onColorDlgClosed);
                                        background.colorDlg.visible = true
                                    }
                                }

                                function setColor() {
                                    sub_model.setProperty( 0, "realValue", String(background.colorDlg.color) )
                                }

                                function onColorDlgClosed() {
                                    background.colorDlg.destroy()
                                    background.colorDlg = null
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    PopupWindow {
        id: popup_win
        visible: false
    }
    BarSeriesWindow {
        id: barseries_win
        visible: false
    }
}

