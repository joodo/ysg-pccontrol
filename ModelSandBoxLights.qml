import QtQuick 2.10

ListModel {
    function sort() {
        for (var i = 0; i < count; i++) {
            var minIndex = i
            for (var j = i+1; j < count; j++) {
                if (get(j).timePoint < get(minIndex).timePoint) {
                    minIndex = j
                }
            }
            if (i !== minIndex) {
                move(minIndex, i, 1)
            }
        }
    }
}
