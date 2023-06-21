import QtQuick
import QtQuick.Controls

import ThemeEngine 1.0

Item {
    id: deviceList
    anchors.fill: parent

    // per category ordering
    // multi selection support

    ////////////////////////////////////////////////////////////////////////////

    property bool selectionMode: false
    property var selectionList: []
    property int selectionCount: 0

    function isSelected() {
        return (selectionList.length !== 0)
    }
    function selectDevice(index, type) {
        // make sure it's not already selected
        if (deviceManager.getDeviceByProxyIndex(index, type).selected) return

        // then add
        selectionMode = true
        selectionList.push(index)
        selectionCount++

        deviceManager.getDeviceByProxyIndex(index, type).selected = true
    }
    function deselectDevice(index, type) {
        var i = selectionList.indexOf(index)
        if (i > -1) { selectionList.splice(i, 1); selectionCount--; }
        if (selectionList.length <= 0 || selectionCount <= 0) { exitSelectionMode() }

        deviceManager.getDeviceByProxyIndex(index, type).selected = false
    }
    function exitSelectionMode() {
        selectionMode = false
        selectionList = []
        selectionCount = 0

        for (var i = 0; i < deviceManager.deviceCount; i++) {
            deviceManager.getDeviceByProxyIndex(i, 0).selected = false
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Flickable {
        anchors.fill: parent

        contentWidth: -1
        contentHeight: devicesView.height
/*
        ScrollBar.vertical: ScrollBar {
            visible: false
            anchors.right: parent.right
            anchors.rightMargin: -6
            policy: ScrollBar.AsNeeded
        }
*/
        Column {
            id: devicesView
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.right: parent.right
            anchors.rightMargin: 6

            topPadding: 12
            bottomPadding: 8
            spacing: singleColumn ? 0 : 8

            ////////

            property bool bigWidget: (!isHdpi || (isTablet && width >= 480))

            property int cellColumnsTarget: Math.trunc(devicesView.width / cellWidthTarget)
            property int cellWidthTarget: {
                if (singleColumn) return devicesView.width
                if (isTablet) return (bigWidget ? 350 : 280)
                return (bigWidget ? 440 : 320)
            }
            property int cellWidth: (devicesView.width / cellColumnsTarget)
            property int cellHeight: {
                if (isPhone) return 100
                if (bigWidget) return 144
                return 112
            }

            ////////

            ListTitle {
                anchors.leftMargin: singleColumn ? -6 : 6
                anchors.rightMargin: singleColumn ? -6 : 6

                text: qsTr("Plant sensor(s)", "", deviceManager.devicePlantCount)
                visible: deviceManager.devicePlantCount
                fontSize: Theme.fontSizeContentVeryBig
            }

            Flow {
                id: devicesPlantView
                anchors.left: parent.left
                anchors.right: parent.right

                Repeater {
                    model: deviceManager.devicesPlantList
                    delegate: DeviceWidget {
                        width: devicesView.cellWidth
                        height: devicesView.cellHeight
                        bigAssMode: devicesView.bigWidget
                        singleColumn: (appWindow.singleColumn || devicesView.cellColumnsTarget === 1)
                    }
                }
            }

            ////////

            ListTitle {
                anchors.leftMargin: singleColumn ? -6 : 6
                anchors.rightMargin: singleColumn ? -6 : 6

                text: qsTr("Thermometer(s)", "", deviceManager.deviceThermoCount)
                visible: deviceManager.deviceThermoCount
                fontSize: Theme.fontSizeContentVeryBig
            }

            Flow {
                id: devicesThermoView
                anchors.left: parent.left
                anchors.right: parent.right

                Repeater {
                    model: deviceManager.devicesThermoList
                    delegate: DeviceWidget {
                        width: devicesView.cellWidth
                        height: devicesView.cellHeight
                        bigAssMode: devicesView.bigWidget
                        singleColumn: (appWindow.singleColumn || devicesView.cellColumnsTarget === 1)
                    }
                }
            }

            ////////

            ListTitle {
                anchors.leftMargin: singleColumn ? -6 : 6
                anchors.rightMargin: singleColumn ? -6 : 6

                text: qsTr("Environmental sensor(s)", "", deviceManager.deviceEnvCount)
                visible: deviceManager.deviceEnvCount
                fontSize: Theme.fontSizeContentVeryBig
            }

            Flow {
                id: devicesEnvView
                anchors.left: parent.left
                anchors.right: parent.right

                Repeater {
                    model: deviceManager.devicesEnvList
                    delegate: DeviceWidget {
                        width: devicesView.cellWidth
                        height: devicesView.cellHeight
                        bigAssMode: devicesView.bigWidget
                        singleColumn: (appWindow.singleColumn || devicesView.cellColumnsTarget === 1)
                    }
                }
            }

            ////////
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
