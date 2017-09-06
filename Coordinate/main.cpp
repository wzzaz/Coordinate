#include <QApplication>
#include <QQmlApplicationEngine>
#include "curveitem.h"
#include "../ms-security/ms-security.h"
#include <QDebug>
using namespace yflib;
using namespace std;
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<CurveItem>( "CurveItem", 1, 0, "CurveItem" );
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

