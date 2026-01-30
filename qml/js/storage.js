/*
 * This file is part of harbour-jubilee.
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2026 Mirian Margiani
 */

.pragma library
.import "../modules/Opal/LocalStorage/LocalStorage.js" as LS

//
// BEGIN Database configuration
//

var DB = new LS.Database("main", "main", "Main database")

DB.migrations = [
    // Database versions do not correspond to app versions.

    [1, function(tx){
        tx.executeSql('\
            CREATE TABLE IF NOT EXISTS _history(
                rowid INTEGER PRIMARY KEY,
                date TEXT NOT NULL,
                tz TEXT NOT NULL,
                seq INTEGER
            );
        ')
        DB.makeTableSortable(tx, "_history", "seq")
    }],
    [2, function(tx){
        tx.executeSql('\
            DROP VIEW IF EXISTS history;
        ')
        tx.executeSql('\
            ALTER TABLE _history ADD COLUMN label TEXT DEFAULT "";
        ')
        DB.makeTableSortable(tx, "_history", "seq")
    }],

    // add new versions here...
    //
    // remember: versions must be numeric, e.g. 0.1 but not 0.1.1
]


//
// BEGIN Access functions
//

function getHistoryEntries() {
    console.log("[storage] loading history entries")

    var q = DB.simpleQuery('\
        SELECT rowid, date, tz, label, seq
        FROM history
        ORDER BY seq ASC
    ;', [], {notify: true})

    var entries = []
    var len = q.rows.length

    for (var i = 0; i < len; ++i) {
        var item = q.rows.item(i)
        entries.push({
            rowid: item.rowid,
            date: item.date,
            tz: item.tz,
            label: item.label,
        })
    }

    return entries
}

function saveToHistory(date, tz) {
    var q1 = DB.simpleQuery('\
        SELECT rowid FROM history
        WHERE date = ? AND tz = ?
        LIMIT 1;', [date, tz])

    if (q1.rows.length > 0) {
        console.log("[storage] history entry", date, tz, "already exists")
        return null
    }

    console.log("[storage] adding history entry", date, tz)
    /*var q2 =*/ DB.simpleQuery('\
        INSERT INTO history(
            rowid,
            date,
            tz,
            label,
            seq
        ) VALUES (
            NULL,
            ?,
            ?,
            "",
            NULL
        )
    ', [date, tz], {notify: true})

    var q3 = DB.simpleQuery('\
        SELECT rowid, date, tz, label, seq
        FROM history
        ORDER BY seq DESC
        LIMIT 1
    ;', [])

    if (q3.rows.length > 0) {
        var item = q3.rows.item(0)
        return {
            rowid: item.rowid,
            date: item.date,
            tz: item.tz,
            label: item.label,
        }
    }

    return null
}

function setHistoryLabel(rowid, label) {
    console.log("[storage] setting label for history entry", rowid, "to", label)

    DB.simpleQuery('\
        UPDATE history
        SET label = ?
        WHERE rowid = ?
    ', [label, rowid],
    {notify: true})
}

function moveHistoryItem(rowid, newIndex) {
    var newPosition = newIndex + 1  // seq starts at 1, index at 0
    console.log("[storage] moving history entry", rowid, "to", newPosition)

    DB.simpleQuery('\
        UPDATE history
        SET seq = ?
        WHERE rowid = ?
    ', [newPosition, rowid],
    {notify: true})
}

function deleteHistoryItem(rowid) {
    console.log("[storage] deleting history entry", rowid)
    DB.simpleQuery('DELETE FROM history WHERE rowid = ?;', [rowid],
                   {notify: true})
}
