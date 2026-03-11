-- Plugins that were previously loaded via LazyVim extras
-- Added directly here since those extras don't exist in the current LazyVim version
return {
  -- ─── Project-wide Find & Replace (Spectre) ───────────────────────────────────
  {
    "nvim-pack/nvim-spectre",
    cmd  = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      { "<leader>sr", function() require("spectre").open() end,                               desc = "Search & Replace (Spectre)" },
      { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end,  desc = "Search word under cursor" },
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
        options    = { enabled = true, ruler = false, showcmd = false },
        twilight   = { enabled = false },
        gitsigns   = { enabled = false },
        tmux       = { enabled = false },
        alacritty  = { enabled = false },
      },
    },
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
  },

  -- ─── Flash — jump anywhere with 2 keystrokes ──────────────────────────────────
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts  = {
      modes = {
        search = { enabled = false }, -- don't activate flash on / search
        char   = { enabled = false }, -- don't override f/t motions
      },
    },
    keys = {
      { "s",     function() require("flash").jump() end,              mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "S",     function() require("flash").treesitter() end,        mode = { "n", "x", "o" }, desc = "Flash treesitter" },
      { "r",     function() require("flash").remote() end,            mode = "o",               desc = "Remote flash" },
      { "<C-s>", function() require("flash").toggle() end,            mode = "c",               desc = "Toggle flash search" },
    },
  },
}
