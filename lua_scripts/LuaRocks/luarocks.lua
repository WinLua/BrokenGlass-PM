#!/usr/bin/env lua

-- this should be loaded first.
local cfg = require("luarocks.core.cfg")

local loader = require("luarocks.loader")
local command_line = require("luarocks.command_line")

program_description = "LuaRocks main command-line interface"

commands = {
   help = "luarocks.cmd.help",
   pack = "luarocks.cmd.pack",
   unpack = "luarocks.cmd.unpack",
   build = "luarocks.cmd.build",
   install = "luarocks.cmd.install",
   search = "luarocks.cmd.search",
   list = "luarocks.cmd.list",
   remove = "luarocks.cmd.remove",
   make = "luarocks.cmd.make",
   download = "luarocks.cmd.download",
   path = "luarocks.cmd.path",
   show = "luarocks.cmd.show",
   new_version = "luarocks.cmd.new_version",
   lint = "luarocks.cmd.lint",
   write_rockspec = "luarocks.cmd.write_rockspec",
   purge = "luarocks.cmd.purge",
   doc = "luarocks.cmd.doc",
   upload = "luarocks.cmd.upload",
   config = "luarocks.cmd.config",
   which = "luarocks.cmd.which",
}

command_line.run_command(...)
