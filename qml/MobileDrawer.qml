import QtQuick
import QtQuick.Controls

import ThemeEngine 1.0

Drawer {
    width: (appWindow.screenOrientation === Qt.PortraitOrientation ||
            appWindow.width < 480) ? 0.8 * appWindow.width : 0.5 * appWindow.width
    height: appWindow.height

    ////////////////////////////////////////////////////////////////////////////

    background: Rectangle {
        color: Theme.colorBackground

        Rectangle {
            x: parent.width - 1
            width: 1
            height: parent.height
            color: Theme.colorSeparator
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    contentItem: Item {

        Column {
            id: rectangleHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 1
            z: 5

            Connections {
                target: appWindow
                function onScreenPaddingStatusbarChanged() { rectangleHeader.updateIOSHeader() }
            }
            Connections {
                target: ThemeEngine
                function onCurrentThemeChanged() { rectangleHeader.updateIOSHeader() }
            }

            function updateIOSHeader() {
                if (Qt.platform.os === "ios") {
                    if (screenPaddingStatusbar !== 0 && Theme.currentTheme === ThemeEngine.THEME_NIGHT)
                        rectangleStatusbar.height = screenPaddingStatusbar
                    else
                        rectangleStatusbar.height = 0
                }
            }

            ////////

            Rectangle {
                id: rectangleStatusbar
                height: screenPaddingStatusbar
                anchors.left: parent.left
                anchors.right: parent.right
                color: Theme.colorBackground // "red" // to hide flickable content
            }
            Rectangle {
                id: rectangleNotch
                height: screenPaddingNotch
                anchors.left: parent.left
                anchors.right: parent.right
                color: Theme.colorBackground // "yellow" // to hide flickable content
            }
            Rectangle {
                id: rectangleLogo
                height: 80
                anchors.left: parent.left
                anchors.right: parent.right
                color: Theme.colorBackground

                Image {
                    id: imageHeader
                    width: 40
                    height: 40
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/assets/logos/logo.svg"
                }
                Text {
                    id: textHeader
                    anchors.left: imageHeader.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 2

                    text: "WatchFlower"
                    color: Theme.colorText
                    font.bold: true
                    font.pixelSize: 22
                }
            }
        }
        MouseArea { anchors.fill: rectangleHeader; acceptedButtons: Qt.AllButtons; }

        ////////////////////////////////////////////////////////////////////////////

        Flickable {
            anchors.top: rectangleHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            contentWidth: -1
            contentHeight: contentColumn.height

            Column {
                id: contentColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 1

                ////////

                ListItemDrawer {
                    highlighted: (appContent.state === "DeviceList")
                    text: qsTr("Sensors")
                    iconSource: "qrc:/assets/logos/watchflower_tray_dark.svg"

                    onClicked: {
                        screenDeviceList.loadScreen()
                        appDrawer.close()
                    }
                }

                ListItemDrawer {
                    highlighted: (appContent.state === "Settings")
                    text: qsTr("Settings")
                    iconSource: "qrc:/assets/icons_material/outline-settings-24px.svg"

                    onClicked: {
                        screenSettings.loadScreen()
                        appDrawer.close()
                    }
                }

                ListItemDrawer {
                    highlighted: (appContent.state === "About" || appContent.state === "AboutPermissions")
                    text: qsTr("About")
                    iconSource: "qrc:/assets/icons_material/outline-info-24px.svg"

                    onClicked: {
                        screenAbout.loadScreen()
                        appDrawer.close()
                    }
                }

                ////////

                ListSeparatorPadded { }

                ////////

                ListItemDrawer {
                    iconSource: "qrc:/assets/icons_material/baseline-sort-24px.svg"
                    text: {
                        var txt = qsTr("Order by:") + " "
                        if (settingsManager.orderBy === "waterlevel") {
                            txt += qsTr("water level")
                        } else if (settingsManager.orderBy === "plant") {
                            txt += qsTr("plant name")
                        } else if (settingsManager.orderBy === "model") {
                            txt += qsTr("sensor model")
                        } else if (settingsManager.orderBy === "location") {
                            txt += qsTr("location")
                        }
                        return txt
                    }

                    property var sortmode: {
                        if (settingsManager.orderBy === "waterlevel") {
                            return 3
                        } else if (settingsManager.orderBy === "plant") {
                            return 2
                        } else if (settingsManager.orderBy === "model") {
                            return 1
                        } else { // if (settingsManager.orderBy === "location") {
                            return 0
                        }
                    }

                    onClicked: {
                        sortmode++
                        if (sortmode > 3) sortmode = 0

                        if (sortmode === 0) {
                            settingsManager.orderBy = "location"
                            deviceManager.orderby_location()
                        } else if (sortmode === 1) {
                            settingsManager.orderBy = "model"
                            deviceManager.orderby_model()
                        } else if (sortmode === 2) {
                            settingsManager.orderBy = "plant"
                            deviceManager.orderby_plant()
                        } else if (sortmode === 3) {
                            settingsManager.orderBy = "waterlevel"
                            deviceManager.orderby_waterlevel()
                        }
                    }
                }

                ////////

                ListSeparatorPadded { }

                ////////

                ListItemDrawerButton {
                    text: qsTr("Refresh sensor data")

                    iconSource: "qrc:/assets/icons_material/baseline-autorenew-24px.svg"
                    iconAnimation: "rotate"
                    iconAnimated: deviceManager.updating

                    enabled: (deviceManager.bluetooth && !deviceManager.scanning)

                    onClicked: {
                        if (!deviceManager.scanning) {
                            if (deviceManager.updating) {
                                deviceManager.refreshDevices_stop()
                            } else {
                                deviceManager.refreshDevices_start()
                            }
                            appDrawer.close()
                        }
                    }
                }

                ListItemDrawerButton {
                    text: qsTr("Sync sensors history")

                    iconSource: "qrc:/assets/icons_custom/duotone-date_all-24px.svg"
                    iconAnimation: "fade"
                    iconAnimated: deviceManager.syncing

                    enabled: (deviceManager.bluetooth && !deviceManager.scanning)

                    onClicked: {
                        if (!deviceManager.scanning) {
                            if (deviceManager.syncing) {
                                deviceManager.syncDevices_stop()
                            } else {
                                deviceManager.syncDevices_start()
                            }
                            appDrawer.close()
                        }
                    }
                }

                ListItemDrawerButton {
                    text: qsTr("Search for new sensors")

                    iconSource: "qrc:/assets/icons_material/baseline-search-24px.svg"
                    iconAnimation: "fade"
                    iconAnimated: deviceManager.scanning

                    enabled: deviceManager.bluetooth

                    onClicked: {
                        if (deviceManager.scanning) {
                            deviceManager.scanDevices_stop()
                        } else {
                            deviceManager.scanDevices_start()
                        }
                        appDrawer.close()
                    }
                }

                ////////

                ListSeparatorPadded { }

                ////////
            }
        }

        ////////////////////////////////////////////////////////////////////////

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 1
            anchors.bottom: parent.bottom

            ListItemDrawer {
                highlighted: (appContent.state === "PlantBrowser")
                text: qsTr("Plant browser")
                iconSource: "qrc:/assets/icons_material/outline-local_florist-24px.svg"

                onClicked: {
                    screenPlantBrowser.loadScreenFrom("DeviceList")
                    appDrawer.close()
                }
            }

            ListItemDrawer {
                highlighted: (appContent.state === "DeviceBrowser")
                text: qsTr("Device browser")
                iconSource: "qrc:/assets/icons_material/baseline-radar-24px.svg"

                enabled: deviceManager.bluetooth

                onClicked: {
                    screenDeviceBrowser.loadScreen()
                    appDrawer.close()
                }
            }
        }

        ////////////////////////////////////////////////////////////////////////
    }
}
