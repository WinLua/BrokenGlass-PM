import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import Qt.labs.settings 1.0

QtObject {
    property real defaultSpacing: 10
    property SystemPalette palette: SystemPalette {}

    property var controlWindow:ApplicationWindow {
        id: window
        width: 360
        height: 520
        visible: false
        title: "BrokenGlass"

        Shortcut {
            sequences: ["Esc", "Back"]
            enabled: stackView.depth > 1
            onActivated: {
                stackView.pop()
                listView.currentIndex = -1
            }
        }

        Shortcut {
            sequence: "Menu"
            onActivated: optionsMenu.open()
        }


        header: ToolBar {
            Material.foreground: "white"

            RowLayout {
                spacing: 20
                anchors.fill: parent

                ToolButton {
                    //                    icon.name: stackView.depth > 1 ?"qrc:/icons/20x20/back.png" :"qrc:/icons/20x20/drawer.png"
                    icon.source:  stackView.depth > 1 ?"qrc:icons/20x20/back.png" :"qrc:icons/20x20/drawer.png"
                    onClicked: {
                        if (stackView.depth > 1) {
                            stackView.pop()
                            listView.currentIndex = -1
                        } else {
                            drawer.open()
                        }
                    }
                }

                Label {
                    id: titleLabel
                    text: listView.currentItem ? listView.currentItem.text : "LuaRocks For Windows"
                    font.pixelSize: 20
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }

                ToolButton {
                    //                    icon.name: "menu"
                    icon.source: "qrc:/icons/20x20/menu.png"
                    onClicked: optionsMenu.open()

                    Menu {
                        id: optionsMenu
                        x: parent.width - width
                        transformOrigin: Menu.TopRight

                        MenuItem {
                            text: "Settings"
                            onTriggered: settingsDialog.open()
                        }
                        MenuItem {
                            text: "About"
                            onTriggered: aboutDialog.open()
                        }
                    }
                }
            }
        }

        Drawer {
            id: drawer
            width: Math.min(window.width, window.height) / 3 * 2
            height: window.height
            interactive: stackView.depth === 1

            ListView {
                id: listView

                focus: true
                currentIndex: -1
                anchors.fill: parent

                delegate: ItemDelegate {
                    width: parent.width
                    text: model.title
                    highlighted: ListView.isCurrentItem
                    onClicked: {
                        listView.currentIndex = index
                        stackView.push(model.source)
                        drawer.close()
                    }
                }

                model: ListModel {
                    ListElement { title: "Detail"; source: "qrc:/qml/SpinBoxPage.qml" }
                    ListElement { title: "Lua Versions"; source: "qrc:/pages/CheckBoxPage.qml" }
                    ListElement { title: "Configurations"; source: "qrc:/pages/ComboBoxPage.qml" }
                    ListElement { title: "Path Tool"; source: "qrc:/pages/DelayButtonPage.qml" }
                }

                ScrollIndicator.vertical: ScrollIndicator { }
            }
        }

        StackView {
            id: stackView
            anchors.fill: parent

            initialItem: Pane {
                id: pane

                Rectangle{
                    id:search
                    width:pane.width * 0.7
                    height: 33
                    anchors.horizontalCenter : parent.horizontalCenter
                    color: "white"

                    TextInput {
                        id:searchInput
                        height: parent.height
                        width: parent.width - 40
                        font.pointSize: 12
                        color: "black"
                        verticalAlignment: Text.AlignVCenter
                        focus: true
                        anchors.left: parent.left

                    }
                    ToolButton {
                        id:searchButton
                        //                    icon.name: stackView.depth > 1 ?"qrc:/icons/20x20/back.png" :"qrc:/icons/20x20/drawer.png"
                        icon.source:  "qrc:/icons/Search.png"
                        height:parent.height
                        anchors.right:parent.right
                        onClicked: {
                            mylabel.text = searchInput.text
                        }
                    }
                }

                Image {
                    id: logo
                    width: pane.availableWidth / 2
                    height: pane.availableHeight / 2
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -50
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/images/Lua-Logo.png"
                    opacity: 0.3
                }

                Label {
                    id: mylabel
                    text: "Qt Quick Controls 2 provides a set of controls that can be used to build complete interfaces in Qt Quick."
                    anchors.margins: 20
                    anchors.top: logo.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: arrow.top
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    wrapMode: Label.Wrap
                }

                Image {
                    id: arrow
                    source: "qrc:/images/arrow.png"
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                }
            }
        }

        Dialog {
            id: settingsDialog
            x: Math.round((window.width - width) / 2)
            y: Math.round(window.height / 6)
            width: Math.round(Math.min(window.width, window.height) / 3 * 2)
            modal: true
            focus: true
            title: "Settings"

            standardButtons: Dialog.Ok | Dialog.Cancel
            onAccepted: {
                settings.style = styleBox.displayText
                settingsDialog.close()
            }
            onRejected: {
                styleBox.currentIndex = styleBox.styleIndex
                settingsDialog.close()
            }

            contentItem: ColumnLayout {
                id: settingsColumn
                spacing: 20

                RowLayout {
                    spacing: 10

                    Label {
                        text: "Style:"
                    }

                    ComboBox {
                        id: styleBox
                        property int styleIndex: -1
                        model: availableStyles
                        Component.onCompleted: {
                            styleIndex = find(settings.style, Qt.MatchFixedString)
                            if (styleIndex !== -1)
                                currentIndex = styleIndex
                        }
                        Layout.fillWidth: true
                    }
                }

                Label {
                    text: "Restart required"
                    color: "#e41e25"
                    opacity: styleBox.currentIndex !== styleBox.styleIndex ? 1.0 : 0.0
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }

        Dialog {
            id: aboutDialog
            modal: true
            focus: true
            title: "About"
            x: (window.width - width) / 2
            y: window.height / 6
            width: Math.min(window.width, window.height) / 3 * 2
            contentHeight: aboutColumn.height

            Column {
                id: aboutColumn
                spacing: 20

                Label {
                    width: aboutDialog.availableWidth
                    text: "Broken Glass is a cross platform UI for LuaRocks primarily targeting Windows binaries."
                    wrapMode: Label.Wrap
                    font.pixelSize: 12
                }

                Label {
                    width: aboutDialog.availableWidth
                    text: "LuaRocks is a package manager for Lua that provides build facilities for "
                          + "Make, CMake and it's own built in build system. LuaRocks can be searched "
                          + "and rocks installed simply from remote repositories."
                    wrapMode: Label.Wrap
                    font.pixelSize: 12
                }
            }
        }
    }

    property var splashWindow: Splash {
        onTimeout: controlWindow.visible = true
    }

}
