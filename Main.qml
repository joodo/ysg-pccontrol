import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("电子沙盘")
    color: "black"

    Text {
        anchors.centerIn: parent
        font.pointSize: 54
        color: "white"
        text: "准备就绪！可以开始播放视频"
        Timer {
            interval: 3000; running: true
            onTriggered: {
                running = false
                parent.visible = false
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: { viewSettings.visible = true }
    }

    ViewSettings {
        id: viewSettings
        anchors.fill: parent
        visible: false
    }
}
