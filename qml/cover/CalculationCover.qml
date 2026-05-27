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
            topMargin: Theme.paddingSmall
            leftMargin: Theme.paddingCover
            rightMargin: Theme.paddingCover
        }

        SecondaryCoverLabel {
            text: qsTr('<b><font color="%1">Since</font></b> %2')
                  .arg(Theme.primaryColor.toString())
                  .arg(app.coverStartDateText)
        }

        SecondaryCoverLabel {
            text: qsTr('<b><font color="%1">until</font></b> %2')
                  .arg(Theme.primaryColor.toString())
                  .arg(app.coverProjectedDateText)
        }

        Item {
            width: 1
            height: Theme.paddingSmall
        }

        PrimaryCoverLabel {
            text: ageProvider.text
            font.pixelSize: Theme.fontSizeTiny
        }
    }

    AgeViewItem {
        id: ageProvider

        useWallTime: true
        ageInWall: app.ageInWall
        ageInMinutes: app.ageInMinutes
        useFormatting: false
        visible: false 

        components: ListModel {
            ListElement {
                key: "years"
                min: 0
                max: -1
            }
            ListElement {
                key: "months"
                min: 0
                max: 11
            }
            ListElement {
                key: "days"
                min: 0
                max: 29
            }
            ListElement {
                key: "hours"
                min: 0
                max: 23
            }
            ListElement {
                key: "minutes"
                min: 0
                max: 59
            }
        }
    }
}
