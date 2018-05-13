pragma Singleton

import QtQuick 2.10

QtObject {
    readonly property ListModel actions: ListModel {
        ListElement { text: "打开全部灯光"; command: "AAA000,AAA001" }
        ListElement { text: "关闭全部灯光"; command: "AAA002" }
    }

    property ListModel modelSandBoxLights: ListModel {}
    property var videoPath: ["点击设置", "点击设置", "点击设置"]

    function save() {
        var data = {
            videoPath: videoPath,
            sandBoxLights: []
        }
        for (var i = 0; i < modelSandBoxLights.count; i++) {
            var timePointData = {
                timePoint: modelSandBoxLights.get(i).timePoint,
                actions: []
            }
            var modelActions = modelSandBoxLights.get(i).modelActions
            for (var j = 0; j < modelActions.count; j++) {
                timePointData.actions.push(modelActions.get(j))
            }
            data.sandBoxLights.push(timePointData)
        }
        Backend.saveToFile(JSON.stringify(data), "save")
    }
    function load() {
        loadFromFile("save")
    }
    function reset() {
        loadFromFile("null")
    }
    function loadFromFile(path) {
        var file = Backend.loadFromFile(path)
        try {
            var data = JSON.parse(file)
        } catch (e) {
            if (path !== "defaultSave") loadFromFile("defaultSave")
            return
        }

        videoPath = data.videoPath
        for (var i in data.sandBoxLights) {
            var sandBoxLight = data.sandBoxLights[i]

            var elementSandBoxLight = {
                timePoint: sandBoxLight.timePoint,
                modelActions: Qt.createQmlObject("import QtQuick 2.10; ListModel{}", modelSandBoxLights)
            }
            for (var j in sandBoxLight.actions) {
                elementSandBoxLight.modelActions.append(sandBoxLight.actions[j])
            }

            modelSandBoxLights.append(elementSandBoxLight)
        }
    }
}
