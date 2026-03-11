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
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Stay in visual mode when indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Paste without replacing clipboard (paste over selection)
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Select all
map("n", "<leader>sa", "gg<S-v>G", { desc = "Select all" })

-- ─── Navigation ──────────────────────────────────────────────────────────────

-- Clear search highlight with Escape
map("n", "<esc>", ":noh<CR><esc>", { desc = "Clear search highlights" })

-- Window navigation (also set by LazyVim, but ensuring they're here)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window splits
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize window sizes" })

-- Window resize (<leader>w + arrow-like keys, step of 5)
map("n", "<leader>w+", "<cmd>resize +5<cr>",          { desc = "Increase window height" })
map("n", "<leader>w-", "<cmd>resize -5<cr>",          { desc = "Decrease window height" })
map("n", "<leader>w>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<leader>w<", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })

-- ─── Terminal ─────────────────────────────────────────────────────────────────

-- Exit terminal mode easily
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Navigate windows from terminal too
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- ─── Quickfix ────────────────────────────────────────────────────────────────

map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- ─── File Explorer ───────────────────────────────────────────────────────────

-- Use neo-tree as the only file explorer (left sidebar, VSCode-style)
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer" })
map("n", "<leader>o", "<cmd>Neotree focus<cr>", { desc = "Focus Explorer" })

-- ─── Git ──────────────────────────────────────────────────────────────────────

-- <leader>gg is LazyVim default for lazygit — kept as-is

-- ─── Quit ─────────────────────────────────────────────────────────────────────

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
