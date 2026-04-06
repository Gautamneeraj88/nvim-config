return {

  -- ─── Yank History — cycle through past yanks after pasting ───────────────────
  -- Press p to paste, then <M-p>/<M-n> to cycle through yank ring
  -- (<C-n>/<C-p> moved to Alt to avoid conflict with vim-visual-multi)
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    opts = {
      ring = { storage = "memory" },
      highlight = { on_put = false, on_yank = false }, -- Snacks handles yank highlight
    },
    keys = {
      { "p",          "<Plug>(YankyPutAfter)",      mode = { "n", "x" }, desc = "Put after" },
      { "P",          "<Plug>(YankyPutBefore)",     mode = { "n", "x" }, desc = "Put before" },
      { "<M-p>",      "<Plug>(YankyCycleForward)",  desc = "Cycle yank forward" },
      { "<M-n>",      "<Plug>(YankyCycleBackward)", desc = "Cycle yank backward" },
      { "<leader>fy", "<cmd>YankyRingHistory<cr>",  desc = "Yank History" },
    },
  },

  -- ─── Multi-cursor (VS Code Ctrl+D style) ─────────────────────────────────────
  -- <C-n>     select word under cursor, then keep pressing to select next match
  -- <C-Down>  add a cursor on the line below
  -- <C-Up>    add a cursor on the line above
  -- After selecting cursors: type normally — all cursors edit simultaneously
  -- \\        VM leader — prefix for extra commands (\\A = select all matches)
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_leader = "\\"
      vim.g.VM_maps = {
        -- Keep <C-n> as the primary select-next key (VS Code Ctrl+D equivalent)
        ["Find Under"]         = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        -- Add cursors vertically with Ctrl+arrow (free in our config)
        ["Select Cursor Down"] = "<C-Down>",
        ["Select Cursor Up"]   = "<C-Up>",
        -- Skip current match and jump to next
        ["Skip Region"]        = "<C-x>",
        -- Remove last added cursor
        ["Remove Region"]      = "<C-q>",
      }
      -- Don't remap <C-h/j/k/l> — those belong to smart-splits navigation
      vim.g.VM_add_cursor_at_pos_no_mappings = 1
    end,
  },

  -- ─── Better Quickfix — fzf preview inside quickfix list ──────────────────────
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      preview = {
        win_height = 12,
        border = "rounded",
        show_title = true,
      },
    },
  },

  -- ─── Project-wide Find & Replace (Spectre) ───────────────────────────────────
  {
    "nvim-pack/nvim-spectre",
    cmd  = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      { "<leader>sr", function() require("spectre").open() end,                               desc = "Search & Replace (Spectre)" },
      { "<leader>sW", function() require("spectre").open_visual({ select_word = true }) end,  desc = "Search word under cursor" },
      { "<leader>sf", function() require("spectre").open_file_search() end,                   desc = "Search in current file" },
    },
  },

  -- ─── Session Management (Persistence) ────────────────────────────────────────
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts  = {
      -- Remove "terminal" from sessionoptions — dead terminal processes can't be
      -- restored and cause errors when a saved session is loaded in a new Neovim instance
      options = vim.tbl_filter(
        function(o) return o ~= "terminal" end,
        vim.opt.sessionoptions:get()
      ),
    },
    keys  = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't save session" },
    },
  },

  -- ─── Marks — visual marks in the gutter ──────────────────────────────────────
  -- Shows colored indicators in the sign column for every mark you set with m{a-z}.
  -- Makes marks visible and navigable instead of invisible and forgotten.
  --
  -- Setting/deleting marks:
  --   m{a-z}       set mark (standard vim)
  --   m,           place the next available mark automatically
  --   dm{a-z}      delete a specific mark
  --   dm-          delete all marks on current line
  --   dm<space>    delete all marks in buffer
  --
  -- Navigating marks:
  --   m]  /  m[    next / previous mark in current buffer
  --   m:           preview all marks in a popup list
  {
    "chentoast/marks.nvim",
    event = "BufReadPost",
    opts = {
      default_mappings = true,
      builtin_marks    = { ".", "<", ">", "^" }, -- also show built-in vim marks
      cyclic           = true,                   -- wrap around when navigating
      refresh_interval = 500, -- 250ms was unnecessarily frequent; 500ms is imperceptible
      sign_priority    = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = {
        "neo-tree", "aerial", "lazy", "mason", "trouble", "qf",
        "dap-repl", "dapui_scopes", "dapui_breakpoints",
        "dapui_stacks", "dapui_watches", "dapui_console",
        "toggleterm",
      },
    },
  },

  -- ─── Twilight — dim inactive code ────────────────────────────────────────
  -- Dims everything outside your current function/block to ~25% opacity.
  -- Keeps your focus on the active code without going full zen mode.
  -- Already installed as a zen-mode dependency — just adding a standalone toggle.
  {
    "folke/twilight.nvim",
    cmd  = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = {
      { "<leader>tw", "<cmd>Twilight<cr>", desc = "Toggle Twilight (dim inactive code)" },
    },
    opts = {
      dimming = {
        alpha    = 0.25,  -- 25% opacity for dimmed code (0 = black, 1 = no dim)
        inactive = false, -- dim inactive windows; false = dim inactive blocks within same window
      },
      context  = 15,     -- lines of context kept bright around cursor
      treesitter = true, -- use treesitter to detect function/block boundaries
      expand = {         -- node types that count as a "context" to keep lit
        "function",
        "method",
        "table",
        "if_statement",
        "arrow_function",
      },
    },
  },

  -- ─── Zen Mode ─────────────────────────────────────────────────────────────────
  {
    "folke/zen-mode.nvim",
    cmd  = "ZenMode",
    opts = {
      window = {
        backdrop = 0.95,
        width    = 120,
        height   = 1,
        options  = {
          signcolumn    = "no",
          number        = false,
          relativenumber = false,
          cursorline    = false,
          foldcolumn    = "0",
        },
      },
      plugins = {
        options  = { ruler = false, showcmd = false },
        twilight = { enabled = false },
        gitsigns = { enabled = false },
      },
    },
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
  },

}
