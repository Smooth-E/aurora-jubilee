/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2023-2026 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.6
import Sailfish.Silica 1.0
import Opal.Delegates 1.0
import io.thp.pyotherside 1.5
import TimezoneInfo 1.0

import "../js/dates.js" as Dates

TwoLineDelegate {
    id: root

    property bool handleClick: true
    property string date: ""
    property string placeholderText: qsTr("pick a date")
    property string tz: LOCAL_TIMEZONE
    property var tzInfo: TimezoneInfo.findTimezoneInfo(tz)

    function pick() {
        var dateParsed = Dates.parseDate(date)
        var newDate = ''
        var newTime = ''

        var datePicker = pageStack.push("Sailfish.Silica.DatePickerDialog", {
            date: dateParsed || "",
            forwardNavigation: Qt.binding(function(){
                // this is a workaround for a bug in DatePickerDialog that
                // prevents setting a custom acceptDestination when no date
                // is preselected:
                //    forwardNavigation: _showYearSelectionFirst ? false : !_belowTop
                return true
            }),
            acceptDestination: "Sailfish.Silica.TimePickerDialog",
            acceptDestinationAction: PageStackAction.Push,
            acceptDestinationProperties: {
                hour: !!dateParsed ? dateParsed.getHours() : 0,
                minute: !!dateParsed ? dateParsed.getMinutes() : 0,

                acceptDestination: Qt.resolvedUrl("../pages/TimezonePicker.qml"),
                acceptDestinationAction: PageStackAction.Push,
            }
        })

        datePicker.accepted.connect(function() {
            var timePicker = datePicker.acceptDestinationInstance
            newDate = Qt.formatDate(datePicker.date, 'yyyy-MM-dd')

            timePicker.accepted.connect(function() {
                newTime = Qt.formatTime(timePicker.time, 'hh:mm:ss')

                var tzPicker = timePicker.acceptDestinationInstance

                tzPicker.timezoneClicked.connect(function(name){
                    pageStack.pop(pageStack.previousPage(datePicker))

                    if (!!name) {
                        tz = name
                    } else {
                        tz = LOCAL_TIMEZONE
                    }

                    tzInfo = TimezoneInfo.findTimezoneInfo(tz) // breaks the binding
                    date = newDate + ' ' + newTime
                    root.dateChanged() // always notify in case tz changed
                    console.log("picked date:", date, tz)
                })
            })
        })
    }

    function updateText() {
        text = Dates.formatDate(date, Dates.fullDateTimeFormat, !!tzInfo ? tzInfo.city : tz, placeholderText)
    }

    text: ""
    textLabel {
        font.pixelSize: Theme.fontSizeExtraLarge
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
    }

    descriptionLabel {
        font.pixelSize: Theme.fontSizeMedium
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
    }

    onClicked: {
        if (handleClick) {
            pick()
        }
    }

    onDateChanged: {
        updateText()
    }

    Component.onCompleted: {
        updateText()
    }
}
