/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2022-2026 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.6
import Sailfish.Silica 1.0
import Opal.Tabs 1.0
import Opal.Delegates 1.0

import "../components"
import "../js/math.js" as M
import "../js/dates.js" as Dates

TabItem {
    id: root
    flickable: view
    allowDeletion: false

    property bool haveStartDate: !!selectedPicker.date
    property string ageInMinutes: M.value(0).toString()
    property var ageInWall: ({
        years: 0, months: 0, days: 0, hours: 0, minutes: 0
    })

    Connections {
        target: app
        onNewAgeCalculated: {
            ageInMinutes = result.minutes
            ageInWall = result.wall

            console.log("new age calculated:", ageInMinutes, JSON.stringify(ageInWall))
        }
        onNewDateProjected: {
            projectedPicker.isUserDefined = true
            projectedPicker.tz = tz
            projectedPicker.date = date
        }
        onSetNewDate: {
            if (selectedPicker.tz != tz || selectedPicker.date != date) {
                selectedPicker.tz = tz
                selectedPicker.date = date
            }
        }
        onPickNewDate: {
            selectedPicker.pick()
        }
    }

    SilicaFlickable {
        id: view
        anchors.fill: parent
        contentHeight: column.height

        ViewPulley {}

        Column {
            id: column

            width: root.width
            spacing: Theme.paddingSmall

            ViewHeader {
                title: qsTr("Calculations")
            }

            SectionHeader {
                text: qsTr("Dates")
            }

            DateTimePickerCombo {
                id: selectedPicker
                description: qsTr("Selected date")

                onDateChanged: {
                    app.setNewDate(date, tz)
                    app.calculateAge(selectedPicker.date, selectedPicker.tz,
                                     projectedPicker.date, projectedPicker.tz)
                }
            }

            DateTimePickerCombo {
                id: projectedPicker

                property bool isUserDefined: false

                function resetToNow() {
                    projectedPicker.isUserDefined = false
                    projectedPicker.tz = LOCAL_TIMEZONE
                    projectedPicker.date = Dates.formatDate(new Date(), Dates.dbDateFormat, "")

                    if (haveStartDate) {
                        app.calculateAge(selectedPicker.date, selectedPicker.tz,
                                         projectedPicker.date, projectedPicker.tz)
                    }
                }

                enabled: haveStartDate
                description: qsTr("Projected date")
                placeholderText: qsTr("")
                date: Dates.formatDate(new Date(), Dates.dbDateFormat, "")
                tz: LOCAL_TIMEZONE

                handleClick: false
                onClicked: openMenu()
                menu: Component {
                    ContextMenu {
                        MenuItem {
                            text: qsTr("Pick a date")
                            onClicked: {
                                projectedPicker.pick()
                                projectedPicker.isUserDefined = true
                            }
                        }
                        MenuItem {
                            text: qsTr("Set to “now”")
                            onClicked: {
                                projectedPicker.resetToNow()
                            }
                        }
                    }
                }

                Connections {
                    target: app.wallClock
                    onTimeChanged: {
                        if (projectedPicker.isUserDefined) return
                        projectedPicker.resetToNow()
                    }
                }
            }

            SectionHeader {
                text: qsTr("Calculations")
            }

            AgeViewItem {
                enabled: haveStartDate
                useWallTime: true
                ageInWall: root.ageInWall
                ageInMinutes: root.ageInMinutes

                components: ListModel {
                    ListElement {
                        key: "years"
                        // factor: 525600 // 365*24*60
                        min: 0
                        max: -1
                    }
                    ListElement {
                        key: "months"
                        // factor: 43200 // 30*24*60
                        min: 0
                        max: 11
                    }
                    ListElement {
                        key: "days"
                        // factor: 1440 // 24*60
                        min: 0
                        max: 29
                    }
                    ListElement {
                        key: "hours"
                        // factor: 60 // 1*60
                        min: 0
                        max: 23
                    }
                    ListElement {
                        key: "minutes"
                        // factor: 1
                        min: 0
                        max: 59
                    }
                }
            }

            AgeViewItem {
                enabled: haveStartDate
                useWallTime: true
                ageInWall: root.ageInWall
                ageInMinutes: root.ageInMinutes

                components: ListModel {
                    ListElement {
                        key: "months"
                        // factor: 43200 // 30*24*60
                        min: 0
                        max: -1
                    }
                    ListElement {
                        key: "days"
                        // factor: 1440 // 24*60
                        min: 0
                        max: 29
                    }
                    ListElement {
                        key: "hours"
                        // factor: 60 // 1*60
                        min: 0
                        max: 23
                    }
                    ListElement {
                        key: "minutes"
                        // factor: 1
                        min: 0
                        max: 59
                    }
                }
            }

            AgeViewItem {
                enabled: haveStartDate
                ageInMinutes: root.ageInMinutes

                components: ListModel {
                    ListElement {
                        key: "weeks"
                        factor: 10080 // 7*24*60
                        min: 0
                        max: -1
                    }
                    ListElement {
                        key: "days"
                        factor: 1440 // 24*60
                        min: 0
                        max: 6
                    }
                    ListElement {
                        key: "hours"
                        factor: 60 // 1*60
                        min: 0
                        max: 23
                    }
                    ListElement {
                        key: "minutes"
                        factor: 1
                        min: 0
                        max: 59
                    }
                }
            }

            AgeViewItem {
                enabled: haveStartDate
                ageInMinutes: root.ageInMinutes

                components: ListModel {
                    ListElement {
                        key: "days"
                        factor: 1440 // 24*60
                        min: 0
                        max: -1
                    }
                    ListElement {
                        key: "hours"
                        factor: 60 // 1*60
                        min: 0
                        max: 23
                    }
                    ListElement {
                        key: "minutes"
                        factor: 1
                        min: 0
                        max: 59
                    }
                }
            }

            AgeViewItem {
                enabled: haveStartDate
                ageInMinutes: root.ageInMinutes

                components: ListModel {
                    ListElement {
                        key: "hours"
                        factor: 60 // 1*60
                        min: 0
                        max: -1
                    }
                    ListElement {
                        key: "minutes"
                        factor: 1
                        min: 0
                        max: 59
                    }
                }
            }

            AgeViewItem {
                enabled: haveStartDate
                ageInMinutes: root.ageInMinutes

                components: ListModel {
                    ListElement {
                        key: "minutes"
                        factor: 1
                        min: 0
                        max: -1
                    }
                }
            }
        }
    }
}
