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
      -- <leader>Tf opens the floating terminal (explicit, under the Terminal group)
      {
        "<leader>Tf",
        function() Snacks.terminal() end,
        desc = "Terminal (float)",
      },
      -- <leader>Th opens a horizontal split terminal
      {
        "<leader>Th",
        function() Snacks.terminal(nil, { win = { position = "bottom", height = 0.35 } }) end,
        desc = "Terminal (horizontal)",
      },
      -- <leader>Tv opens a vertical split terminal
      {
        "<leader>Tv",
        function() Snacks.terminal(nil, { win = { position = "right", width = 0.4 } }) end,
        desc = "Terminal (vertical)",
      },
    },
  },
}
