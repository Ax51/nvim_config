return {
  "folke/which-key.nvim",


  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  keys = {
    "<space>",
    "y",
    "g",
    "c",
    "v",
    "z",
    "z",
    "[",
    "]",
  },

  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,

  config = function()
    local wk = require("which-key")

    wk.add({
      { "<leader>E",  desc = "Right side file Manager" },
      { "<leader>G",  group = "Git options" },
      { "<leader>Gl", desc = "Toggle GitBlame" },
      { "<leader>Q",  group = "Close Buffer & it's tab" },
      { "<leader>Q!", desc = "Quit NVIM" },
      { "<leader>QA", desc = "Close all buffers except current" },
      { "<leader>X",  desc = "Select tabs to close" },
      { "<leader>e",  desc = "Float file Manager" },
      { "<leader>f",  group = "Find" },
      { "<leader>fF", desc = "Find File in selected directories" },
      { "<leader>fW", desc = "Find by word in selected directories" },
      { "<leader>fb", desc = "Find Buffer" },
      { "<leader>fc", desc = "Show `// COMMENTS:`" },
      { "<leader>ff", desc = "Find File" },
      { "<leader>fh", desc = "Find Help" },
      { "<leader>fm", desc = "Show marks" },
      { "<leader>fp", desc = "Show persisted sessions" },
      { "<leader>fs", desc = "Show file Symbols" },
      { "<leader>fw", desc = "Find by word" },
      { "<leader>g",  group = "Git" },
      { "<leader>h",  desc = "No highlight" },
      { "<leader>l",  group = "LSP" },
      { "<leader>lD", desc = "Hover diagnostic" },
      { "<leader>la", desc = "Action" },
      { "<leader>ld", desc = "Diagnostic" },
      { "<leader>lf", desc = "Format" },
      { "<leader>lr", desc = "Rename" },
      { "<leader>ls", desc = "Symbol" },
      { "<leader>m",  group = "Hop" },
      { "<leader>o",  desc = "Git status" },
      { "<leader>q",  desc = "Close Buffer" },
      { "<leader>r",  group = "Run" },
      { "<leader>rj", desc = "Execute JS script with Bun" },
      { "<leader>rs", desc = "Execute entire paragraph as shell script" },
      { "<leader>t",  group = "Tests" },
      { "<leader>tS", desc = "Stop running tests" },
      { "<leader>t[", desc = "Navigate to the prev test" },
      { "<leader>t]", desc = "Navigate to the next test" },
      { "<leader>ta", desc = "Run all nested tests" },
      { "<leader>tl", desc = "Run last test" },
      { "<leader>to", desc = "Show error output" },
      { "<leader>ts", desc = "Show summary" },
      { "<leader>tt", desc = "Run nearest test" },
      { "<leader>w",  desc = "Save" },
      { "<leader>x",  desc = "Close active splitted screen" },
      { "<leader>z",  group = "Zen mode" },
      { "<leader>za", desc = "Ataraxis mode" },
      { "<leader>zf", desc = "Focus mode" },
      { "<leader>zm", desc = "Minimalist mode" },
      { "<leader>zn", desc = "Narrow mode" },
      { "<leader>zt", desc = "Toggle Twilight mode" },
    }, { prefix = "<leader>" })
  end,
}
