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

-- Enable word wrap only for prose — code files stay unwrapped
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit", "gitrebase" },
  callback = function()
    vim.opt_local.wrap     = true
    vim.opt_local.linebreak = true  -- break at word boundaries
  end,
})

-- Scroll-past-EOF: when cursor is near the last line, increase scrolloff so
-- the last line stays centered with empty space below (VSCode scrollBeyondLastLine).
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function()
    local ft = vim.bo.filetype
    if ft == "neo-tree" or ft == "lazy" or ft == "mason" or ft == "help" then return end
    local last   = vim.fn.line("$")
    local cur    = vim.fn.line(".")
    local height = vim.api.nvim_win_get_height(0)
    if last - cur < math.floor(height / 2) then
      vim.opt_local.scrolloff = math.floor(height / 2)
    else
      vim.opt_local.scrolloff = 8
    end
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
