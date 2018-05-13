import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import PcControl 1.0

Rectangle {
    Button {
        id: buttonAddTimePoint
        x: 8; y: 8
        text: "添加时间点"
        onClicked: {
            var data = {}
            data.modelActions = Qt.createQmlObject("import QtQuick 2.10; ListModel{}", Session.modelSandBoxLights)
            data.timePoint = 0
            Session.modelSandBoxLights.append(data)
            listViewSandBoxLight.positionViewAtEnd()
        }
    }

    Rectangle {
        color: "lightblue"
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; top: buttonAddTimePoint.bottom; margins: 8 }

        ListView {
            id: listViewSandBoxLight
            anchors { fill: parent; margins: 4 }
            spacing: 1
            clip: true
            model: Session.modelSandBoxLights
            delegate: Rectangle {
                width: parent.width; height: Math.max(listViewActions.height, columnLabel.height) + 8
                RowLayout {
                    anchors.fill: parent
                    ColumnLayout {
                        id: columnLabel
                        Layout.alignment: Qt.AlignTop
                        Layout.preferredWidth: 100
                        Text {
                            Layout.alignment: Qt.AlignRight
                            text: {
                                var text = ""
                                var m = Math.floor(timePoint / 60)
                                var s = timePoint % 60
                                if (m < 10) text += "0"
                                text += m
                                text += ":"
                                if (s < 10) text += "0"
                                text += s
                                text
                            }
                            font.pointSize: 32
                        }
                        Button {
                            Layout.alignment: Qt.AlignRight
                            Layout.preferredHeight: 24
                            Layout.preferredWidth: 86
                            text: "删除时间点"
                            onClicked: listViewSandBoxLight.model.remove(index)
                        }
                        Button {
                            Layout.alignment: Qt.AlignRight
                            Layout.preferredHeight: 24
                            Layout.preferredWidth: 86
                            text: "修改时间点"
                            onClicked: rectInputMask.visible = true
                        }
                        Button {
                            Layout.alignment: Qt.AlignRight
                            Layout.preferredHeight: 24
                            Layout.preferredWidth: 70
                            text: "添加活动"
                            onClicked: {
                                modelActions.append({ actionIndex: 0 })
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillHeight: true
                        width: 1
                        color: "lightgray"
                    }
                    Grid {
                        id: listViewActions
                        Layout.alignment: Qt.AlignTop
                        Layout.topMargin: 4
                        spacing: 2
                        Layout.fillWidth: true
                        columns: Math.floor((Screen.desktopAvailableWidth-135) / (220+spacing))
                        Repeater {
                            id: repeater
                            model: modelActions
                            delegate: Rectangle {
                                color: "chocolate"
                                height: 32; width: 220
                                ComboBox {
                                    anchors { top: parent.top; bottom: parent.bottom; left: parent.left }
                                    width: 140
                                    textRole: "text"
                                    model: Session.actions
                                    currentIndex: actionIndex
                                    onCurrentIndexChanged: repeater.model.setProperty(index, "actionIndex", currentIndex)
                                }
                                Button {
                                    anchors { top: parent.top; bottom: parent.bottom; right: parent.right }
                                    width: 70
                                    text: "删除活动"
                                    onClicked: repeater.model.remove(index)
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    id: rectInputMask

                    onVisibleChanged: {
                        if (visible) {
                            var m = Math.floor(timePoint / 60)
                            var s = timePoint % 60
                            var text = ""

                            if (m < 10) text += "0"
                            text += m
                            inputMinute.text = text

                            text = ""
                            if (s < 10) text += "0"
                            text += s
                            inputSecond.text = text
                        } else {
                            var t = parseInt(inputMinute.text)*60 + parseInt(inputSecond.text)
                            listViewSandBoxLight.model.setProperty(index, "timePoint", t)
                        }
                    }
                    Component.onCompleted: visible = modelActions.count===0

                    anchors.fill: parent
                    z: 1
                    visible: false
                    Text {
                        anchors.centerIn: parent
                        font.pointSize: 54
                        text: ":"
                    }
                    TextInput {
                        id: inputMinute
                        onFocusChanged: if(focus) selectAll()
                        onTextChanged: if(text.length === 2) inputSecond.focus = true
                        inputMask: "99"
                        anchors { centerIn: parent; horizontalCenterOffset: -48 }
                        font.pointSize: 54
                    }
                    TextInput {
                        id: inputSecond
                        onFocusChanged: if(focus) selectAll()
                        inputMask: "99"
                        anchors { centerIn: parent; horizontalCenterOffset: 48 }
                        font.pointSize: 54
                    }
                    Button {
                        anchors { verticalCenter: parent.verticalCenter; left: inputSecond.right; leftMargin: 24 }
                        text: "确定"
                        onClicked: rectInputMask.visible = false
                    }
                }
            }
        }
    }
}
