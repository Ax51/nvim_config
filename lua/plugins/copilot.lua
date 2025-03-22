return {
  "zbirenbaum/copilot.lua",

  event = "InsertEnter",
  opts = {
    panel = { enabled = false, },
    suggestion = {
      enabled = true,
      auto_trigger = true,
    },
    copilot_model = "gpt-4o-copilot",
  },
}
