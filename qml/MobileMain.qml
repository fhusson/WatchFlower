/*!
 * This file is part of WatchFlower.
 * COPYRIGHT (C) 2018 Emeric Grange - All Rights Reserved
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \date      2019
 * \author    Emeric Grange <emeric.grange@gmail.com>
 */

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import StatusBar 0.1
import app.watchflower.theme 1.0

ApplicationWindow {
    id: applicationWindow
    color: "#E0FAE7"
    visible: true

    minimumWidth: 400
    minimumHeight: 640

    flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint

    Material.theme: Material.Dark
    Material.accent: Material.LightGreen

    StatusBar {
        theme: Material.Dark
        color: Theme.colorHeaderMobileStatusbar
        //color: Material.color(Material.LightGreen, Material.Shade900)
    }

    Drawer {
        id: drawer
        width: 0.80 * applicationWindow.width
        height: applicationWindow.height

        onOpenedChanged: drawerscreen.updateDrawerFocus()
        MobileDrawer { id: drawerscreen }
    }

    // Events handling /////////////////////////////////////////////////////////

    Connections {
        target: header
        onLeftMenuClicked: {
            drawer.open()
        }
        onRightMenuClicked: {
            //
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.BackButton | Qt.ForwardButton
        onClicked: {
            if (mouse.button === Qt.BackButton) {
                content.state = "DeviceList"
            } else if (mouse.button === Qt.ForwardButton) {
                if (curentlySelectedDevice)
                    content.state = "DeviceDetails"
            }
        }
    }
    Shortcut {
        sequence: StandardKey.Back
        onActivated: {
            content.state = "DeviceList"
        }
    }
    Shortcut {
        sequence: StandardKey.Forward
        onActivated: {
            if (curentlySelectedDevice)
                content.state = "DeviceDetails"
        }
    }
    FocusScope {
        focus: true
        Keys.onBackPressed: {
            if (Qt.platform.os === "android" || Qt.platform.os === "ios") {
                if (content.state === "DeviceList") {
                    // hide windows?
                } else {
                    content.state = "DeviceList"
                }
            } else {
                content.state = "DeviceList"
            }
        }
    }
    onClosing: {
        if (Qt.platform.os === "android" || Qt.platform.os === "ios") {
            close.accepted = false;
        } else {
            close.accepted = false;
            applicationWindow.hide()
        }
    }

    // QML /////////////////////////////////////////////////////////////////////

    property var curentlySelectedDevice: null

    MobileHeader {
        id: header
        anchors.top: parent.top
    }

    Rectangle {
        id: content
        color: "#e0fae7"
        anchors.top: header.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        MobileDeviceList {
            anchors.fill: parent
            id: screenDeviceList
        }
        DeviceScreen {
            anchors.fill: parent
            id: screenDeviceDetails
        }
        MobileSettings {
            anchors.fill: parent
            id: screenSettings
        }
        MobileAbout {
            anchors.fill: parent
            id: screenAbout
        }

        onStateChanged: {
            drawerscreen.updateDrawerFocus()
            if (state === "DeviceDetails")
                header.rightMenuEnabled = true
            else
                header.rightMenuEnabled = false
        }

        state: "DeviceList"
        states: [
            State {
                name: "DeviceList"

                PropertyChanges {
                    target: screenDeviceList
                    enabled: true
                    visible: true
                }
                PropertyChanges {
                    target: screenDeviceDetails
                    enabled: false
                    visible: false
                }
                PropertyChanges {
                    target: screenSettings
                    enabled: false
                    visible: false
                }
                PropertyChanges {
                    target: screenAbout
                    visible: false
                    enabled: false
                }
            },
            State {
                name: "DeviceDetails"

                PropertyChanges {
                    target: screenDeviceList
                    enabled: false
                    visible: false
                }
                PropertyChanges {
                    target: screenDeviceDetails
                    enabled: true
                    visible: true
                }
                PropertyChanges {
                    target: screenSettings
                    enabled: false
                    visible: false
                }
                PropertyChanges {
                    target: screenAbout
                    visible: false
                    enabled: false
                }
                StateChangeScript {
                    name: "secondScript"
                    script: screenDeviceDetails.loadDevice()
                }
            },
            State {
                name: "Settings"

                PropertyChanges {
                    target: screenDeviceList
                    visible: false
                    enabled: false
                }
                PropertyChanges {
                    target: screenDeviceDetails
                    visible: false
                    enabled: false
                }
                PropertyChanges {
                    target: screenSettings
                    visible: true
                    enabled: true
                }
                PropertyChanges {
                    target: screenAbout
                    visible: false
                    enabled: false
                }
            }
        ]
    }
}
