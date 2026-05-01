local persistent_shell = nil

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
  },

  config = function()
    require("toggleterm").setup({
      direction = "horizontal",
    })
  end,
}
