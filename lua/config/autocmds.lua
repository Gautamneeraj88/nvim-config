-- Autocmds are automatically loaded on the VeryLazy event
-- LazyVim sets up good defaults — we only add what's specific to our workflow

-- Close man pages with q (LazyVim handles the other utility windows)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Python: disable pydoc fallback for K — use LSP hover instead
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    -- Override K to always use LSP hover (instead of pydoc)
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
