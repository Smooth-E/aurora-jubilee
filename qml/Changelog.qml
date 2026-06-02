/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2026 Mirian Margiani
 * SPDX-FileCopyrightText: 2026 Smooth-E
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.6
import "modules/Opal/About"

ChangelogList {
    ChangelogItem {
        version: "1.0.0.1-1"
        date: "2026-06-02"
        paragraphs: [
            "- Первый релиз для ОС Аврора<br/>" +
            "- Компоненты pyotherside, cpython, python-dateutil и babel теперь поставляются вместе с приложением<br/>" +
            "- Компонент Nemo.WallClock заменен реализацией внутри приложения<br/>" +
            "- Системный диалог выбора часового пояса заменен реализацией внутри приложения<br/>" +
            "- Добавлены переводы на Русский язык<br/>" +
            "- Изменена панель с вкладками<br/>" +
            "- Добавлена информативная обложка"
        ]
    }
    ChangelogItem {
        version: "1.0.0-1"
        date: "2026-02-12"
        paragraphs: [
            "- initial release"
        ]
    }
}
