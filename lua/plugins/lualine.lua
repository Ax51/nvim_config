return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local lualine_utils = require("utils.lualine_helpers")

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "⏽", right = "⏽" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "diagnostics" },
        lualine_c = {
          { "filename", path = 1 },
        },
        lualine_x = {
          lualine_utils.copilot_status_line,
          lualine_utils.sidekick_status_line,
          "progress",
        },
        lualine_y = { "diff" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          "diagnostics",
          {
            "filename",
            path = 1,
            color = { fg = "#ffaa88" },
          },
        },
        lualine_x = {
          {
            "diff",
            color = { fg = "#ffaa88" },
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {
        lualine_b = {
          { "filename", file_status = true },
        },
        lualine_c = {
          {
            "navic",
            color_correction = nil,
            navic_opts = nil,
          },
        },
      },
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
