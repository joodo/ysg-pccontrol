import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

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
            text: "fdsafsadfdsafsad"
            Layout.fillWidth: true
        }
        Text { text: "B 视频"; font.bold: true; }
        Button {
            text: "fdsafsadfdsafsad"
        }
        Text { text: "幻灯片视频"; font.bold: true; }
        Button {
            text: "fdsafsadfdsafsad"
        }
    }
}
