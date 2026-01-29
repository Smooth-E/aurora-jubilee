# This file is part of harbour-jubilee.
# SPDX-FileCopyrightText: 2022-2026 Mirian Margiani
# SPDX-License-Identifier: GPL-3.0-or-later

# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-jubilee
CONFIG += sailfishapp

# Note: version number is configured in yaml
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += APP_RELEASE=\\\"$$RELEASE\\\"
include(libs/opal-cached-defines.pri)

include(libs/opal.pri)

SOURCES += src/harbour-jubilee.cpp

DISTFILES += qml/harbour-jubilee.qml \
    qml/cover/CoverPage.qml \
    qml/pages/*.qml \
    qml/pages/components/*.qml \
    qml/images/*.png \
    qml/py/*.py \
    qml/py/*/*.py \
    qml/js/*.js \
    qml/modules/*/*/qmldir \
    qml/modules/*/*/*/qmldir \
    qml/modules/*/*/*.qml \
    qml/modules/*/*/*/*.qml \
    qml/modules/*/*/*.py \
    qml/modules/*/*/*/*.py \
    qml/modules/*/*/*.js \
    qml/modules/*/*/*/*.js \
    rpm/harbour-jubilee.changes.in \
    rpm/harbour-jubilee.changes.run.in \
    rpm/harbour-jubilee.spec \
    rpm/harbour-jubilee.yaml \
    translations/*.ts \
    harbour-jubilee.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-jubilee-*.ts
