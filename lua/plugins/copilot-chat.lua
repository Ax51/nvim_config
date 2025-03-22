return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-lua/plenary.nvim",
  },
  cmd = { "CopilotChat", "Copilot" },
  build = "make tiktoken",
  opts = true,
}
