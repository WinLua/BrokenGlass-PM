

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
    //OUTPUT to console will be connected via signal from bgstate

    enum Errors { SunShine = 0, LuaIsDead = -1, NoNetwork = -2, NoPermissions = -3, NoIdea = -4 };
    Q_ENUM(Errors)

    Q_INVOKABLE Errors search(QString rockname, QString version, QString options);
    Q_INVOKABLE Errors installRock(QString rockname, QString version, QString options);


signals:
    void lrStdOut(QString value);
    void lrError(QString value);
public slots:

private:
    sol::state m_lua;
    bool _dead;
    bool loadLuaRocks();
    void addPackagePath(QString path);
    void runScript(QString script);

//    'scripts\LuaRocks\luarocks.lua'
};

#endif // BGSTATE_H
