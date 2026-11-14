return {
  -- ─── Window Picker ───────────────────────────────────────────────────────────
  -- Visual popup to pick which split to open a file into.
  -- Used by neo-tree's "open_split" / "open_vsplit" / "open_tab" actions.
  {
    "s1n7ax/nvim-window-picker",
    event = "VeryLazy",
    opts = {
      hint = "floating-big-letter",
      filter_rules = {
        bo = { filetype = { "neo-tree", "aerial", "fidget", "lazy", "mason" } },
      },
    },
  },

  -- ─── Smart Splits — resize splits + tmux-aware navigation ────────────────
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    opts = {
      move = { at_edge = "stop" }, -- don't wrap around when reaching window edge
      ignored_buftypes = { "nofile", "quickfix", "prompt" },
      ignored_filetypes = { "neo-tree", "aerial", "lazy", "mason", "trouble" },
    },
    keys = {
      -- Resize splits with Alt+arrow keys
      { "<A-Left>",  function() require("smart-splits").resize_left() end,       desc = "Resize split left" },
      { "<A-Right>", function() require("smart-splits").resize_right() end,      desc = "Resize split right" },
      { "<A-Down>",  function() require("smart-splits").resize_down() end,       desc = "Resize split down" },
      { "<A-Up>",    function() require("smart-splits").resize_up() end,         desc = "Resize split up" },
      -- Navigate splits (tmux-aware — works across Neovim splits and tmux panes, normal & terminal mode)
      { "<C-h>",     function() require("smart-splits").move_cursor_left() end,  mode = { "n", "t" }, desc = "Move to left split" },
      { "<C-j>",     function() require("smart-splits").move_cursor_down() end,  mode = { "n", "t" }, desc = "Move to below split" },
      { "<C-k>",     function() require("smart-splits").move_cursor_up() end,    mode = { "n", "t" }, desc = "Move to above split" },
      { "<C-l>",     function() require("smart-splits").move_cursor_right() end, mode = { "n", "t" }, desc = "Move to right split" },
    },
    -- The <C-hjkl> keys above already cross into tmux panes when $TMUX is set —
    -- smart-splits detects the multiplexer itself. tmux side setup: see README.
  },

  -- ─── Spider — smarter word motions for camelCase & snake_case ───────────────
  -- w/b/e now stop at camelCase humps and snake_case underscores
  -- e.g. "camelCaseWord" → w stops at each hump instead of jumping the whole word
  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    init = function()
      -- Skip Spider in special buffers where w/b/e should behave normally
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "neo-tree", "aerial", "lazy", "mason", "trouble", "qf",
          "oil", "undotree", "help", "man",
        },
        callback = function(ev)
          vim.keymap.set({ "n", "o", "x" }, "w", "w", { buffer = ev.buf, desc = "w" })
          vim.keymap.set({ "n", "o", "x" }, "e", "e", { buffer = ev.buf, desc = "e" })
          vim.keymap.set({ "n", "o", "x" }, "b", "b", { buffer = ev.buf, desc = "b" })
        end,
      })
    end,
    keys = {
      { "w",  function() require("spider").motion("w")  end, mode = { "n", "o", "x" }, desc = "Spider w" },
      { "e",  function() require("spider").motion("e")  end, mode = { "n", "o", "x" }, desc = "Spider e" },
      { "b",  function() require("spider").motion("b")  end, mode = { "n", "o", "x" }, desc = "Spider b" },
    },
  },

  -- ─── Harpoon v2 — instant file jumping ──────────────────────────────────────
  -- Pin your 4 active working files and switch instantly with single keystrokes
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = {
        save_on_toggle = true,
      },
    },
    -- Harpoon 2 defines setup with a colon (Harpoon:setup). lazy.nvim's default
    -- calls require("harpoon").setup(opts) with a dot, which passes opts as
    -- `self` and silently drops every setting — so call it explicitly.
    config = function(_, opts) require("harpoon"):setup(opts) end,
    keys = {
      { "<leader>H", function() require("harpoon"):list():add() end, desc = "Harpoon Add File" },
      { "<leader>h", function() local harpoon = require("harpoon"); harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon Menu" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1" },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2" },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3" },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4" },
      { "[h",        function() require("harpoon"):list():prev() end,     desc = "Harpoon Prev File" },
      { "]h",        function() require("harpoon"):list():next() end,     desc = "Harpoon Next File" },
    },
  },

  -- ─── Project Switcher ─────────────────────────────────────────────────────────
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
    },
  },
}
