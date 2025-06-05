return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },

  branch = "main",

  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "rust",
        "javascript",
        "typescript",
        "typescriptreact",
        "javascriptreact",
        "lua",
        "python",
        "go",
        "sh",
        "markdown",
        "mdx",
        "yaml",
        "json",
        "jsonc",
      },
      callback = function()
        -- NOTE: syntax highlighting, provided by Neovim
        vim.treesitter.start()
        -- NOTE: folds, provided by Neovim
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        -- NOTE: indentation, provided by nvim-treesitter
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end
}
