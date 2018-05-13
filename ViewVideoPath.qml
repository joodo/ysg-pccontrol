import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.3

import PcControl 1.0

Rectangle {
    GridLayout {
        id: gridLayout
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 8;}
        rowSpacing: 4
        columnSpacing: 8
        columns: 2

        Text { text: "Chrome 位置"; font.bold: true; }
        Button {
            text: Session.chromeUrl
            onClicked: fileDialog.open()
        }
        Item { width: 1; height: 1 }
        Item { width: 1; height: 1; Layout.fillWidth: true }

        FileDialog {
            id: fileDialog
            title: "请选择 Chrome 文件"
            folder: shortcuts.home
            onAccepted: {
                Session.chromeUrl = fileUrl + ""
            }
        }
    }
}
