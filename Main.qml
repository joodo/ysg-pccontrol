import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2
import QtMultimedia 5.8

import PcControl 1.0

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

    VideoOutput {
        anchors.fill: parent
        source: mediaplayer
        MediaPlayer {
            id: mediaplayer
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: { viewSettings.visible = true }
        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_A) {
                mediaplayer.source = Session.videoPath[0]
                mediaplayer.play()
            }
            if (event.key === Qt.Key_B) {
                mediaplayer.source = Session.videoPath[1]
                mediaplayer.play()
            }
            if (event.key === Qt.Key_C) {
                mediaplayer.source = Session.videoPath[2]
                mediaplayer.play()
            }
            if (event.key === Qt.Key_Space) {
                mediaplayer.stop()
            }
        }
    }

    ViewSettings {
        id: viewSettings
        anchors.fill: parent
        visible: false
        onVisibleChanged: if (!visible) mouseArea.focus = true
    }

}
