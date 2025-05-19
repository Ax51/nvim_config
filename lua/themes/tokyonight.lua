return {
  "folke/tokyonight.nvim",

  lazy = false,
  priority = 1000,

  opts = {
    on_colors = function(colors)
      colors.comment = "#7983b1"
    end,
    on_highlights = function(hl, c)
      hl.CopilotSuggestion = {
        fg = "#7cabc2",
      }
      -- NOTE: change unused variable color
      hl.DiagnosticUnnecessary = {
        fg = c.comment,
      }
      hl.EndOfBuffer = {
        fg = c.comment,
      }
      hl.LineNr = {
        fg = c.comment,
      }
      hl.VisimatchOthers = { bg = "#293350" }
      hl["@markup.italic"] = {
        fg = "#e0af68",
      }
      hl["@markup.strong"] = {
        fg = "#e37933"
      }
    end,
  },

  init = function()
    -- NOTE: init that theme
    vim.cmd.colorscheme("tokyonight-storm")
  end
}
