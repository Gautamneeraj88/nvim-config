-- Autocmds are automatically loaded on the VeryLazy event
-- LazyVim sets up good defaults — we only add what's specific to our workflow

-- Close utility windows with just 'q'
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "lspinfo", "man", "notify", "qf", "query", "startuptime", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Flash the yanked region so you can see what was copied
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- When you reopen a file, go back to where you were
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Show JSON without hiding quotes (conceallevel 0 = no hiding)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Equalize splits when Neovim window is resized
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Python: disable pydoc fallback for K — use LSP hover instead
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    -- Prevent K from calling pydoc when LSP hover is available
    vim.bo.keywordprg = ":help"
    -- Override K to always use LSP hover
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true, desc = "LSP Hover" })
  end,
})

-- Help gf (go to file) find TypeScript/JavaScript imports
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.path:prepend(".,src,node_modules")
    vim.opt_local.includeexpr = "substitute(v:fname, '^\\~/', '', '')"
  end,
})
