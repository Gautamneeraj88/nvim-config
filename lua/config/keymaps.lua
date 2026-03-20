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

-- ─── Navigation ──────────────────────────────────────────────────────────────

-- Window resize (<leader>w + arrow-like keys, step of 5)
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize window sizes" })
map("n", "<leader>w+", "<cmd>resize +5<cr>",          { desc = "Increase window height" })
map("n", "<leader>w-", "<cmd>resize -5<cr>",          { desc = "Decrease window height" })
map("n", "<leader>w>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<leader>w<", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })

-- ─── Terminal ─────────────────────────────────────────────────────────────────

-- Exit terminal mode back to normal mode
-- Also map Esc Esc as convenience (may not work if noice intercepts Esc)
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", nowait = true })

-- Navigate windows from terminal too
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- ─── File Explorer ───────────────────────────────────────────────────────────

-- Use neo-tree as the only file explorer (left sidebar, VSCode-style)
-- <leader>e  → toggle tree open/closed
-- <leader>o  → reveal current file in tree and focus it; press again to jump back
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer" })
map("n", "<leader>o", function()
  local manager = require("neo-tree.sources.manager")
  local renderer = require("neo-tree.ui.renderer")
  local state = manager.get_state("filesystem")
  local is_visible = renderer.tree_is_visible(state)
  if is_visible and vim.bo.filetype == "neo-tree" then
    vim.cmd("wincmd p") -- already in tree → jump back to editor
  else
    vim.cmd("Neotree reveal") -- open tree and highlight current file
  end
end, { desc = "Focus Explorer (reveal file)" })

-- ─── Git ──────────────────────────────────────────────────────────────────────

-- <leader>gg is LazyVim default for lazygit — kept as-is

