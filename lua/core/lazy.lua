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

local theme = { name = "tokyonight", mode = "day" }
local getThemesTable, favoriteThemes = unpack(require("themes"))

local lazyOpts = {
	checker = {
		check_pinned = true,
	},
}

lazy.setup({
	{ import = "plugins" },
	getThemesTable(theme.name),
}, lazyOpts)

-- TODO: move this somewhere else
vim.cmd.colorscheme(favoriteThemes[theme.name][theme.mode])
