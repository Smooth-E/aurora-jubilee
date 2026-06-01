/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2026 Smooth-E
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "wallclock.h"

WallClock::WallClock(QObject *parent)
    : QObject(parent)
    , m_timer(this)
{
    QObject::connect(&m_timer, &QTimer::timeout, this, &WallClock::dateTimeChanged);

    m_timer.setInterval(1000 * 60);
    m_timer.setSingleShot(false);
    m_timer.start();
}

QDateTime WallClock::dateTime() const
{
    return QDateTime::currentDateTime();
}
