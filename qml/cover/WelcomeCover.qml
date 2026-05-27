/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2026 Smooth-E
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.6
import Sailfish.Silica 1.0

import "../components"

CoverBackground {    
    Column {
        anchors {
            fill: parent
            topMargin: app.coverTopPadding
            leftMargin: Theme.paddingCover
            rightMargin: Theme.paddingCover
        }

        spacing: Theme.paddingSmall

        PrimaryCoverLabel {
            text: qsTr("Welcome to Jubilee!")
        }

        SecondaryCoverLabel {
            text: qsTr("Pick a pair of dates to start calculating.")
        }
    }

    CoverActionList {
        CoverAction {
            iconSource: "image://theme/icon-cover-new"

            onTriggered: app.coverAction()
        }
    }
}
