-- Basic
require("core.plugins")
require("core.mappings")
require("core.theme")
require("core.config")

-- Plugins
require("plugins.hop")
require("plugins.neotree")
require("plugins.treesitter")
require("plugins.cmp")
require("plugins.mason")
require("plugins.nullls")
require("plugins.lsp")
require("plugins.telescope")
require("plugins.lazygit")
require("plugins.comment")
require("plugins.autopairs")
require("plugins.autotag")
require("plugins.bufferline")
require("plugins.gitsigns")
require("plugins.whichkey")
require("plugins.lualine")
require("plugins.navic")
require("plugins.todo")
require("plugins.gitblame")
require("plugins.navbuddy")
require("plugins.persisted")
require("plugins.surround")
require("plugins.neotest")

if not vim.g.neovide then
	-- Disabled plugins in neovide
	require("plugins.neoscroll")
end
