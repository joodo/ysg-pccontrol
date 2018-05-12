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

        Text { text: "A 视频"; font.bold: true; }
        Button {
            text: Session.videoPath[0]
            onClicked: fileDialogVideoPath.selectVideoPath(0)
        }
        Text { text: "B 视频"; font.bold: true; }
        Button {
            text: Session.videoPath[1]
            onClicked: fileDialogVideoPath.selectVideoPath(1)
        }
        Text { text: "幻灯片视频"; font.bold: true; }
        Button {
            text: Session.videoPath[2]
            onClicked: fileDialogVideoPath.selectVideoPath(2)
        }
        Item { width: 1; height: 1 }
        Item { width: 1; height: 1; Layout.fillWidth: true }

        FileDialog {
            id: fileDialogVideoPath

            property int index
            function selectVideoPath(videoIndex) {
                index = videoIndex
                visible = true
            }

            title: "请选择视频文件"
            folder: shortcuts.home
            onAccepted: {
                Session.videoPath[index] = fileUrl + ""
                Session.videoPath = Session.videoPath
            }
        }
    }
}
