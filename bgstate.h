#ifndef BGSTATE_H
#define BGSTATE_H

#include <QObject>
#include <QString>
#include "sol.hpp"

class BGState : public QObject
{
    Q_OBJECT
public:
    explicit BGState(QObject *parent = nullptr);
    Q_INVOKABLE QString returnString(QString script);
    Q_INVOKABLE float returnNumber(QString script);
    Q_INVOKABLE sol::table returnTable(QString script);
    Q_INVOKABLE bool returnBoolean(QString script);
signals:

public slots:

private:
    sol::state m_lua;
    bool loadLuaRocks();
    bool addPackagePath(QString path);
    sol::object runScript(QString script);
};

#endif // BGSTATE_H
