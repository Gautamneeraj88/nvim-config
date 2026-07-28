-- Options are automatically loaded before lazy.nvim startup
-- Only genuine overrides from LazyVim defaults are listed here

local opt = vim.opt

-- Disable netrw (neo-tree is the file explorer)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

opt.scrolloff    = 8       -- keep 8 lines visible above/below cursor
opt.inccommand   = "split" -- show live substitution results in a split

-- Performance
opt.updatetime   = 200     -- faster CursorHold / LSP diagnostics
opt.timeoutlen   = 1000    -- which-key popup stays open long enough to read

-- UX
opt.confirm      = true    -- ask "Save / Discard / Cancel?" on :q with unsaved changes

-- Cleaner UI
opt.cmdheight    = 0       -- hide cmdline when not in use (noice.nvim handles messages)
opt.pumheight    = 10      -- cap autocomplete menu at 10 items
opt.winborder    = "rounded" -- global rounded borders on all floating windows

-- File navigation (lets gf find .ts, .py, .go files by extension)
opt.suffixesadd:append({ ".js", ".ts", ".jsx", ".tsx", ".py", ".go" })

-- Folds — nvim-ufo handles the actual folding; these set the initial state
opt.fillchars    = { eob = " ", fold = "·", vert = "│", horiz = "─" }
opt.foldcolumn   = "0"     -- no gutter fold column (ufo shows fold counts via virtual text)
opt.foldlevel    = 99      -- open all folds by default
opt.foldlevelstart = 99
opt.foldenable   = true

-- Statuscolumn — line numbers; gitsigns/DAP/folds use the sign column
opt.statuscolumn = "%=%l "
