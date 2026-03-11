return {
  -- ─── Smear Cursor — animated cursor trail ─────────────────────────────────────
  -- The cursor leaves a smooth smear/trail as it moves around the screen.
  -- One of the most satisfying visual effects you can add to Neovim.
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      smear_between_buffers    = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space      = true,
      legacy_computing_symbols_support = false,
      stiffness                = 0.8,   -- cursor spring stiffness (0-1, higher = snappier)
      trailing_stiffness       = 0.5,   -- tail follows more slowly
      distance_stop_animating  = 0.5,
      hide_target_hack         = true,
    },
  },

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

  -- ─── Scrollbar — visual scroll indicator with markers ─────────────────────────
  -- Shows a scrollbar on the right edge of the window.
  -- Markers show where errors, warnings, and git changes are in the file.
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    opts = {
      show           = true,
      show_in_active_only = false,
      set_highlights = true,
      folds          = 1000,
      max_lines      = false,
      hide_if_all_visible = true, -- hide scrollbar if entire file is visible
      throttle_ms    = 100,
      handle = {
        text       = " ",
        blend      = 30,
        highlight  = "CursorColumn",
        hide_if_all_visible = true,
      },
      marks = {
        GitAdd    = { text = "│", highlight = "GitSignsAdd" },
        GitChange = { text = "│", highlight = "GitSignsChange" },
        GitDelete = { text = "▁", highlight = "GitSignsDelete" },
        Error     = { text = { "─", "━" }, highlight = "DiagnosticVirtualTextError" },
        Warn      = { text = { "─", "━" }, highlight = "DiagnosticVirtualTextWarn" },
        Info      = { text = { "─", "━" }, highlight = "DiagnosticVirtualTextInfo" },
        Hint      = { text = { "─", "━" }, highlight = "DiagnosticVirtualTextHint" },
        Search    = { text = { "─", "━" }, highlight = "Type" },
        Cursor    = { text = "—", highlight = "Normal" },
      },
      excluded_buftypes = { "terminal" },
      excluded_filetypes = { "neo-tree", "lazy", "mason", "aerial", "trouble" },
      autocmd = { render = { "BufWinEnter", "TabEnter", "TermEnter", "WinEnter",
                             "CmdwinLeave", "TextChanged", "VimResized", "WinScrolled" } },
    },
  },

  -- ─── Smooth animations (mini.animate) ─────────────────────────────────────────
  -- Animates: cursor movement, window resize, window open/close
  -- NOTE: scroll animation is disabled since neoscroll handles that already
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function()
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end
      local animate = require("mini.animate")
      return {
        resize = {
          timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
        },
        open = {
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
        },
        close = {
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
        },
        -- Disable scroll animation — neoscroll handles this
        scroll = { enable = false },
        -- Cursor trail animation
        cursor = {
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
        },
      }
    end,
  },
}
