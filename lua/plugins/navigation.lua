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


  -- ─── Spider — smarter word motions for camelCase & snake_case ───────────────
  -- w/b/e now stop at camelCase humps and snake_case underscores
  -- e.g. "camelCaseWord" → w stops at each hump instead of jumping the whole word
  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    keys = {
      { "w",  function() require("spider").motion("w")  end, mode = { "n", "o", "x" }, desc = "Spider w" },
      { "e",  function() require("spider").motion("e")  end, mode = { "n", "o", "x" }, desc = "Spider e" },
      { "b",  function() require("spider").motion("b")  end, mode = { "n", "o", "x" }, desc = "Spider b" },
    },
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
