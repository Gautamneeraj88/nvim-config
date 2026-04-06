-- Autocmds are automatically loaded on the VeryLazy event
-- LazyVim sets up good defaults — we only add what's specific to our workflow

-- Auto-restore last session when Neovim opens with no file arguments.
-- No autocmd needed — autocmds.lua is sourced during VeryLazy, which fires
-- after VimEnter, so we just run directly. vim.schedule lets the UI settle first.
-- argc(-1) counts files across all tab pages (correct for "launched with no args").
if vim.fn.argc(-1) == 0 then
  vim.schedule(function()
    require("persistence").load()
  end)
end

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
-- Cached per-window — only writes the option when the value actually changes,
-- avoiding redundant option assignments on every single cursor movement.
local _scrolloff_cache = {}
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function()
    local ft = vim.bo.filetype
    if ft == "neo-tree" or ft == "lazy" or ft == "mason" or ft == "help" then return end
    local win    = vim.api.nvim_get_current_win()
    local last   = vim.api.nvim_buf_line_count(0)
    local cur    = vim.api.nvim_win_get_cursor(win)[1]
    local height = vim.api.nvim_win_get_height(win)
    local target = (last - cur < math.floor(height / 2)) and math.floor(height / 2) or 8
    if _scrolloff_cache[win] ~= target then
      _scrolloff_cache[win] = target
      vim.opt_local.scrolloff = target
    end
  end,
})
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function(ev) _scrolloff_cache[tonumber(ev.match)] = nil end,
})

-- Help gf (go to file) find TypeScript/JavaScript imports
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.path:prepend(".,src,node_modules")
    vim.opt_local.includeexpr = "substitute(v:fname, '^\\~/', '', '')"
  end,
})
