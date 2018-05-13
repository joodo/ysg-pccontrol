import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import PcControl 1.0

Rectangle {
    ColumnLayout {
        anchors { fill: parent; margins: 8 }
        TextEdit {
            id: textEdit
            Layout.fillHeight: true; Layout.fillWidth: true
            text: Session.actionString
            selectByKeyboard: true
            selectByMouse: true
            Rectangle {
                color: "lightblue"
                anchors.fill: parent
                z: -1
            }
        }
        Button {
            text: "更新"
            onClicked: Session.actionString = textEdit.text
        }
    }
}
