#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "bgstate.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qmlRegisterType<BGState>("com.winlua.brokenglass.bgstate", 1, 0, "BGState");

//    bgstate lua;
//    lua.RunScript(QString::fromUtf8("print(_VERSION) return VERSION"));
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
