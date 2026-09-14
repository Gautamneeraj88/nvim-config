-- Keymaps are automatically loaded on the VeryLazy event
-- LazyVim already sets up many useful keymaps — these are additions/overrides.
-- Press <leader> (Space) and wait to see all available keymaps via which-key.

local map = vim.keymap.set

-- ─── Editing ─────────────────────────────────────────────────────────────────

-- jk to exit insert mode (faster than reaching for Escape)
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Save with Ctrl+S (works in normal, insert, visual)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Move selected lines up/down with Alt+j/k
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })

-- Stay in visual mode when indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Select all
map("n", "<leader>A", "gg<S-v>G", { desc = "Select all" })

-- Close all buffers except current (Snacks handles modified buffers and adjacent switching)
map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      Snacks.bufdelete(buf)
    end
  end
end, { desc = "Close other buffers" })

-- ─── Navigation ──────────────────────────────────────────────────────────────

-- Window resize (<leader>w + arrow-like keys, step of 5)
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize window sizes" })
map("n", "<leader>w+", "<cmd>resize +5<cr>",          { desc = "Increase window height" })
map("n", "<leader>w-", "<cmd>resize -5<cr>",          { desc = "Decrease window height" })
map("n", "<leader>w>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<leader>w<", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })

-- Mouse wheel scrolls the viewport, cursor stays put (VSCode behaviour).
-- "3<C-e>" not "<C-e><C-e><C-e>" — one command, one smooth-scroll animation.
map({ "n", "v" }, "<ScrollWheelDown>", "3<C-e>", { silent = true })
map({ "n", "v" }, "<ScrollWheelUp>",   "3<C-y>", { silent = true })
-- Insert mode runs it as :normal! — a plain "3<C-e>" rhs would be typed into the
-- buffer as the literal characters instead of scrolling.
map("i", "<ScrollWheelDown>", function() vim.cmd("normal! 3\5") end,  { silent = true })
map("i", "<ScrollWheelUp>",   function() vim.cmd("normal! 3\25") end, { silent = true })

-- ─── Word Search ──────────────────────────────────────────────────────────────

-- Next/previous occurrence of the word under the cursor (vim-native * / #).
-- <leader>gl is taken by LazyVim's Git Log, so the bare <g>l prefix is used here.
map("n", "gl", "*", { desc = "Next word occurrence" })
map("n", "gL", "#", { desc = "Previous word occurrence" })

-- ─── Terminal ─────────────────────────────────────────────────────────────────

-- Exit terminal mode back to normal mode
-- Also map Esc Esc as convenience (may not work if noice intercepts Esc)
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", nowait = true })


-- ─── LSP ──────────────────────────────────────────────────────────────────────

-- Restart all LSP servers attached to the current buffer — use when inlay hints /
-- completions stop working after a long session (tsserver/gopls can degrade without
-- crashing). Uses the vim.lsp API directly; nvim-lspconfig's :LspRestart command is
-- not registered in this setup (LazyVim drives servers via vim.lsp.enable).
map("n", "<leader>cL", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No active LSP clients", vim.log.levels.WARN)
    return
  end
  local names = {}
  for _, c in ipairs(clients) do
    names[#names + 1] = c.name
    vim.lsp.stop_client(c.id)
  end
  vim.defer_fn(function()
    vim.cmd("silent! edit") -- re-triggers FileType → servers re-attach
    vim.notify("Restarted LSP: " .. table.concat(names, ", "), vim.log.levels.INFO)
  end, 500)
end, { desc = "Restart LSP" })

-- ─── Which-key group labels ───────────────────────────────────────────────────
-- Labels for custom <leader> prefixes so they show up named in the which-key popup.
-- LazyVim already registers labels for its own groups (f, b, c, g, q, s, u, w, x…).
vim.schedule(function()
  local ok, wk = pcall(require, "which-key")
  if not ok then return end
  wk.add({
    { "<leader>T",  group = "Terminal" },
    { "<leader>R",  group = "Refactor" },
    { "<leader>a",  group = "Argument" },
    { "<leader>gd", group = "Diff" },
  })
end)

-- <leader>p group only registered in Python buffers (iron.nvim keys are also ft-local)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    local ok, wk = pcall(require, "which-key")
    if not ok then return end
    wk.add({ { "<leader>p", group = "Python REPL", buffer = 0 } })
  end,
})

-- <leader>j group only registered in JS/TS buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    local ok, wk = pcall(require, "which-key")
    if not ok then return end
    wk.add({ { "<leader>j", group = "Node REPL", buffer = 0 } })
  end,
})

-- <leader>m group only registered in Markdown buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    local ok, wk = pcall(require, "which-key")
    if not ok then return end
    wk.add({ { "<leader>m", group = "Markdown", buffer = 0 } })
  end,
})

-- ─── Remove dead profiler keys from LazyVim defaults ──────────────────────────
pcall(vim.keymap.del, "n", "<leader>dpp")
pcall(vim.keymap.del, "n", "<leader>dph")


