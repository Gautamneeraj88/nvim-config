return {
  -- ─── Smear Cursor — animated cursor trail ─────────────────────────────────────
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      stiffness               = 0.9,   -- catch up fast → shorter overlap with cinnamon scroll
      trailing_stiffness      = 0.6,
      distance_stop_animating = 1.5,   -- skip animation for tiny 1-2 char moves (reduces CPU on CursorMoved)
      -- kanagawa wave: violet accent cursor trail
      cursor_color            = "#957FB8", -- oniViolet
      stiffness_insert_mode   = 0.7,
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
    dependencies = { "kevinhwang91/nvim-hlslens" }, -- search markers in scrollbar
    config = function(_, opts)
      require("scrollbar").setup(opts)
      require("scrollbar.handlers.gitsigns").setup()
      require("scrollbar.handlers.search").setup()  -- show search positions in scrollbar
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
      -- WinScrolled removed — cinnamon fires it on every scroll frame, causing
      -- the scrollbar to redraw hundreds of times during a single smooth scroll
      autocmd = { render = { "BufWinEnter", "TabEnter", "TermEnter", "WinEnter",
                             "CmdwinLeave", "VimResized" } },
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
    event = "VeryLazy",
    opts = {
      -- kanagawa wave palette
      colors = {
        copy   = "#E6C384", -- carpYellow  — yank
        delete = "#E82424", -- samuraiRed  — delete
        insert = "#98BB6C", -- springGreen — insert
        visual = "#957FB8", -- oniViolet   — visual
      },
      line_opacity = 0.15,
    },
  },

  -- ─── Biscuits — closing brace labels ─────────────────────────────────────
  -- Shows virtual text at closing braces telling you what they close.
  -- Only appears when the opening is 8+ lines away (not on tiny blocks).
  -- Prevents the "which } is this?" problem in long TypeScript/Go files.
  {
    "code-biscuits/nvim-biscuits",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      show_on_start    = true,
      prefix_string    = "  ",  -- small arrow before the label
      max_length       = 50,    -- truncate long labels
      min_distance     = 12,    -- only show when block is 12+ lines tall (8 was too noisy)
      language_config  = {
        python     = { prefix_string = "  # " },
        go         = { prefix_string = "  // " },
        typescript = { prefix_string = "  // " },
        javascript = { prefix_string = "  // " },
        lua        = { prefix_string = "  -- " },
        c          = { prefix_string = "  // " },
        cpp        = { prefix_string = "  // " },
      },
    },
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

  -- ─── Hlargs — highlight function arguments ────────────────────────────────────
  -- Function parameters get their own warm-amber color, visually distinct from
  -- regular local variables. Makes it immediately obvious what's a param vs a local.
  {
    "m-demare/hlargs.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      color = "#FFA066", -- kanagawa surimiOrange — warm, distinct from variables
      excluded_argnames = {
        usages = {
          python = { "self", "cls", "_" },
          lua    = { "self", "_" },
        },
      },
    },
  },

  -- ─── Illuminate — highlight all references to word/symbol under cursor ──────────
  -- When your cursor sits on a variable or function, all other occurrences in the
  -- file are subtly underlined. Uses LSP when available, falls back to treesitter.
  -- <leader>ui toggles it if you need a clean view temporarily.
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
      { "<leader>ui", function() require("illuminate").toggle() end, desc = "Toggle Illuminate" },
    },
  },

  -- ─── Smooth animations (mini.animate) ─────────────────────────────────────────
  -- Animates: window resize, window open/close
  -- Scroll animation is handled by cinnamon.nvim — disabled here to avoid double animation
  -- Cursor animation is handled by smear-cursor.nvim — disabled here too
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
        scroll = { enable = false }, -- cinnamon.nvim handles scroll animation
        cursor = { enable = false }, -- smear-cursor.nvim handles cursor animation
      }
    end,
  },
}
