return {
  -- ─── Multi-cursor ─────────────────────────────────────────────────────────────
  -- Select a word, keep adding next occurrences, edit all at once
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_theme                      = "ocean"
      vim.g.VM_highlight_matches          = "underline"
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
  -- Track and jump between your projects instantly
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        -- Detect project root by these files/folders
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", "package.json", "pyproject.toml", "go.mod", "Makefile", ".env" },
        silent_chdir    = true,  -- silently change to project root on open
        scope_chdir     = "global",
        show_hidden     = false,
      })
    end,
    keys = {
      {
        "<leader>fp",
        function() Snacks.picker.projects() end,
        desc = "Switch Project",
      },
    },
  },
}
