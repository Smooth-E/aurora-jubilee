/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2022-2026 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.6
import Sailfish.Silica 1.0
import Opal.Tabs 1.0

Page {
    id: root
    allowedOrientations: Orientation.All

    TabView {
        id: tabView
        anchors.fill: parent
        currentIndex: 0
        tabBarPosition: Qt.AlignBottom
        tabBarVisible: !app.hideTabBar

        Tab {
            title: qsTr("Calculations")
             description: "                                        "
             icon: "image://theme/icon-m-date"
            source: Qt.resolvedUrl("CalcView.qml")
        }

        Tab {
            title: qsTr("History")
             description: "                                        "
             icon: "image://theme/icon-m-history"
            source: Qt.resolvedUrl("HistoryView.qml")
        }
    }

    Connections {
        target: app
        onSwitchToCalcView: {
            tabView.currentIndex = 0
        }
    }
}
