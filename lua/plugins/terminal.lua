-- Terminal inside Neovim via snacks.nvim (already bundled with LazyVim)
return {
  {
    "folke/snacks.nvim",
    opts = {
      input = { enabled = true }, -- replaces dressing.nvim for vim.ui.input
      terminal = {
        win = {
          style    = "terminal",
          border   = "rounded",
          height   = 0.4,   -- 40% of screen height
          width    = 0.95,
          position = "bottom",
        },
      },
    },
    keys = {
      -- <C-\> toggles a floating terminal (same key as before)
      {
        "<C-\\>",
        function() Snacks.terminal() end,
        mode = { "n", "t" },
        desc = "Toggle Terminal",
      },
      -- <leader>th opens a horizontal split terminal
      {
        "<leader>th",
        function() Snacks.terminal(nil, { win = { position = "bottom", height = 0.35 } }) end,
        desc = "Terminal (horizontal)",
      },
      -- <leader>tv opens a vertical split terminal
      {
        "<leader>tv",
        function() Snacks.terminal(nil, { win = { position = "right", width = 0.4 } }) end,
        desc = "Terminal (vertical)",
      },
    },
  },
}
