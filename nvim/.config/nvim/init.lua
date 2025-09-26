-- Put this at the *very* top of your init.lua
-- Lua module loader only available in NeoVim 0.9.0+
if vim.loader then
	-- enable the Lua module loader for faster startup time
	-- scans .lua files and caches the results in a smarter way.
	vim.loader.enable()
end

require("core")
require("plugin-manager")
