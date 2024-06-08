return {
  "nat-418/boole.nvim",
  cmd = "Boole",
  keys = { "<c-a>", "<c-x>" },

  config = function()
    require("boole").setup({
      mappings = {
        increment = "<C-a>",
        decrement = "<C-x>",
      },

      -- User defined loops
      additions = {
        { "private",     "protected", "public" },
        { "let",         "const" },
        { "type",        "interface" },
        { "toBeVisible", "toBeHidden" },
      },
      allow_caps_additions = {
        { "enable", "disable" },
        -- enable → disable
        -- Enable → Disable
        -- ENABLE → DISABLE
      },
    })
  end,
}
