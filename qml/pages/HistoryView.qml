/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2022-2026 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.6
import Sailfish.Silica 1.0
import Opal.Tabs 1.0
import Opal.Delegates 1.0
import Opal.DragDrop 1.0
import TimezoneInfo 1.0

import "../components"
import "../js/dates.js" as Dates
import "../js/storage.js" as Storage

TabItem {
    id: root
    flickable: view

    property ListModel model: app.historyModel

    SilicaListView {
        id: view

        anchors.fill: parent
        model: root.model

        VerticalScrollDecorator { flickable: view }

        ViewPulley {}

        header: ViewHeader {
            title: qsTr("History")
        }

        ViewPlaceholder {
            enabled: model.count == 0
            text: qsTr("No entries")
            hintText: qsTr("Pull down to pick a date.")
        }

        ViewDragHandler {
            id: viewDragHandler
            listView: view

            onItemDropped: {
                Storage.moveHistoryItem(model.get(finalIndex).rowid, finalIndex)
            }
        }

        delegate: TwoLineDelegate {
            id: delegate

            property int _rowid: model.rowid
            property var tzInfo: TimezoneInfo.findTimezoneInfo(model.tz)

            text: Dates.formatDate(model.date, Dates.dateTimeFormat)
            description: model.tz !== LOCAL_TIMEZONE ?
                (!!tzInfo ? "%2 (%1)".arg(tzInfo.country).arg(tzInfo.city) : model.tz) : ""
            dragHandler: viewDragHandler
            hideRightItemWhileDragging: false
            enableDefaultGrabHandle: false
            ListView.onRemove: animateRemoval(delegate)

            // move the drag handle left
            leftItem: DragHandle {
                handleImage.anchors {
                    right: undefined
                    left: handleImage.parent.left
                }

                moveHandler: DelegateDragHandler {
                    viewHandler: viewDragHandler
                    handledItem: delegate
                    modelIndex: index
                }
            }

            rightItem: DelegateInfoItem {
                id: infoItem

                property int years: -1

                function update() {
                    app.getYearsForDate(model.date, model.tz, function(result){
                        years = result.wall.years
                    })
                }

                text: years >= 0 ? years : ""
                description: years >= 0 ?
                    qsTr("year(s)", "as in: “age: 50 years”", years) : ""
                alignment: Qt.AlignRight

                Connections {
                    target: app.wallClock
                    onTimeChanged: infoItem.update()
                }

                Component.onCompleted: {
                    infoItem.update()
                }
            }

            menu: Component {
                ContextMenu {
                    MenuLabel {
                        visible: delegate.description !== model.tz && !!text
                        text: !!tzInfo ? "%1, %2, %3".arg(tzInfo.city).arg(tzInfo.country).arg(tzInfo.area) : ""
                    }

                    MenuItem {
                        text: qsTr("Remove")
                        onClicked: {
                            delegate.remorseDelete(function(app, storage){
                                console.log("removing history entry:", this._rowid, this.modelIndex)
                                storage.deleteHistoryItem(this._rowid)
                                app.historyModel.remove(this.modelIndex)
                            }.bind(delegate, app, Storage))
                        }
                    }
                }
            }

            onClicked: {
                app.setNewDate(model.date, model.tz)
                app.switchToCalcView()
            }
        }
    }
}
