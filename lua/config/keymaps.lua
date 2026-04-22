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

-- ─── Terminal ─────────────────────────────────────────────────────────────────

-- Exit terminal mode back to normal mode
-- Also map Esc Esc as convenience (may not work if noice intercepts Esc)
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", nowait = true })

-- ─── File Explorer ───────────────────────────────────────────────────────────
-- <leader>e  → toggle explorer (full project root / cwd)
-- <leader>o  → toggle focus mode (roots tree at nearest package root)
--
-- These keymaps live here (VeryLazy) AND are re-applied on the LazyLoad event
-- for neo-tree.nvim, so they survive lazy.nvim's per-plugin key re-registration.

local function _find_pkg_root(file)
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

-- Opens neo-tree via the MAIN filesystem state (not an extra-state) so that
-- filtered_items = { hide_dotfiles = false } is always respected.
local function _neo_open(dir)
  local reveal = vim.fn.expand("%:p")
  vim.cmd("Neotree filesystem reveal")
  vim.schedule(function()
    local ok, manager = pcall(require, "neo-tree.sources.manager")
    if not ok then return end
    local state = manager.get_state("filesystem")
    if not state then return end
    if state.filtered_items then
      state.filtered_items.hide_dotfiles = false
    end
    local ok2, fs = pcall(require, "neo-tree.sources.filesystem")
    if ok2 and type(fs.navigate) == "function" then
      fs.navigate(state, dir, reveal)
    end
  end)
end

local _neo_focus = false

local function _set_explorer_keys()
  map("n", "<leader>e", function()
    _neo_focus = false
    local ok1, renderer = pcall(require, "neo-tree.ui.renderer")
    local ok2, manager  = pcall(require, "neo-tree.sources.manager")
    if ok1 and ok2 and renderer.tree_is_visible(manager.get_state("filesystem")) then
      require("neo-tree.command").execute({ action = "close", source = "filesystem" })
      return
    end
    _neo_open(vim.fn.getcwd())
  end, { desc = "Toggle Explorer", nowait = true, silent = true })

  map("n", "<leader>o", function()
    _neo_focus = not _neo_focus
    _neo_open(_neo_focus and _find_pkg_root(vim.fn.expand("%:p")) or vim.fn.getcwd())
  end, { desc = "Toggle Explorer Focus Mode", nowait = true, silent = true })
end

-- Set on VeryLazy (initial registration)
_set_explorer_keys()

-- Re-apply after neo-tree loads — lazy.nvim re-registers all plugin `keys`
-- at that point, which can override our VeryLazy bindings. vim.schedule ensures
-- our re-registration runs AFTER lazy.nvim's synchronous key setup.
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  once = false,
  callback = function(event)
    if event.data == "neo-tree.nvim" then
      vim.schedule(_set_explorer_keys)
    end
  end,
})

-- ─── LSP ──────────────────────────────────────────────────────────────────────

-- Restart all LSP servers — use when inlay hints / completions stop working
-- after a long session (tsserver/gopls can degrade without crashing)
map("n", "<leader>lR", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- ─── Which-key group labels ───────────────────────────────────────────────────
-- Labels for custom <leader> prefixes so they show up named in the which-key popup.
-- LazyVim already registers labels for its own groups (f, b, c, g, q, u, x…).
vim.schedule(function()
  local ok, wk = pcall(require, "which-key")
  if not ok then return end
  wk.add({
    { "<leader>t",   group = "Test" },
    { "<leader>d",   group = "Debug" },
    { "<leader>dt",  group = "Debug Test" },
    { "<leader>dg",  group = "Debug Go" },
    { "<leader>R",   group = "Refactor" },
    { "<leader>n",   group = "NPM / Package" },
    { "<leader>go",  group = "Octo (GitHub)" }, -- octo.nvim (git-advanced.lua)
    { "<leader>l",   group = "LSP" },
    { "<leader>a",   group = "Argument" },   -- treesitter-textobjects swap
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

-- ─── Git ──────────────────────────────────────────────────────────────────────

-- <leader>gg is LazyVim default for lazygit — kept as-is

