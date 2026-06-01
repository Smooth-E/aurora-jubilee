/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2022-2026 Mirian Margiani
 * SPDX-FileCopyrightText: 2026 Smooth-E
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

// #ifdef QT_QML_DEBUG
#include <QtQuick>
// #endif

#include <QTimeZone>

#include <auroraapp.h>
#include "wallclock.h"
#include "requires_defines.h"

int main(int argc, char *argv[])
{
    if (qputenv("PYTHONHOME", QString("/usr/share/moe.smoothie.jubilee/").toUtf8().constData())) {
        qDebug() << "Successfully set python home";
    } else {
        qDebug() << "Failed to set python home";
    }

    QScopedPointer<QGuiApplication> app(Aurora::Application::application(argc, argv));
    app->setOrganizationName("moe.smoothie");
    app->setApplicationName("jubilee");

    QScopedPointer<QQuickView> view(Aurora::Application::createView());

    view->engine()->addImportPath(Aurora::Application::pathTo("qml/modules").toString());

    view->rootContext()->setContextProperty("APP_VERSION", QString(APP_VERSION));
    view->rootContext()->setContextProperty("APP_RELEASE", QString(APP_RELEASE));

    view->rootContext()->setContextProperty("LOCAL_TIMEZONE", QString(QTimeZone::systemTimeZoneId()));

    // Vendored pyotherside
    view->engine()->addImportPath(Aurora::Application::pathTo("lib/qt5/qml").toString());

    qmlRegisterType<WallClock>("Jubilee", 1, 0, "WallClock");

    view->setSource(Aurora::Application::pathToMainQml());
    view->show();
    return app->exec();
}
