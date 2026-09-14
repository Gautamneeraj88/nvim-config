return {
  -- ─── Rainbow Delimiters — colored nested brackets ─────────────────────────────
  -- Each level of brackets/parens gets a different color so you can see nesting
  -- () blue  [] yellow  {} orange  <> green  and so on
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""]  = rainbow.strategy["global"],
          vim   = rainbow.strategy["local"],
        },
        query = {
          [""]  = "rainbow-delimiters",
          lua   = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -- ─── Virt-column — soft line-length guide ────────────────────────────────
  -- Renders a faint │ character at column 80 and 120 as virtual text.
  -- Much subtler than Neovim's harsh colorcolumn highlight.
  {
    "lukas-reineke/virt-column.nvim",
    event = "BufReadPost",
    opts = {
      char       = "│",
      virtcolumn = "80,120",  -- guides at 80 (classic) and 120 (modern hard limit)
      highlight  = "NonText", -- same dim color as other virtual text
    },
  },

  -- ─── Illuminate — highlight all references to word/symbol under cursor ──────────
  -- When your cursor sits on a variable or function, all other occurrences in the
  -- file are subtly underlined. Uses LSP when available, falls back to treesitter.
  -- <leader>uR toggles it if you need a clean view temporarily.
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = {
      delay    = 200,
      providers = { "lsp", "treesitter", "regex" },
      large_file_cutoff   = 2000,
      large_file_overrides = { providers = { "lsp" } }, -- regex is too slow on big files
      filetypes_denylist = {
        "neo-tree", "aerial", "lazy", "mason", "trouble", "qf",
        "dap-repl", "dapui_scopes", "dapui_breakpoints",
        "dapui_stacks", "dapui_watches", "dapui_console",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
    keys = {
      { "<leader>uR", function() require("illuminate").toggle() end, desc = "Toggle Illuminate" },
    },
  },
}
