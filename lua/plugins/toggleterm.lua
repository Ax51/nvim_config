local persistent_shell = nil
local persistent_lazygit = nil

local function get_persistent_shell()
  if persistent_shell == nil then
    local Terminal = require("toggleterm.terminal").Terminal

    persistent_shell = Terminal:new({
      count = 9,
      cmd = "env -u ZELLIJ -u ZELLIJ_SESSION_NAME -u ZELLIJ_PANE_ID zellij attach --create nvim-term",
      direction = "horizontal",
      close_on_exit = false,
    })
  end
  return persistent_shell
end

local function toggle_lazygit()
  if persistent_lazygit == nil then
    local Terminal = require("toggleterm.terminal").Terminal

    persistent_lazygit = Terminal:new({
      count = 10,
      cmd = "lazygit",
      display_name = "lazygit",
      direction = "float",
      float_opts = {
        width = function()
          return math.floor(vim.o.columns * 0.95)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.90)
        end,
      },
    })
  end
  persistent_lazygit:toggle()
end

return {
  "akinsho/toggleterm.nvim",
  version = "*",

  keys = {
    {
      "<leader>t",
      -- NOTE: keep plugin lazy loaded, yet using only one terminal instance, which is persistent across toggles
      function()
        get_persistent_shell():toggle()
      end,
      desc = "Toggle persistent terminal",
    },
    {
      "<leader>g",
      function()
        toggle_lazygit()
      end,
      desc = "Toggle lazygit terminal",
    },
  },

  config = function()
    require("toggleterm").setup({
      direction = "horizontal",
    })
  end,
}
