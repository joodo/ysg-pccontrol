pragma Singleton

import QtQuick 2.10

QtObject {
    property ListModel actions: ListModel {
    }

    property ListModel modelSandBoxLights: ListModel {}
    property string chromeUrl: ""
    property string actionString: ""

    onActionStringChanged: {
        actions.clear()
        var aas = actionString.split("\n")
        for (var i in aas) {
            var aa = aas[i].split(":")
            if (aa.length > 1) {
                actions.append({ text: aa[0], command: aa[1] })
            }
        }
    }

    function save() {
        var data = {
            chromeUrl: chromeUrl,
            actionString: actionString,
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
        Backend.openChrome(chromeUrl)
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

        chromeUrl = data.chromeUrl
        actionString = data.actionString

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
