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

    Timer {
        id: timerSandBoxAction
        property var actions
        function initActions() {
            actions = {}
            for (var i = 0; i < Session.modelSandBoxLights.count; i++) {
                var element = Session.modelSandBoxLights.get(i)
                actions[element.timePoint] = []
                for (var j = 0; j < element.modelActions.count; j++) {
                    var index = element.modelActions.get(j).actionIndex
                    actions[element.timePoint].push(Session.actions.get(index).command)
                }
            }
        }
        onTriggered: {
            var position = Math.floor(mediaplayer.position/1000)
            var action = actions[position]
            if (action) {
                print(position)
                for (var i in action) {
                    Backend.lightAction(action[i])
                }
                actions[position] = null
            }
        }

        interval: 1000; running: mediaplayer.playbackState===MediaPlayer.PlayingState
        repeat: true; triggeredOnStart: true
    }

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
            function playVideo(name) {
                switch (name) {
                case "a":
                    mediaplayer.source = Session.videoPath[0]
                case "b":
                    mediaplayer.source = Session.videoPath[1]
                case "c":
                    mediaplayer.source = Session.videoPath[2]
                    mediaplayer.play()
                default: ;
                }
            }
            onPlaybackStateChanged: {
                if (playbackState === MediaPlayer.PlayingState) {
                    timerSandBoxAction.initActions()
                }
            }
            volume: 0.5
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: { viewSettings.visible = true }
        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Space) {
                mediaplayer.stop()
            } else {
                mediaplayer.playVideo(event.text)
            }
        }
    }

    ViewSettings {
        id: viewSettings
        anchors.fill: parent
        visible: false
        onVisibleChanged: if (!visible) mouseArea.focus = true
    }

    Connections {
        target: Backend
        onCommandReceived: {
            switch(command) {
            case "a":
            case "b":
            case "c":
                mediaplayer.playVideo(command)
                break
            case "volumeup":
                if (mediaplayer.volume < 1.0) mediaplayer.volume += 0.1
                break
            case "volumedown":
                if (mediaplayer.volume > 0.0) mediaplayer.volume -= 0.1
                break
            case "mute":
                mediaplayer.muted = !mediaplayer.muted
                break
            case "play":
                mediaplayer.play()
                break
            case "stop":
                mediaplayer.stop()
                break
            case "pause":
                mediaplayer.pause()
                break;
            default: ;
            }
        }
    }
}
