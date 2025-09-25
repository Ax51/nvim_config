local M = {}

local str_utils = require("utils.string_utils")

function M.execute_code_block()
  local known_interpreters_lang_list = {
    sh = "sh",
    zsh = "sh",
    bash = "sh",
    js = "bun run -",
    ts = "bun run -",
    lua = "luajit -",
    luajit = "luajit -",
  }

  ---@type string[]
  local paragraph_lines = str_utils.get_paragraph_under_cursor()
  local code_block_pattern = "```"
  local is_code_block = string.match(paragraph_lines[1], code_block_pattern)
      and string.match(paragraph_lines[#paragraph_lines], code_block_pattern)
      and true
    or false
  local code_block_lang_specifier_pattern = "```(%w+)"
  local visual_selection_lang = string.match(paragraph_lines[1], code_block_lang_specifier_pattern)
  ---@type string|nil
  local selected_lang = known_interpreters_lang_list[visual_selection_lang]
  ---@type string|nil
  local code_runner = nil

  if is_code_block then
    -- NOTE: remove first and last line from the table (```)
    table.remove(paragraph_lines, 1)
    table.remove(paragraph_lines, #paragraph_lines)
  end

  if selected_lang ~= nil then
    code_runner = selected_lang
  elseif is_code_block then
    local user_input = vim.fn.input("Unknown code block. Please enter similar lang tag (sh for bash): ")

    if known_interpreters_lang_list[user_input] ~= nil then
      -- NOTE: specified similar known lang tag
      code_runner = known_interpreters_lang_list[user_input]
    else
      -- NOTE: shortcut because of unknown language specified
      vim.notify("Provided lang tag is unknown.", 2)

      return
    end
  else
    -- TODO: add file recognition with `vim.fn.expand("%:e")`
    code_runner = "sh"
  end

  -- NOTE: execute command as it were SH
  local exec_res = vim.fn.system(code_runner, table.concat(paragraph_lines, "\n"))

  vim.notify(exec_res)
end

return M
