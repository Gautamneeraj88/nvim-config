return {
  -- ─── Yank History — cycle through past yanks after pasting ───────────────────
  -- Press p to paste, then <C-p>/<C-n> to cycle through yank ring
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    opts = {
      ring = { storage = "memory" },
      highlight = { on_put = true, on_yank = true, timer = 200 },
    },
    keys = {
      { "p",          "<Plug>(YankyPutAfter)",      mode = { "n", "x" }, desc = "Put after" },
      { "P",          "<Plug>(YankyPutBefore)",     mode = { "n", "x" }, desc = "Put before" },
      { "<C-p>",      "<Plug>(YankyCycleForward)",  desc = "Cycle yank forward" },
      { "<C-n>",      "<Plug>(YankyCycleBackward)", desc = "Cycle yank backward" },
      { "<leader>fy", "<cmd>YankyRingHistory<cr>",  desc = "Yank History" },
    },
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
    opts  = { options = vim.opt.sessionoptions:get() },
    keys  = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't save session" },
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
