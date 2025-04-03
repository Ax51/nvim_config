return {
  "zbirenbaum/copilot.lua",

  event = "InsertEnter",
  opts = {
    panel = { enabled = false, },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept_line = "<M-L>",
      }
    },
    copilot_model = "gpt-4o-copilot",
  },
}
