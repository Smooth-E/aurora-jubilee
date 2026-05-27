/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2026 Mirian Margiani
 * SPDX-FileCopyrightText: 2026 Smooth-E
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.6
import Sailfish.Silica 1.0
import Opal.Delegates 1.0
import "../js/math.js" as M

PaddedDelegate {
    id: root

    readonly property alias text: label.text

    property bool useWallTime: false
    property var ageInWall: ({
        years: 0, months: 0, days: 0, hours: 0, minutes: 0
    })
    property string ageInMinutes: M.value(0).toString()
    property ListModel components: ListModel {}
    property var _values: []
    property bool useFormatting: true

    function _setValue(index, newValue) {
        var item = components.get(index)
        newValue = M.value(newValue)
        var currentValue = _values[index]
        var updated = null

        if (useWallTime) {
            if (M.value(currentValue).eq(newValue)) {
                return
            }

            _values[index] = newValue
            updated = JSON.parse(JSON.stringify(ageInWall))

            if (item.key == 'months' && index == 0) {
                updated["years"] = Math.floor(M.value(newValue).toNumber() / 12)
                updated["months"] = M.value(newValue).toNumber() % 12
            } else {
                updated[item.key] = M.value(newValue).toNumber()
            }

            app.projectWall(updated)
        } else {
            var factor = components.get(index).factor
            updated = M.value(ageInMinutes)
            updated = updated.minus(currentValue.times(factor))
            updated = updated.plus(newValue.times(factor))

            if (M.value(ageInMinutes).eq(updated)) {
                return
            } else {
                _values[index] = newValue
                app.projectMinutes(updated.toString())
            }
        }

        _updateValues()
    }

    function _labelByKey(key, n) {
        if (key === "years") {
            return qsTr("year(s)", "", n)
        } else if (key === "months") {
            return qsTr("month(s)", "", n)
        } else if (key === "weeks") {
            return qsTr("week(s)", "", n)
        } else if (key === "days") {
            return qsTr("day(s)", "", n)
        } else if (key === "hours") {
            return qsTr("hour(s)", "", n)
        } else if (key === "minutes") {
            return qsTr("minute(s)", "", n)
        }
        return "[error]"
    }

    function _updateValues() {
        var ret = useFormatting ? "<center><font size='3'>" : ""
        var newValues = []
        var count = root.components.count
        var remainder = M.value(ageInMinutes)

        for (var i = 0; i < count; ++i) {
            var value = 0
            var item = root.components.get(i)

            if (useFormatting) {
                // set "hour" and "minutes" on a separate line in
                // a smaller font *if* there are more components in this view
                var fontSize = '4'
                if (count >= 3) {
                    if (i == count-2) {
                        ret += "<font size='0'><br/></font>"
                    }
                    if (i >= count-2) {
                        fontSize = '2'
                        ret += "<font size='" + fontSize + "'>"
                    }
                }
            }

            if (useWallTime) {
                value = M.value(ageInWall[item.key])

                if (item.key == 'months' && i == 0) {
                    value = value.plus(M.value(ageInWall["years"]).times(12))
                }
            } else {
                value = remainder.div(item.factor).integerValue(M.BigNumber.ROUND_FLOOR)
                remainder = remainder.mod(item.factor)
            }

            if (useFormatting) {
                ret += "<font size='" + fontSize + "' color='%1'>" +
                        M.format(value, 0) +
                        "</font>&nbsp;"
            } else {
                ret += M.format(value, 0) + " "
            }

            ret += _labelByKey(item.key, M.value(value).toNumber())
            ret += (i < count-1 ? useFormatting ? ",&nbsp;&nbsp;" : ",\n" : "")

            if (useFormatting && count >= 3 && i >= count-2) {
                ret += "</font>"
            }

            newValues.push(value)
        }

        if (useFormatting) {
            ret += "</font></center>"
        }

        _values = newValues
        label.text = useFormatting ? ret.arg(highlighted ? Theme.highlightColor : Theme.primaryColor) : ret
    }

    onClicked: openMenu()
    onAgeInMinutesChanged: if (!useWallTime) _updateValues()
    onAgeInWallChanged: if (useWallTime) _updateValues()
    onHighlightedChanged: _updateValues()

    width: parent.width
    contentHeight: Math.max(label.height + 2*Theme.paddingMedium, Theme.itemSizeSmall)

    Label {
        id: label

        width: parent.width - 2*x
        height: implicitHeight
        anchors.verticalCenter: parent.verticalCenter
        x: Theme.horizontalPageMargin

        text: ""

        textFormat: Text.RichText
        color: Theme.highlightColor

        font.pixelSize: Theme.fontSizeLarge
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignVCenter
    }

    menu: Component {
        ContextMenu {
            Repeater {
                model: components

                delegate: Item {
                    width: parent.width
                    height: childrenRect.height

                    Slider {
                        id: slider

                        visible: model.max >= 0 && Math.abs(model.max - model.min) <= 100
                        minimumValue: Math.min(model.min, model.max)
                        maximumValue: Math.max(model.min, model.max)
                        value: visible ? _values[index].toNumber() : 0
                        width: parent.width
                        label: _labelByKey(model.key, 100)
                        stepSize: 1

                        onValueChanged: {
                            if (!visible) return
                            _setValue(index, value)
                        }
                    }

                    TextField {
                        visible: !slider.visible
                        inputMethodHints: Qt.ImhDigitsOnly
                        text: visible ? M.string(_values[index], 0) : 0
                        label: _labelByKey(model.key, 100)
                        placeholderText: _labelByKey(model.key, 100)

                        acceptableInput: {
                            if (!visible) return false

                            var value = M.value(M.expand(M.cleanNumberString(text) || -1))

                            return (model.max > 0 ? value.lte(model.max) : true)
                                    && value.gte(Math.max(model.min, 0))
                        }

                        onClicked: selectAll()
                        EnterKey.onClicked: {
                            focus = false
                            closeMenu()
                        }

                        onTextChanged: {
                            if (!visible) return

                            var value = M.value(M.expand(M.cleanNumberString(text) || -1))

                            if (value.lt(0)) return

                            _setValue(index, value)
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        _updateValues()
    }
}
