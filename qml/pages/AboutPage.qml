/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2022-2026 Mirian Margiani
 * SPDX-FileCopyrightText: 2026 Smooth-E
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

/*
 * Translators:
 * Please add yourself to the list of translators in TRANSLATORS.json.
 * If your language is already in the list, add your name to the 'entries'
 * field. If you added a new translation, create a new section in the 'extra' list.
 *
 * Other contributors:
 * Please add yourself to the relevant list of contributors below.
 *
*/

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.About 1.0 as A

A.AboutPageBase {
    id: root

    appName: app.appName
    appIcon: Qt.resolvedUrl("../images/moe.smoothie.jubilee.png")
    appVersion: APP_VERSION
    appRelease: APP_RELEASE

    sourcesUrl: "https://github.com/Smooth-E/aurora-jubilee"
    changelogList: Qt.resolvedUrl("../Changelog.qml")
    licenses: A.License { spdxId: "GPL-3.0-only" }

    donations.text: qsTr("If you found this app helpful, feel welcome to support the original "
                        + "developer or the Aurora OS port maintainer by donating.")

    donations.services: [
        A.DonationService {
            name: qsTr("App dev's Liberapay")
            url: "https://liberapay.com/ichthyosaurus"
        },
        A.DonationService {
            name: qsTr("Port maintainer's Boosty")
            url: "https://boosty.to/smooth-e/donate"
        }
    ]

    description: qsTr("An app to calculate anniversaries.")

    mainAttributions: [
        "2026 Smooth‑E",
        "2023-%1 Mirian Margiani".arg((new Date()).getFullYear())
    ]

    attributions: [
        A.Attribution {
            name: "Bignumber.js"
            entries: ["2025 Michael Mclaughlin"]
            licenses: A.License { spdxId: "MIT" }
            sources: "https://github.com/MikeMcl/big.js"
            homepage: "http://mikemcl.github.io/big.js"
        },
        A.Attribution {
            name: "python-dateutil"
            entries: ["Gustavo Niemeyer", "Paul Ganssle"]
            homepage: "https://github.com/dateutil/dateutil"
            licenses: [
                A.License { spdxId: "Apache-2.0" },
                A.License { spdxId: "BSD-3-Clause" }
            ]
        },
        A.Attribution {
            name: "PyOtherSide"
            entries: ["2011, 2013-2020 Thomas Perl"]
            licenses: A.License { spdxId: "ISC" }
            sources: "https://github.com/thp/pyotherside"
            homepage: "https://thp.io/2011/pyotherside/"
        }
    ]

    contributionSections: [
        A.ContributionSection {
            title: qsTr("Development")
            groups: [
                A.ContributionGroup {
                    title: qsTr("Aurora OS Port")
                    entries: ["Smooth‑E"]
                },
                A.ContributionGroup {
                    title: qsTr("Programming")
                    entries: ["Mirian Margiani", "Smooth‑E"]
                }/*,
                A.ContributionGroup {
                    title: qsTr("Icon Design")
                    entries: ["Mirian Margiani"]
                }*/
            ]
        },

        //>>> GENERATED LIST OF TRANSLATION CREDITS
        A.ContributionSection {
            title: qsTr("Translations")
            groups: []
        }
        //<<< GENERATED LIST OF TRANSLATION CREDITS
    ]
}
