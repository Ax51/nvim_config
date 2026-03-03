return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },

  branch = "main",

  init = function()
    -- custom parsers
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        require("nvim-treesitter.parsers").ghactions = {
          install_info = {
            url = "https://github.com/rmuir/tree-sitter-ghactions",
            queries = "queries",
          },
        }
      end,
    })
  end,

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
        "json",
        "jsonc",
        "copilot-chat",
        "proto",
        "yaml",
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
  end,
}
