import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0

Button {
    id: control
    width: contentText.width + 24
    implicitHeight: Theme.componentHeight

    font.pixelSize: Theme.fontSizeComponent
    font.bold: fullColor ? true : false

    focusPolicy: Qt.NoFocus

    property bool fullColor: false
    property string fullfextColor: "white"
    property string primaryColor: Theme.colorPrimary
    property string secondaryColor: Theme.colorBackground
    property bool hoverAnimation: isDesktop

    ////////////////////////////////////////////////////////////////////////////

    background: Rectangle {
        radius: Theme.componentRadius
        opacity: enabled ? (control.down ? 0.8 : 1.0) : 0.33
        color: fullColor ? control.primaryColor : control.secondaryColor
        border.width: 1
        border.color: fullColor ? control.primaryColor : Theme.colorComponentBorder

        clip: hoverAnimation
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton

            enabled: hoverAnimation
            visible: hoverAnimation
            hoverEnabled: hoverAnimation

            onEntered: mouseBackground.opacity = 0.15
            onExited: mouseBackground.opacity = 0
            onPositionChanged: {
                mouseBackground.x = mouseX + 4 - (mouseBackground.width / 2)
                mouseBackground.y = mouseY + 4 - (mouseBackground.width / 2)
            }
            Rectangle {
                id: mouseBackground
                width: 80; height: width; radius: width;
                color: "#fff"
                opacity: 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }
    }

    contentItem: Item {
        anchors.fill: parent

        Text {
            id: contentText
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter

            text: control.text
            font: control.font
            opacity: enabled ? (control.down ? 0.8 : 1.0) : 0.33
            color: fullColor ? fullfextColor : control.primaryColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
}
