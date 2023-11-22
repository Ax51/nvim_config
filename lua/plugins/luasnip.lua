return {
	"L3MON4D3/LuaSnip",
	lazy = true,

	config = function()
		-- NOTE: my custom snippets
		require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "./snippets" } })
	end,
}
