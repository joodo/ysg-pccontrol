import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2
import QtWebSockets 1.1

import PcControl 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("电子沙盘")
    color: "black"

    /*
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

        interval: 1000; repeat: true; triggeredOnStart: true
    }*/

    /*
    VideoOutput {
        anchors.fill: parent
        source: mediaplayer
    }
    MediaPlayer {
        id: mediaplayer
        property int videoType: 0
        function playVideo(name) {
            switch (name) {
            case "a":
            case "b":
            case "c":
                videoType = name.charCodeAt(0)-"a".charCodeAt(0)
                source = Session.videoPath[videoType]
                play()
                break;
            default: ;
            }
        }
        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.PlayingState) {
                if (videoType === 2) {
                    // 执行ppt播放
                } else {
                    timerSandBoxAction.initActions()
                    timerSandBoxAction.start()
                }
            } else {
                timerSandBoxAction.stop()
            }
        }
        volume: 0.5
        loops: videoType===2? MediaPlayer.Infinite : 1
    }*/

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: { viewSettings.visible = true }
        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Space) {
            } else {
                socketVideoPlay.send(event.text)
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
            socketVideoPlay.send(command)
            return
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

    WebSocketServer {
        id: socketVideoPlay
        property WebSocket socket
        function send(message) { socket.sendTextMessage(message) }

        listen: true; port: 8900
        onClientConnected: { socket = webSocket; send('hello') }
    }

    Item {
        Component.onCompleted: Backend.openChrome("")
    }
}
