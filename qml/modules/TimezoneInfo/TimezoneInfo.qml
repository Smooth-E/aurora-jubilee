/*
 * This file is part of harbour-dashboard
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022-2026  Mirian Margiani
 */

pragma Singleton

import QtQuick 2.6
import QtQml 2.2
import QtQml.Models 2.2
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

// The *TimezoneModel* (from Sailfish.Timezone) is not documented and the API
// is not public. It is possible to take a look at the model's methods:
//
// for(var it in timezoneProxyModel.model) {
//     console.log(it + " = " + timezoneProxyModel.model[it])
// }
//
// However, it is not possible to access items directly.
// This is why we need the DelegateModel as a proxy (see findTimezoneInfo()
// for how to access items).
//
// From the code at </usr/lib>/qt5/qml/Sailfish/Timezone/ and from strings
// in libsailfishtimezoneplugin.so, we can glean the following properties:
//
// model.name                 -- "Pacific/Pago_Pago"
//       area                 -- "Pacific"
//       city                 -- "Rarotonga"
//       country              -- "Cook Islands"
//       offset               -- "UTC+1:00"
//       offsetWithDstOffset  -- "UTC+1:00 (+2:00)"
//       currentOffset        -- "UTC+2:00"
//       sectionOffset        -- "UTC+1:00"
//       filter               -- ?

QtObject {
    id: root

    readonly property var model: _proxyModel
    readonly property bool ready: _proxyModelArray !== null

    readonly property string __lc: "[TimezoneInfo]"
    readonly property var __lookupCache: ({})

    property ListModel _proxyModel: ListModel { }
    property var _proxyModelArray: null

    readonly property Python _python: Python {
        Component.onCompleted: {
            console.log(__lc, "Adding import path", Qt.resolvedUrl("."))
            addImportPath(Qt.resolvedUrl("."))
            importModule("timezoneinfo", function() { console.error(__lc, "Error importing module") })
            
            console.log(__lc, "Initializing model...")
            call("timezoneinfo.get_timezones", [ Qt.locale().name ], function(result) { 
                _proxyModelArray = result
                for (var i = 0; i < result.length; i++) {
                    _proxyModel.append(result[i])
                }
            })
        }
    }

    function findTimezoneInfo(queryName) {
        queryName = String(queryName)

        if (__lookupCache.hasOwnProperty(queryName)) {
            // console.debug(__lc, "using cached timezone info for “%1”".arg(queryName))
            return __lookupCache[queryName]
        }

        if (_proxyModel.count === 0) {
            console.log(__lc, "cannot lookup timezone info for “%1”: model is not yet ready".arg(queryName))
            return null
        }

        var count = _proxyModel.count
        for (var i = 0; i < count; ++i) {
            var item = _proxyModelArray[i]

            if (item.name === queryName) {
                console.log(__lc, "found timezone info for “%1”:".arg(queryName),
                            item.area, "/", item.city, "@", item.offset)
                __lookupCache[queryName] = item
                return item
            }
        }

        console.warn(__lc, "could not find timezone info for “%1”".arg(queryName))
        return null
    }
}
