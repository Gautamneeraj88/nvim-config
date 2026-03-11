-- Options are automatically loaded before lazy.nvim startup
-- LazyVim sets sensible defaults — we only override what we want different

local opt = vim.opt

-- Line numbers
opt.relativenumber = true -- show relative line numbers (great for jump commands like 5j, 10k)

-- Scrolling
opt.scrolloff = 8     -- keep 8 lines visible above/below cursor
opt.sidescrolloff = 8

-- UI
opt.signcolumn = "yes"  -- always show the sign column (git, errors) so text doesn't jump
opt.cursorline = true   -- highlight current line
opt.timeoutlen = 300    -- how long to wait for a key sequence (affects which-key popup)

-- Line wrapping
opt.wrap = true
opt.linebreak = true    -- wrap at word boundaries, not mid-word
opt.breakindent = true  -- wrapped lines keep indentation

-- Search
opt.ignorecase = true   -- case-insensitive search
opt.smartcase = true    -- ...unless you type a capital letter
opt.inccommand = "split" -- preview find & replace live

-- Splits open in a natural direction
opt.splitbelow = true
opt.splitright = true

-- Undo
opt.undofile = true     -- undo survives closing a file
opt.undolevels = 10000
opt.swapfile = false

-- Performance
opt.updatetime = 200

-- File navigation (lets gf find .ts, .py, .go files)
opt.path:append("**")
opt.suffixesadd:append({ ".js", ".ts", ".jsx", ".tsx", ".py", ".go" })
