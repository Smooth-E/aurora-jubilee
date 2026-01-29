/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2026 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.6
import Sailfish.Silica 1.0

PageHeader {
    id: root

    Item {
        anchors {
            left: parent.left; right: parent.right
            verticalCenter: parent.verticalCenter
        }
        parent: root.extraContent
        height: root.height

        Label {
            visible: app.haveWallClock
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            color: palette.highlightColor
            text: app.wallClock ? Format.formatDate(app.wallClock.time, Formatter.TimeValue) : ''
            font.pixelSize: Theme.fontSizeMedium
        }
    }
}
