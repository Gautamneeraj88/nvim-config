-- Options are automatically loaded before lazy.nvim startup
-- Only genuine overrides from LazyVim defaults are listed here

local opt = vim.opt

-- Disable netrw (neo-tree is the file explorer)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

opt.scrolloff    = 8     -- keep 8 lines visible above/below cursor (LazyVim default: 4)
opt.inccommand   = "split" -- show live substitution results in a split (LazyVim default: "nosplit")

-- Performance
opt.updatetime   = 200   -- faster CursorHold / LSP diagnostics (LazyVim default: 4000ms)
opt.timeoutlen   = 800   -- which-key popup delay (300 was too fast to read hints)

-- UX
opt.confirm      = true  -- ask "Save / Discard / Cancel?" instead of erroring on :q with unsaved changes

-- Cleaner UI
opt.cmdheight    = 0     -- hide cmdline when not in use (noice.nvim handles messages)
opt.pumheight    = 10    -- cap autocomplete menu at 10 items (default: unlimited)
opt.winborder    = "rounded" -- global rounded borders on ALL floating windows (hover, LSP, etc.)

-- File navigation (lets gf find .ts, .py, .go files by extension)
opt.suffixesadd:append({ ".js", ".ts", ".jsx", ".tsx", ".py", ".go" })

-- Folds — open everything by default, use treesitter/manual when needed
opt.fillchars = { eob = " ", fold = "·", vert = "│", horiz = "─" }
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Statuscolumn — gutter shows fold marker + line number; gitsigns/DAP use the sign column
opt.statuscolumn = "%=%C %l "
