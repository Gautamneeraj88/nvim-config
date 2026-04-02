-- Options are automatically loaded before lazy.nvim startup
-- Only genuine overrides from LazyVim defaults are listed here

local opt = vim.opt

opt.scrolloff    = 8     -- keep 8 lines visible above/below cursor (LazyVim default: 4)
opt.inccommand   = "split" -- show live substitution results in a split (LazyVim default: "nosplit")

-- Performance
opt.updatetime   = 200   -- faster CursorHold / LSP diagnostics (LazyVim default: 4000ms)
opt.timeoutlen   = 300   -- faster which-key popup (LazyVim default: 300, explicit for clarity)

-- Cleaner UI
opt.cmdheight    = 0     -- hide cmdline when not in use (noice.nvim handles messages)
opt.pumheight    = 10    -- cap autocomplete menu at 10 items (default: unlimited)
vim.o.winborder  = "rounded" -- global rounded borders on ALL floating windows (hover, LSP, etc.)

-- File navigation (lets gf find .ts, .py, .go files by extension)
opt.suffixesadd:append({ ".js", ".ts", ".jsx", ".tsx", ".py", ".go" })
