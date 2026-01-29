/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2026 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.6
import Sailfish.Silica 1.0

PullDownMenu {
    MenuItem {
        text: qsTr("About")
        onClicked: pageStack.animatorPush(Qt.resolvedUrl("../pages/AboutPage.qml"))
    }

    /*MenuItem {
        text: qsTr("Settings")
        onClicked: pageStack.animatorPush(Qt.resolvedUrl("SettingsPage.qml"))
    }*/

    MenuItem {
        text: qsTr("Pick a new date")
        onClicked: app.pickNewDate()
    }
}
