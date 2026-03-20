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
-- <leader>e  → toggle tree open/closed (always full project root / cwd)
-- <leader>o  → toggle focus mode: roots tree at nearest package root
--              (walks up from current file to find package.json / tsconfig.json)

-- Walk up from `file` to find the nearest project root marker.
-- Stops at package.json, tsconfig.json, go.mod, etc. before falling back to cwd.
local function find_pkg_root(file)
  local markers = { "package.json", "tsconfig.json", "Cargo.toml", "go.mod", "pyproject.toml", ".git" }
  local dir = vim.fn.fnamemodify(file, ":p:h")
  while true do
    for _, m in ipairs(markers) do
      if vim.fn.filereadable(dir .. "/" .. m) == 1 or vim.fn.isdirectory(dir .. "/" .. m) == 1 then
        return dir
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then break end
    dir = parent
  end
  return vim.fn.getcwd()
end

-- Open/navigate Neo-tree to `dir` using the MAIN filesystem state so that
-- filtered_items (hide_dotfiles=false) from the plugin config is always active.
-- Using Neotree dir=... creates a separate extra-state that ignores those opts.
local function neo_open(dir)
  local reveal = vim.fn.expand("%:p")
  -- Reveal opens/focuses the main filesystem state without changing its config
  vim.cmd("Neotree filesystem reveal")
  vim.schedule(function()
    local ok, manager = pcall(require, "neo-tree.sources.manager")
    if not ok then return end
    local state = manager.get_state("filesystem")
    if not state then return end
    -- Force dotfiles visible (H key mutates this at runtime)
    if state.filtered_items then
      state.filtered_items.hide_dotfiles = false
    end
    -- Navigate the existing state to the target root
    local ok2, fs = pcall(require, "neo-tree.sources.filesystem")
    if ok2 and type(fs.navigate) == "function" then
      fs.navigate(state, dir, reveal)
    end
  end)
end

local _neo_focus = false
map("n", "<leader>e", function()
  _neo_focus = false
  local ok, renderer = pcall(require, "neo-tree.ui.renderer")
  local ok2, manager = pcall(require, "neo-tree.sources.manager")
  if ok and ok2 and renderer.tree_is_visible(manager.get_state("filesystem")) then
    require("neo-tree.command").execute({ action = "close", source = "filesystem" })
    return
  end
  neo_open(vim.fn.getcwd())
end, { desc = "Toggle Explorer" })
map("n", "<leader>o", function()
  _neo_focus = not _neo_focus
  neo_open(_neo_focus and find_pkg_root(vim.fn.expand("%:p")) or vim.fn.getcwd())
end, { desc = "Toggle Explorer Focus Mode" })

-- ─── Git ──────────────────────────────────────────────────────────────────────

-- <leader>gg is LazyVim default for lazygit — kept as-is

