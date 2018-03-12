#include "bgstate.h"
#include <iostream>

BGState::BGState(QObject *parent) : QObject(parent)
{
    m_lua.open_libraries(sol::lib::base, sol::lib::io, sol::lib::string, sol::lib::package, sol::lib::math, sol::lib::table, sol::lib::os, sol::lib::debug);
    m_lua.script("function add_pp(val) package.path = package.path .. val .. ';' end") ;
    loadLuaRocks();
}

BGState::Errors BGState::search(QString rockname, QString version, QString options)
{
    try{
        sol::optional<std::string> result =
                m_lua["command_line"]["run_command"]("search", rockname.toUtf8());
        if(!result)
        {
            //fail here
        }
        else
        {
            emit lrStdOut(QString::fromStdString(result.value_or("ERROR")));
        }
        return SunShine;
    }
    catch(sol::error err){
        lrError(err.what());
        _dead = true;
        return LuaIsDead;
    }
}

BGState::Errors BGState::installRock(QString rockname, QString version, QString options)
{
    try{
        sol::optional<std::string> result =
                m_lua["command_line"]["run_command"]("search", rockname.toUtf8());
        if(!result)
        {
            //fail here
        }
        else
        {
            emit lrStdOut(QString::fromStdString(result.value_or("ERROR")));
        }
        return SunShine;
    }
    catch(sol::error err){
        lrError(err.what());
        _dead = true;
        return BGState::Errors::LuaIsDead;
    }
}

/**
 * @brief BGState::runScript strictly lfor testing. Run a raw script, expects string output.
 * @param script QString containing Lua Script.
 * @return
 */
void BGState::runScript(QString script)
{
    sol::optional<std::string> result = m_lua.script(script.toStdString(),
                                                     sol::script_default_on_error);
    if(!result)
    {
        //fail here
    }
    else
    {
        emit lrStdOut(QString::fromStdString(result.value_or("ERROR")));
    }
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
//        m_lua["command_line"]["run_command"]("search", "lua-http");
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
