local function convertCamelToUpperCase()
  -- Get the current word under the cursor
  local word = vim.fn.expand("<cword>")

  local isUpperCase = word:match("_") and true or false

  if isUpperCase then
    -- Transform UPPER_CASE to camelCase
    local camel_case = word:lower():gsub("_(%l)", function(c)
      return c:upper()
    end)

    -- Replace the word under the cursor with the new format
    vim.api.nvim_command("normal ciw" .. camel_case)
  else
    -- Transform camelCase to UPPER_CASE
    local upper_case = word:gsub("(%l)(%u)", "%1_%2"):upper()

    -- Replace the word under the cursor with the new format
    vim.api.nvim_command("normal ciw" .. upper_case)
  end
end

return convertCamelToUpperCase
