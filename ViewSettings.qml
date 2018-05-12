import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import PcControl 1.0

Rectangle {
    id: viewSettings
    color: "lightblue"
    Component.onCompleted: Session.load()

    TabBar {
        id: tabBar
        TabButton {
            text: "视频路径"
        }
        TabButton {
            text: "沙盘灯光"
        }
    }

    Button {
        id: buttonSaveAndQuit

        onClicked: {
            Session.save()
            viewSettings.visible = false
        }

        anchors { right: parent.right; top: parent.top }
        text: "确定"
    }

    StackLayout {
        anchors {
            left: parent.left; right: parent.right
            top: tabBar.bottom; bottom: parent.bottom
        }
        currentIndex: tabBar.currentIndex

        ViewVideoPath {
        }
        ViewSandBoxLight {
        }
    }
}
