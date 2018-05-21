import QtQuick 2.10
import QtQuick.Controls 2.2

Rectangle {
    ScrollView {
        id: view
        anchors.fill: parent

        TextArea {
            id: textAreaLog
        }
    }

    Connections {
        target: Backend
        onLog: textAreaLog.append(message)
    }
}
