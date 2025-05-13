return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-lua/plenary.nvim",
  },
  cmd = {
    "Copilot",
    "CopilotChat",
    "CopilotChatCommit",
    "CopilotChatAgents",
    "CopilotChatModels",
    "CopilotChatTests",
    "CopilotChatSave",
  },

  config = function()
    local chat = require("CopilotChat");
    local prompts = require("CopilotChat.config.prompts");

    chat.setup({
      model = "gpt-4.1",
      mappings = {
        reset = {
          normal = '<C-k>',
          insert = '<C-k>',
        },
      },
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,
      prompts = {
        Commit = {
          prompt =
          "Please provide me a list of at most 10 suggestions for commit message according to the currently staged changes.",
          system_prompt = prompts.COPILOT_BASE.system_prompt .. [[
The commit message must be prefixed with `!` since this is a trigger for my commit hook.
Commit must starts with one of the following key words:
-feat
-fix
-chore
-docs
-style
-refactor
-perf
-test
after key word please paste `:` that will indicate the start of the commit message.]],
          context = "git:staged",
          description = "List of 10 commit messages for staged changes",
        }
      },
      highlight_headers = false,
      separator = '---',
      error_header = '> [!ERROR] Error',
    })
  end
  ,
}
