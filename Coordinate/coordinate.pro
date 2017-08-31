TEMPLATE = app

QT += qml quick widgets
QT += script
QT +=  sql
CONFIG += c++11

#CONFIG += ENABLE_IRLIB
#DEFINES += ENABLE_IRLIB

SOURCES += main.cpp \
    curveitem.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DEFINES += TEMPORATE_DEBUG
INCLUDEPATH += $$PWD/ms-security/
INCLUDEPATH += $$PWD/ms-security/win32-msvc/curl/curl/
LIBS += -L$$PWD/ms-security/win32-msvc/ -lms-security
LIBS += -L$$PWD/ms-security/win32-msvc/curl/ -llibcurl_imp
LIBS += -lAdvapi32 -luser32 -lIphlpapi

HEADERS += \
    curveitem.h
