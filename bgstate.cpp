#include "bgstate.h"
#include <iostream>

BGState::BGState(QObject *parent) : QObject(parent)
{
    m_lua.open_libraries(sol::lib::base, sol::lib::io, sol::lib::string, sol::lib::package, sol::lib::math, sol::lib::table);
    m_lua.script("function add_pp(val) package.path = package.path .. val .. ';' end") ;
}

QString BGState::returnString(QString script)
{
    sol::object result = runScript(script);
    if(result.get_type() == sol::type::string)
    {
        return QString::fromStdString(result.as<std::string>());
    }
    else
    {
        return QString::null;
    }
}

float BGState::returnNumber(QString script)
{
    return 0.0;
}

sol::table BGState::returnTable(QString script)
{
    return sol::nil;
}

bool BGState::returnBoolean(QString script)
{
    return false;
}



sol::object BGState::runScript(QString script)
{
    try
    {
        return m_lua.script(script.toStdString(),
                                          sol::script_default_on_error);
    }
    catch (sol::error& err)
    {
        std::cout << "Oops: " << err.what() << std::endl;
        return sol::nil;
    }
}

bool BGState::addPackagePath(QString path)
{
    try{
        m_lua["add_pp"](path.toStdString());
        m_lua.script("print(package.path)");
        return true;
    }
    catch(sol::error err){
        std::cout << err.what() << std::endl;
        return false;
    }
}

bool BGState::loadLuaRocks()
{
    try{
        m_lua.script("lr = require('luarocks')");
        return true;
    }
    catch(sol::error err){
        std::cout << err.what() << std::endl;
        return false;
    }
}
