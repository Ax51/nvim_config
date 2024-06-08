return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  ft = { "jsx", "tsx" },

  config = function()
    require("ts_context_commentstring").setup({
      enable_autocmd = false,
    })
  end,
}
