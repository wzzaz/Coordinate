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

//    YHANDLE h_yf_image;
//    bool b_init = yf_ir_image_ex1_init( h_yf_image );
//    qDebug() << "yfyfyfyf " << b_init;
    wstring s_serial = get_serial_code();
    qDebug() << "main " << QString::fromStdWString(s_serial);

    QQmlApplicationEngine engine;
    qmlRegisterType<CurveItem>( "CurveItem", 1, 0, "CurveItem" );
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

