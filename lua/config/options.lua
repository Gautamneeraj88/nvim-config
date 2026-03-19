-- Options are automatically loaded before lazy.nvim startup
-- Only genuine overrides from LazyVim defaults are listed here

local opt = vim.opt

opt.scrolloff    = 8     -- keep 8 lines visible above/below cursor (LazyVim default: 4)
opt.wrap         = true  -- wrap long lines (LazyVim default: false)
opt.linebreak    = true  -- wrap at word boundaries, not mid-word
opt.inccommand   = "split" -- show live substitution results in a split (LazyVim default: "nosplit")

-- File navigation (lets gf find .ts, .py, .go files by extension)
opt.suffixesadd:append({ ".js", ".ts", ".jsx", ".tsx", ".py", ".go" })
