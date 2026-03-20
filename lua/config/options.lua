-- Options are automatically loaded before lazy.nvim startup
-- Only genuine overrides from LazyVim defaults are listed here

local opt = vim.opt

opt.scrolloff    = 8     -- keep 8 lines visible above/below cursor (LazyVim default: 4)
opt.wrap         = true  -- wrap long lines (LazyVim default: false)
opt.linebreak    = true  -- wrap at word boundaries, not mid-word
opt.inccommand   = "split" -- show live substitution results in a split (LazyVim default: "nosplit")

-- Performance
opt.updatetime   = 200   -- faster CursorHold / LSP diagnostics (LazyVim default: 4000ms)
opt.timeoutlen   = 300   -- faster which-key popup (LazyVim default: 300, explicit for clarity)

-- Cleaner UI
opt.cmdheight    = 0     -- hide cmdline when not in use (noice.nvim handles messages)
opt.pumheight    = 10    -- cap autocomplete menu at 10 items (default: unlimited)

-- File navigation (lets gf find .ts, .py, .go files by extension)
opt.suffixesadd:append({ ".js", ".ts", ".jsx", ".tsx", ".py", ".go" })

-- Cleaner diagnostics — show only the first error per line, no source prefix
vim.diagnostic.config({
  virtual_text = {
    spacing  = 2,
    source   = false,   -- hide "eslint:" / "ts:" prefix
    prefix   = "●",
    severity = { min = vim.diagnostic.severity.HINT },
    format   = function(d)
      -- truncate long messages at 80 chars
      local msg = d.message
      if #msg > 80 then msg = msg:sub(1, 77) .. "..." end
      return msg
    end,
  },
  -- Only show the most severe diagnostic per line (no duplicate stacking)
  severity_sort = true,
  virtual_lines = false,
})
