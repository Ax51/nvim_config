return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },

  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = "all",
      sync_install = false,
      ignore_install = {},
      modules = {},
      auto_install = true,
      highlight = {
        enable = true,
      },
    })
  end,
}
