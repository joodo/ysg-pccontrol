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
    color: "green"

    Timer {
        id: timerSandBoxAction
        property var actions
        property int position: -1

        function loadAndPlay() {
            position = 0

            actions = {}
            for (var i = 0; i < Session.modelSandBoxLights.count; i++) {
                var element = Session.modelSandBoxLights.get(i)
                //if (!element || !element.modelActions || (element.timePoint!==0 && !element.timePoint)) continue;
                actions[element.timePoint] = []
                for (var j = 0; j < element.modelActions.count; j++) {
                    var index = element.modelActions.get(j).actionIndex
                    actions[element.timePoint].push(Session.actions.get(index).command)
                }
            }

            start()
        }
        function pause() {
            stop()
        }
        function play() {
            if (position < 0) return
            start()
        }
        function end() {
            position = -1
            stop()
        }

        onTriggered: {
            var action = actions[position]
            if (action) {
                timerCommandSender.send(action)
            }
            position++
        }

        interval: 1000; repeat: true; triggeredOnStart: true
    }
    Timer {
        id: timerCommandSender
        property var commandList
        function send(cl) {
            commandList = cl
            start()
        }
        onTriggered: {
            if (commandList && commandList.length>0) {
                Backend.lightAction(commandList.shift())
            } else {
                stop()
            }
        }
        interval: 150; repeat: true; triggeredOnStart: true
    }

    Text {
        id: textAddress
        anchors.centerIn: parent
        color: "red"
        font.pointSize: 128
        font.bold: true

        Text {
            anchors { centerIn: parent; verticalCenterOffset: -128 }
            color: "red"
            font.pointSize: 64
            font.bold: true
            text: "连接码"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if (Backend.loadFromFile("dandandan") === "pass") {
                viewSettings.visible = true
            }
        }
        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Space) {
            } else {
                Backend.commandReceived(event.text)
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
            print("got ipad message: "+command)
            if (command === "shutdown") {
                Backend.shutdown()
                return
            }
            switch(command) {
            case "a":
            case "b":
                timerSandBoxAction.loadAndPlay()
                break
            case "c":
                Backend.lightAction("1b43dd0d0a970080") //stop
                break
            case "play":
                timerSandBoxAction.play()
                break
            case "stop":
                Backend.lightAction("1b43dd0d0a970080") //stop
                timerSandBoxAction.end()
                break
            case "pause":
                timerSandBoxAction.pause()
                break;
            default: ;
            }
            socketVideoPlay.send(command)
        }
        onAddressGot: {
            textAddress.text = lastNumber
        }
        onNewConnection: {
            Backend.openChrome(Session.chromeUrl)
        }
    }

    WebSocketServer {
        id: socketVideoPlay
        property WebSocket socket
        function send(message) {
            print("send chrome message: "+message)
            socket.sendTextMessage(message)
        }

        listen: true; port: 8900
        onClientConnected: { socket = webSocket; send('hello') }
    }
}
