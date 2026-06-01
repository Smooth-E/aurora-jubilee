import QtQuick 2.6
import Sailfish.Silica 1.0
import TimezoneInfo 1.0

Page {
    id: root

    signal timezoneClicked(string name)

    SilicaListView {
        anchors.fill: parent

        header: Column {
            width: parent.width

            PageHeader {
                title: qsTr("Timezone")
            }

            BackgroundItem {
                width: parent.width
                height: childrenRect.height + Theme.paddingMedium + Theme.paddingLarge

                onClicked: root.timezoneClicked(undefined)

                Label {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        right: parent.right
                        leftMargin: Theme.horizontalPageMargin
                        rightMargin: Theme.horizontalPageMargin
                    }

                    text: qsTr("No specific timezone")
                }
            }
        }

        model: TimezoneInfo.model

        delegate: BackgroundItem {
            width: parent.width
            height: column.height

            onClicked: root.timezoneClicked(model.name)

            Column {
                id: column

                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                }

                height: implicitHeight
                topPadding: Theme.paddingMedium
                bottomPadding: Theme.paddingMedium

                Label {
                    text: model.country
                }

                Label {
                    text: "%1 %2".arg(model.offset).arg(model.city)
                    color: Theme.secondaryColor
                }
            }
        }
    }
}
