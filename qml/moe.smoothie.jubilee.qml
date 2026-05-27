/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2022-2026 Mirian Margiani
 * SPDX-FileCopyrightText: 2026 Smooth-E
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.6
import Sailfish.Silica 1.0
import Opal.About 1.0 as A
import Opal.SupportMe 1.0 as M
import Opal.LocalStorage 1.0 as L

import "js/dates.js" as Dates
import "js/storage.js" as Storage
import "pages"
import "py"

ApplicationWindow {
    id: app

    readonly property bool isLandscape: orientation | Orientation.LandscapeMask
    readonly property real coverTopPadding: isLandscape ? Theme.paddingLarge : Theme.paddingMedium

    property string coverStartDateText
    property string coverProjectedDateText

    property QtObject wallClock
    property bool haveWallClock: wallClock != null
    readonly property string appName: qsTr("Jubilee")

    property ListModel historyModel: ListModel {}
    property string currentDate
    property string currentTz

    property string ageInMinutes: M.value(0).toString()
    property var ageInWall: ({
        years: 0, months: 0, days: 0, hours: 0, minutes: 0
    })

    signal coverAction()
    signal pickNewDate()
    signal switchToCalcView()
    signal setNewDate(var date, var tz)
    signal newAgeCalculated(var result)
    signal newDateProjected(var date, var tz)

    function calculateAge(start, startTz, till, tillTz) {
        py.call('calc.calculateAge',
                [start, startTz, till, tillTz],
                function(result){
            newAgeCalculated(result)
        })
    }

    function _doProject(method, values) {
        py.call('calc.' + method, [currentDate, currentTz, values, LOCAL_TIMEZONE],
                function(result){
            newAgeCalculated(result.age)
            newDateProjected(result.date, result.tz)
        })
    }

    function projectMinutes(ageInMinutes /*BigNumber string*/) {
        _doProject("projectMinutes", ageInMinutes)
    }

    function projectWall(walltime) {
        _doProject("projectWall", walltime)
    }

    function getYearsForDate(start, startTz, callback) {
        var now = Dates.formatDate(new Date(), Dates.dbDateFormat, "")
        py.call('calc.calculateAge', [start, startTz, now, LOCAL_TIMEZONE], callback)
    }

    onSetNewDate: {
        var newEntry = Storage.saveToHistory(date, tz)

        if (!!newEntry) {
            historyModel.append(newEntry)
        }

        currentTz = tz
        currentDate = date
    }

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl(!!app.currentDate ? "cover/CalculationCover.qml" : "cover/WelcomeCover.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All

    onCoverAction: pickNewDate()

    onNewAgeCalculated: {
        ageInMinutes = result.minutes
        ageInWall = result.wall

        console.log("new age calculated:", ageInMinutes, JSON.stringify(ageInWall))
    }

    A.ChangelogNews {
        changelogList: Qt.resolvedUrl("Changelog.qml")
    }

    M.AskForSupport {
        contents: Component {
            MySupportDialog {}
        }
    }

    L.MessageHandler {
        //
    }

    PythonBackend {
        id: py

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('py/libs'))
            py.importModule('calc', function() {})
        }
    }

    Component.onCompleted: {
        // Extensions that are not crucial and are generally not allowed in
        // Jolla's Harbour store are loaded dynamically. The app will handle
        // it gracefully if loading fails.

        // Avoid hard dependency on Nemo.Time and load it in a complicated
        // way to make Jolla's validator script happy.
        wallClock = Qt.createQmlObject("
            import QtQuick 2.0
            import %1 1.0
            WallClock {
                enabled: Qt.application.active
                updateFrequency: WallClock.Minute
            }".arg("Nemo.Time"), app, 'WallClock')

        var entries = Storage.getHistoryEntries()

        for (var i = 0; i < entries.length; ++i) {
            historyModel.append(entries[i])
        }
    }
}
