local remapUtils = require("utils.keymappings")

local nmap = remapUtils.nmap;
local remap = remapUtils.remap;

-- NeoTree
nmap("<leader>e", ":Neotree toggle position=float reveal<CR>")
nmap("<leader>E", ":Neotree right reveal<CR>")
nmap("<leader>b", ":Neotree toggle left buffers<CR>")

-- LSP
nmap("<leader>ld", vim.diagnostic.open_float)
nmap("[d", vim.diagnostic.goto_prev)
nmap("]d", vim.diagnostic.goto_next)
nmap("<leader>lD", vim.diagnostic.setloclist)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, silent = true }
    nmap("gD", vim.lsp.buf.declaration, opts)
    nmap("K", function()
      local filename = vim.fn.expand("%:t")
      print(filename)
      if filename == "Cargo.toml" then
        require("crates").show_popup()
      else
        vim.lsp.buf.hover()
      end
    end, opts)
    nmap("gi", vim.lsp.buf.implementation, opts)
    nmap("<leader>lr", vim.lsp.buf.rename, opts)
    nmap("<leader>D", vim.lsp.buf.type_definition, opts)
    remap("<leader>la", vim.lsp.buf.code_action, { "n", "v" }, opts)
    nmap("<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

-- Fzf-lua
nmap("<leader>fr", ":FzfLua resume<CR>")
nmap("<leader>fl", ":FzfLua<CR>")
nmap("<leader>fd", ":FzfLua diagnostics_document<CR>")
nmap("<leader>ff", ":FzfLua files<CR>")
nmap("<leader>fw", ":FzfLua live_grep<CR>")
nmap("<leader>fW", ":FzfLua grep_cword<CR>")
nmap('gd', require("utils.open_fzf_or_go-to_def"))
nmap("gr", ":FzfLua lsp_references<CR>")
nmap("<leader>fm", ":FzfLua marks<CR>")
nmap("<leader>fp", require("utils.fzf_lua_persisted"))
nmap("<leader>fc", ":lua require(\"todo-comments.fzf\").todo()<CR>")

-- Git
nmap("<leader>Gb", ":FzfLua git_branches<CR>")
nmap("<leader>Gc", ":FzfLua git_commits<CR>")
nmap("<leader>Gs", ":FzfLua git_status<CR>")
nmap("<leader>Gd", ":Gitsigns toggle_deleted<CR>")
nmap("<leader>Gl", ":Gitsigns toggle_current_line_blame<CR>")
nmap("<leader>GL", ":Gitsigns blame_line<CR>")
nmap("<leader>Gp", ":Gitsigns preview_hunk<CR>")
nmap("<leader>Gx", ":Gitsigns reset_hunk<CR>")
nmap("[h", ":Gitsigns prev_hunk<CR>")
nmap("]h", ":Gitsigns next_hunk<CR>")

-- Comment: delete commented linewise section
nmap("dac", require("utils.delete_block_of_linewise_comments"))

-- LazyGit
nmap("<leader>g", ":LazyGit<CR>")

-- Navigation
nmap("<c-k>", ":wincmd k<CR>")
nmap("<c-j>", ":wincmd j<CR>")
nmap("<c-h>", ":wincmd h<CR>")
nmap("<c-l>", ":wincmd l<CR>")
nmap("<C-I>", "<C-I>") -- NOTE: we need to separate <C-I> from <tab> by explicitly remap each key

-- Splits
nmap("|", ":vsplit<CR>")
nmap("\\", ":split<CR>")

-- Other
nmap("gut", require("utils.convert_camel_to_upper"))
nmap("<leader>w", ":w<CR>")
nmap("<leader>q", ":bp|bd #<CR>")
nmap("<leader>Q", ":bd<CR>")
nmap("<leader>QQ", ":bufdo bd<CR>")
nmap("<leader>QA", function()
  local closeOther = require("utils.close_all_bufs_ex_curr")
  local bufflineUi = require("bufferline.ui")

  closeOther()
  bufflineUi.refresh()
end)
nmap("<leader>X", ":BufferLinePickClose<CR>")
nmap("<leader>s", ":BufferLineSortByTabs<CR>")
nmap("<leader>h", ":nohlsearch<CR>")
nmap("<leader>rj", ":!bun %<CR>")
nmap("<leader>rs", "vip:w !sh<CR>")      -- NOTE: run entire paragraph as shell script
remap("jj", "<Esc>", "i")
remap("<leader>c", ":'<,'>t'><CR>", "v") -- NOTE: copy selected lines and paste them below
remap("<leader>C", require("utils.copy_and_comment"), "v")

-- Tabs
nmap("<Tab>", ":BufferLineCycleNext<CR>")
nmap("<s-Tab>", ":BufferLineCyclePrev<CR>")

-- Navbuddy
nmap("<leader>fv", ":Navbuddy<CR>")

-- Tests
nmap("<leader>tt", ":Neotest run<CR>")
nmap("<leader>tS", ":Neotest stop<CR>")
nmap("<leader>ts", ":Neotest summary<CR>")
nmap("<leader>ta", ":Neotest run file<CR>")
nmap("<leader>tl", ":Neotest run last<CR>")
nmap("<leader>to", ":Neotest output<CR>")
nmap("<leader>t[", ":Neotest jump prev<CR>")
nmap("<leader>t]", ":Neotest jump next<CR>")

-- Hop
nmap("<leader>M", ":HopChar1<CR>")
nmap("<leader>m", ":HopWord<CR>")
remap("<c-m>", "<c-\\><c-o>:HopWord<CR>", { "i" })
remap("<c-m>", function()
  require("hop").hint_words()
end, { "v" })

-- Zen Mode
nmap("<leader>zz", function()
  vim.cmd("ZenMode")
end)

-- Twilight
nmap("<leader>zt", ":Twilight<CR>")

-- Terminal
-- NOTE: exit from terminal mode with <ESC>
remap("qq", function()
  -- Do not close lazygit on escape
  if not string.find(vim.api.nvim_buf_get_name(0), "lazygit") then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "n", true)
  end
end, "t")
