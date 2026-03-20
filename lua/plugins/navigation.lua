return {
  -- ─── Smart Splits — resize splits + tmux-aware navigation ────────────────
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      -- Resize splits with Alt+arrow keys
      { "<A-Left>",  function() require("smart-splits").resize_left() end,       desc = "Resize split left" },
      { "<A-Right>", function() require("smart-splits").resize_right() end,      desc = "Resize split right" },
      { "<A-Down>",  function() require("smart-splits").resize_down() end,       desc = "Resize split down" },
      { "<A-Up>",    function() require("smart-splits").resize_up() end,         desc = "Resize split up" },
      -- Navigate splits (tmux-aware — works across Neovim and tmux panes)
      { "<C-h>",     function() require("smart-splits").move_cursor_left() end,  desc = "Move to left split" },
      { "<C-j>",     function() require("smart-splits").move_cursor_down() end,  desc = "Move to below split" },
      { "<C-k>",     function() require("smart-splits").move_cursor_up() end,    desc = "Move to above split" },
      { "<C-l>",     function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" },
    },
  },


  -- ─── Multi-cursor ─────────────────────────────────────────────────────────────
  -- Select a word, keep adding next occurrences, edit all at once
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_theme                      = "ocean"
      vim.g.VM_show_warnings              = 0
      vim.g.VM_silent_exit                = 1
      -- Use <C-n> to select word, n/N for next/prev, q to skip, Q to remove
      vim.g.VM_maps = {
        ["Find Under"]         = "<C-n>",   -- select word under cursor
        ["Find Subword Under"] = "<C-n>",
        ["Select All"]         = "<leader>ma", -- select ALL occurrences at once
        ["Add Cursor Down"]    = "<C-Down>",   -- add cursor on line below
        ["Add Cursor Up"]      = "<C-Up>",     -- add cursor on line above
        ["Exit"]               = "<Esc>",
      }
    end,
  },

  -- ─── Project Switcher ─────────────────────────────────────────────────────────
  -- Snacks has a built-in project picker based on recent git roots
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fp",
        function() Snacks.picker.projects() end,
        desc = "Switch Project",
      },
    },
  },
}
