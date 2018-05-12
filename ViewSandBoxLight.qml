import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import PcControl 1.0

Rectangle {
    Button {
        id: buttonAddTimePoint
        x: 8; y: 8
        text: "添加时间点"
        onClicked: Session.modelSandBoxLight.append({ modelActions: Qt.createQmlObject("import QtQuick 2.10; ListModel{}", Session.modelSandBoxLight)})
    }

    Rectangle {
        color: "lightblue"
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; top: buttonAddTimePoint.bottom; margins: 8 }

        ListView {
            id: listViewSandBoxLight
            anchors { fill: parent; margins: 4 }
            spacing: 1
            clip: true
            model: Session.modelSandBoxLight
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
                            text: "05:24"
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
                        }
                        Button {
                            Layout.alignment: Qt.AlignRight
                            Layout.preferredHeight: 24
                            Layout.preferredWidth: 70
                            text: "添加活动"
                            onClicked: {
                                modelActions.append({})
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
                        columns: Math.floor(width / (220+spacing))
                        Repeater {
                            id: repeater
                            model: modelActions
                            delegate: Rectangle {
                                color: "khaki"
                                height: 32; width: 220
                                Text {
                                    x: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "点亮故宫博物院啊啊"
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
            }
        }
    }
}
