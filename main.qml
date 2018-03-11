import QtQuick 2.9
import QtQuick.Controls 2.2
import com.winlua.brokenglass.bgstate 1.0


QtObject {
    property real defaultSpacing: 10
    property SystemPalette palette: SystemPalette {}

       property var controlWindow: ApplicationWindow {
            visible: false
            width: 640
            height: 480
            title: qsTr("Scroll")
            onBeforeRendering: {

            }

            BGState{
            id:state
            }

            ScrollView {
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 129
                anchors.fill: parent

                ListView {
                    width: parent.width
                    model: 20
                    delegate: ItemDelegate {
                        text: "Item " + (index + 1)
                        width: parent.width
                    }
                }
            }

            Text {
                id: text1
                x: 18
                y: 21
                width: 207
                height: 21
                text: qsTr("Hello From Victoria")
                font.pixelSize: 12
            }

            TextInput{
                id: input1
                x: 18
                y: 48
                width: 207
                height: 21
            }
            Button {
                id: button
                x: 298
                y: 21
                text: qsTr("Press me")
                onClicked: {
                    try{
                    text1.text = state.returnString(input1.text)
                    }
                    catch(ex)
                    {
                    text1.text = "Lua Crashed. Restart now please."
                    }
                }
            }
        }


    property var splashWindow: Splash {
        onTimeout: controlWindow.visible = true
    }

}
