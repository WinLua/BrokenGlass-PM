#include "bgstate.h"
#include <iostream>

BGState::BGState(QObject *parent) : QObject(parent)
{
    m_lua.open_libraries(sol::lib::base, sol::lib::io, sol::lib::string, sol::lib::package, sol::lib::math, sol::lib::table, sol::lib::os, sol::lib::debug);
    m_lua.script("function add_pp(val) package.path = package.path .. val .. ';' end") ;
    loadLuaRocks();
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
    return m_lua.script(script.toStdString(),
                        sol::script_default_on_error);
}

void BGState::addPackagePath(QString path)
{
    m_lua["add_pp"](path.toStdString());
    m_lua.script("print(package.path)");
}

bool BGState::loadLuaRocks()
{
    try{
    m_lua.script_file("C:\\Users\\russh\\git\\BrokenGlass\\build-64bit-Debug\\debug\\scripts\\LuaRocks\\luarocks.lua");
    m_lua["command_line"]["run_command"]("search", "lua-http");
    return true;
    }
    catch(sol::error err){
        std::cout << err.what() << std::endl;
        exit(-1);
    }
}

//QString BGState::search(QString value)
//{

//}
