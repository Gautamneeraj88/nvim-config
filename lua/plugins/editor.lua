return {
  -- ─── TODO Comments — distinct colors per keyword ─────────────────────────────
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        TODO  = { color = "#4fc1ff" },  -- blue
        FIXME = { color = "#f7768e" },  -- red
        NOTE  = { color = "#9ece6a" },  -- green
        HACK  = { color = "#e0af68" },  -- yellow
        WARN  = { color = "#ff9e64" },  -- orange
        PERF  = { color = "#bb9af7" },  -- purple
        TEST  = { color = "#1abc9c" },  -- teal
      },
    },
  },

  -- ─── File Explorer (neo-tree only, no double explorer) ───────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,          -- show dotfiles dimmed, not hidden
          hide_dotfiles = false,
          hide_gitignored = true,
        },
        follow_current_file = { enabled = true }, -- auto-reveal file in tree
      },
      window = {
        width = 32,
        mappings = {
          ["<space>"] = "none", -- don't conflict with leader key
        },
      },
    },
  },

  -- Disable snacks.explorer so only neo-tree is used
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
      -- Dashboard shown when opening nvim with no file
      dashboard = {
        sections = {
          { section = "header" },
          { section = "keys",    gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },

  -- ─── Peek Definition (gp = peek, q = close) ─────────────────────────────────
  {
    "rmagatti/goto-preview",
    event = "LspAttach",
    opts = {
      width = 120,
      height = 20,
      border = "rounded",
      default_mappings = false, -- we set our own below
      opacity = nil,
      -- When the float opens, map Esc to close it (buffer-local, won't affect other windows)
      post_open_hook = function(buf, _)
        vim.keymap.set("n", "<Esc>", function()
          require("goto-preview").close_all_win()
        end, { buffer = buf, silent = true, desc = "Close peek window" })
      end,
    },
    keys = {
      { "gp",  "<cmd>lua require('goto-preview').goto_preview_definition()<cr>",      desc = "Peek Definition" },
      { "gpi", function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          local supported = vim.tbl_filter(function(c)
            return c.supports_method("textDocument/implementation")
          end, clients)
          if #supported == 0 then
            vim.notify("Peek implementation not supported for " .. vim.bo.filetype, vim.log.levels.WARN)
          else
            require("goto-preview").goto_preview_implementation()
          end
        end, desc = "Peek Implementation" },
      { "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<cr>",      desc = "Peek References" },
      { "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<cr>", desc = "Peek Type Definition" },
      { "gpc", "<cmd>lua require('goto-preview').close_all_win()<cr>",                desc = "Close All Peek Windows" },
    },
  },

  -- ─── Smooth Scrolling ────────────────────────────────────────────────────────
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      hide_cursor = false,
      stop_eof = true,
      duration_multiplier = 0.8, -- faster scroll (lower = faster)
      easing = "sine",
    },
  },
}
