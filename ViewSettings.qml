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
        TabButton { text: "视频路径" }
        TabButton { text: "沙盘灯光" }
        TabButton { text: "动作参数" }
        TabButton { text: "系统日志" }
    }

    Row {
        anchors { right: parent.right; top: parent.top }
        spacing: 2

        Button { text: "重置"; width: 50; onClicked: Session.reset() }
        Button { text: "应用"; width: 50; onClicked: { Session.save(); viewSettings.visible = false } }
    }

    StackLayout {
        anchors {
            left: parent.left; right: parent.right
            top: tabBar.bottom; bottom: parent.bottom
        }
        currentIndex: tabBar.currentIndex

        ViewVideoPath {}
        ViewSandBoxLight {}
        ViewActionString {}
        ViewLog {}
    }
}
