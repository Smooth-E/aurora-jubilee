/*
 * This file is part of harbour-jubilee.
 * SPDX-FileCopyrightText: 2022-2026 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

// #ifdef QT_QML_DEBUG
#include <QtQuick>
// #endif

#include <QTimeZone>

#include <sailfishapp.h>
#include "requires_defines.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    app->setOrganizationName("harbour-jubilee"); // needed for Sailjail
    app->setApplicationName("harbour-jubilee");

    QScopedPointer<QQuickView> view(SailfishApp::createView());

    view->engine()->addImportPath(SailfishApp::pathTo("qml/modules").toString());

    view->rootContext()->setContextProperty("APP_VERSION", QString(APP_VERSION));
    view->rootContext()->setContextProperty("APP_RELEASE", QString(APP_RELEASE));

    view->rootContext()->setContextProperty("LOCAL_TIMEZONE", QString(QTimeZone::systemTimeZoneId()));

    view->setSource(SailfishApp::pathToMainQml());
    view->show();
    return app->exec();
}
