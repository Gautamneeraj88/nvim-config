return {
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
