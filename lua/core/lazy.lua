local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

local installed, lazy = pcall(require, "lazy")
if not installed then
	return
end

lazy.setup({
	-- TODO: change foldername from pluginsnew to plugins after migration will be completed
	{ import = "pluginsnew" },
	{ import = "themes" },
})

-- TODO: move this somewhere else
local favoriteThemes = require("utils.themes")
vim.cmd.colorscheme(favoriteThemes.tokyonight.day)
