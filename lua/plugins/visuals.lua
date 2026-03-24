return {
  -- ─── Smear Cursor — animated cursor trail ─────────────────────────────────────
  -- The cursor leaves a smooth smear/trail as it moves around the screen.
  -- One of the most satisfying visual effects you can add to Neovim.
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      stiffness               = 0.8,  -- cursor spring stiffness (0-1, higher = snappier)
      trailing_stiffness      = 0.5,  -- tail follows more slowly
      distance_stop_animating = 0.5,
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
    config = function(_, opts)
      require("scrollbar").setup(opts)
      require("scrollbar.handlers.gitsigns").setup()
    end,
    opts = {
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
                             "CmdwinLeave", "VimResized", "WinScrolled" } },
    },
  },

  -- ─── Incline — floating filename labels per split ─────────────────────────────
  -- When you have multiple windows open side by side, each window shows a small
  -- floating label in its top-right corner with the file icon and name.
  -- Only appears when there is more than one window — invisible in single-pane mode.
  -- Excluded from all panel types so neo-tree file prompts are never affected.
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    opts = {
      window = {
        padding      = 1,
        margin       = { vertical = 0, horizontal = 1 },
        placement    = { vertical = "top", horizontal = "right" },
        zindex       = 49, -- below floating inputs (which start at 50+)
      },
      hide = {
        only_win  = true,  -- invisible when only one window is open
        cursorline = false,
        focused_win = false,
      },
      ignore = {
        buftypes  = { "terminal", "nofile", "prompt", "quickfix" },
        filetypes = {
          "neo-tree", "aerial", "undotree", "lazy", "mason",
          "trouble", "qf", "help", "man",
          "dap-repl", "dapui_scopes", "dapui_breakpoints",
          "dapui_stacks", "dapui_watches", "dapui_console",
          "DiffviewFiles", "DiffviewFileHistory",
        },
        wintypes  = { "popup" },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then filename = "[No Name]" end
        local ok, devicons = pcall(require, "nvim-web-devicons")
        local icon, icon_color = "", nil
        if ok then
          icon, icon_color = devicons.get_icon_color(filename)
        end
        local modified = vim.bo[props.buf].modified
        local result = {}
        if icon then
          result[#result + 1] = { icon .. " ", guifg = icon_color }
        end
        result[#result + 1] = { filename, gui = "bold" }
        if modified then
          result[#result + 1] = { " ●", guifg = "#f7768e" }
        end
        return result
      end,
    },
  },

  -- ─── Modes — mode-aware cursorline color ──────────────────────────────────────
  -- The cursorline tints to a different color based on current Vim mode:
  --   normal → subtle blue   insert → green   visual → purple   delete → red
  -- Very subtle (15% opacity) — just enough to know which mode you are in at a glance.
  {
    "mvllow/modes.nvim",
    event = "BufReadPre",
    opts = {
      colors = {
        copy   = "#f5c359", -- yank → amber
        delete = "#c75c6a", -- delete → red
        insert = "#78ccc5", -- insert → teal-green
        visual = "#9745be", -- visual → purple
      },
      line_opacity = 0.15, -- very subtle tint, not distracting
    },
  },

  -- ─── Smooth animations (mini.animate) ─────────────────────────────────────────
  -- Animates: cursor movement, window resize, window open/close
  -- NOTE: scroll animation is disabled since neoscroll handles that already
  {
    "nvim-mini/mini.animate",
    event = "VeryLazy",
    opts = function()
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
        -- Cursor animation disabled — smear-cursor.nvim handles this
        cursor = { enable = false },
      }
    end,
  },
}
