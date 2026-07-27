return {
  -- ─── Smart Splits — resize splits + tmux-aware navigation ────────────────
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    opts = {
      at_edge = "stop",          -- don't wrap around when reaching window edge
      ignored_buftypes = { "nofile", "quickfix", "prompt" },
      ignored_filetypes = { "neo-tree", "aerial", "lazy", "mason", "trouble" },
    },
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
    config = function(_, opts)
      require("smart-splits").setup(opts)
      -- Tmux navigation — send Ctrl+hjkl to tmux if running inside tmux
      -- Requires the smart-splits tmux plugin: https://github.com/mrjones2014/smart-splits.nvim#tmux
      -- Add to tmux.conf: set -g @smart-splits-navigate-forward 'C-h'
      if vim.env.TMUX then
        vim.keymap.set("n", "<C-h>", function() require("smart-splits").move_cursor_left() end,  { desc = "Move to left split/tmux pane" })
        vim.keymap.set("n", "<C-j>", function() require("smart-splits").move_cursor_down() end,  { desc = "Move to below split/tmux pane" })
        vim.keymap.set("n", "<C-k>", function() require("smart-splits").move_cursor_up() end,    { desc = "Move to above split/tmux pane" })
        vim.keymap.set("n", "<C-l>", function() require("smart-splits").move_cursor_right() end, { desc = "Move to right split/tmux pane" })
      end
    end,
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
          "dap-repl", "dapui_scopes", "dapui_breakpoints",
          "dapui_stacks", "dapui_watches", "dapui_console",
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
