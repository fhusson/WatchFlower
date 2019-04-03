/*!
 * This file is part of WatchFlower.
 * COPYRIGHT (C) 2019 Emeric Grange - All Rights Reserved
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

import QtGraphicalEffects 1.0
import com.watchflower.theme 1.0

Item {
    id: aboutScreen
    width: 480
    height: 640
    anchors.fill: parent

    Rectangle {
        id: rectangleAboutTitle
        height: 80
        color: Theme.colorMaterialDarkGrey

        visible: (Qt.platform.os !== "android" && Qt.platform.os !== "ios")

        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            id: textTitle
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.top: parent.top
            anchors.topMargin: 12

            font.bold: true
            font.pixelSize: 26
            color: Theme.colorText
            text: qsTr("About")
        }

        Text {
            id: textSubtitle
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 14

            text: qsTr("What do you want to know?")
            font.pixelSize: 16
        }
    }

    Column {
        id: column
        anchors.top: (Qt.platform.os !== "android" && Qt.platform.os !== "ios") ? rectangleAboutTitle.bottom : parent.top
        anchors.topMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 16

        Item {
            id: logo
            height: 80
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

            Image {
                id: imageLogo
                width: 80
                height: 80
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left

                source: "qrc:/assets/logo.svg"
                sourceSize: Qt.size(width, height)
            }

            Text {
                id: textVersion
                anchors.left: imageLogo.right
                anchors.leftMargin: 18
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10

                color: Theme.colorSubText
                text: qsTr("version") + " " + settingsManager.getAppVersion()
                font.pixelSize: 16
            }

            Text {
                id: element1
                anchors.top: parent.top
                anchors.topMargin: 14
                anchors.left: imageLogo.right
                anchors.leftMargin: 16

                text: qsTr("WatchFlower")
                color: Theme.colorText
                font.pixelSize: 32
            }
        }

        Item {
            id: website
            height: 48
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            Item {
                width: 32
                height: 32
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 0

                Image {
                    id: websiteImg
                    anchors.fill: parent
                    visible: false
                    source: "qrc:/assets/icons_material/baseline-insert_link-24px.svg"
                    sourceSize: Qt.size(width, height)
                    fillMode: Image.PreserveAspectFit
                }
                ColorOverlay {
                    source: websiteImg
                    anchors.fill: parent
                    color: Theme.colorText
                    cached: true
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 48

                color: Theme.colorText
                text: "Website"
                font.pixelSize: 17

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://emeric.io/WatchFlower.html")
                }
            }
        }

        Item {
            id: github
            height: 48
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            Item {
                width: 28
                height: 28
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 2

                Image {
                    id: githubImg
                    anchors.fill: parent
                    visible: false
                    source: "qrc:/assets/github.svg"
                    sourceSize: Qt.size(width, height)
                    fillMode: Image.PreserveAspectFit
                }
                ColorOverlay {
                    source: githubImg
                    anchors.fill: parent
                    color: Theme.colorText
                    cached: true
                }
            }

            Text {
                id: link
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 48
                horizontalAlignment: Text.AlignHCenter

                color: Theme.colorText
                text: "GitHub page"
                font.pixelSize: 17

                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://github.com/emericg/WatchFlower")
                }
            }
        }

        Item {
            id: tuto
            height: 48
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            Item {
                width: 30
                height: 30
                anchors.left: parent.left
                anchors.leftMargin: 1
                anchors.top: parent.top
                anchors.topMargin: 8

                Image {
                    id: tutoImg
                    anchors.fill: parent
                    visible: false
                    source: "qrc:/assets/icons_material/baseline-import_contacts-24px.svg.png"
                    sourceSize: Qt.size(width, height)
                    fillMode: Image.PreserveAspectFit
                }
                ColorOverlay {
                    source: tutoImg
                    anchors.fill: parent
                    color: Theme.colorText
                    cached: true
                }
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 48
                anchors.verticalCenter: parent.verticalCenter

                text: qsTr("Open the tutorial")
                color: Theme.colorText
                font.pixelSize: 17

                MouseArea {
                    id: mouseArea1
                    anchors.fill: parent
                    onClicked: {
                        screenTutorial.goBackTo = "About"
                        content.state = "Tutorial"
                    }
                }
            }
        }

        Item {
            id: desc
            height: 180
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

            Item {
                width: 32
                height: 32
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.left: parent.left
                anchors.leftMargin: 0

                Image {
                    id: descImg
                    anchors.fill: parent
                    visible: false
                    source: "qrc:/assets/icons_material/outline-info-24px.svg"
                    sourceSize: Qt.size(width, height)
                    fillMode: Image.PreserveAspectFit
                }
                ColorOverlay {
                    source: descImg
                    anchors.fill: parent
                    color: Theme.colorText
                    cached: true
                }
            }
            TextArea {
                id: description

                color: Theme.colorText
                text: qsTr("A plant monitoring application for Xiaomi / MiJia 'Flower Care' and 'Ropot' bluetooth devices.")
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 40
                wrapMode: Text.WordWrap
                readOnly: true
                font.pixelSize: 18
            }

            Item {
                id: rectangleIcons
                height: 102
                anchors.top: description.bottom
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                Item {
                    width: 80
                    height: 80
                    anchors.left: itemMiddle.right
                    anchors.leftMargin: 32
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: image3
                        anchors.fill: parent
                        visible: false
                        source: "qrc:/assets/devices/hygrotemp.svg"
                        fillMode: Image.PreserveAspectFit
                        sourceSize: Qt.size(width, height)
                    }
                    ColorOverlay {
                        source: image3
                        anchors.fill: parent
                        color: Theme.colorGreen
                        cached: true
                    }
                }

                Item {
                    id: itemMiddle
                    width: 80
                    height: 80
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: image2
                        anchors.fill: parent
                        visible: false
                        source: "qrc:/assets/devices/ropot.svg"
                        fillMode: Image.PreserveAspectFit
                        sourceSize: Qt.size(width, height)
                    }
                    ColorOverlay {
                        source: image2
                        anchors.fill: parent
                        color: Theme.colorGreen
                        cached: true
                    }
                }

                Item {
                    width: 80
                    height: 80
                    anchors.right: itemMiddle.left
                    anchors.rightMargin: 32
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: image1
                        anchors.fill: parent
                        visible: false
                        source: "qrc:/assets/devices/flowercare.svg"
                        fillMode: Image.PreserveAspectFit
                        sourceSize: Qt.size(width, height)
                    }
                    ColorOverlay {
                        source: image1
                        anchors.fill: parent
                        color: Theme.colorGreen
                        cached: true
                    }
                }
            }
        }
    }
}