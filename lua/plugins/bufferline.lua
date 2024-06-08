return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "BufHidden",

  config = function()
    require("bufferline").setup({
      options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        mode = "buffers",
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            separator = true,
            padding = 1,
          },
        },
        color_icons = true,
        show_duplicate_prefix = true,
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = require("utils.buffline_lsp_ind"),
        indicator = {
          icon = "  ",
          style = "icon",
        },
      },
    })
  end,
}
