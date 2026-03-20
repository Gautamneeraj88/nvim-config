return {
  -- ─── TODO Comments — distinct colors per keyword ─────────────────────────────
  {
    "folke/todo-comments.nvim",
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        TODO  = { icon = " ", color = "#4fc1ff" }, -- blue
        FIXME = { icon = " ", color = "#f7768e" }, -- red
        NOTE  = { icon = " ", color = "#9ece6a", alt = { "INFORMATION" } }, -- green
        HACK  = { icon = " ", color = "#e0af68" }, -- yellow
        WARN  = { icon = " ", color = "#ff9e64" }, -- orange
        PERF  = { icon = " ", color = "#bb9af7" }, -- purple
        TEST  = { icon = " ", color = "#1abc9c" }, -- teal
        INFO  = { icon = " ", color = "#C44A3A" }, -- reddish-orange
      },
    },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
    },
    config = function(_, opts)
      require("todo-comments").setup(opts)

      -- Patch: the plugin skips signs for multiline block comments (is_multiline guard).
      -- Wrap highlight() to do an extra sign-placement pass covering block comment lines.
      local hl_mod = require("todo-comments.highlight")
      local Config = require("todo-comments.config")
      local orig = hl_mod.highlight

      hl_mod.highlight = function(buf, first, last, event)
        orig(buf, first, last, event)
        -- Extra pass: place signs for any line that matches a keyword,
        -- regardless of whether it was skipped as a multiline continuation.
        local lines = vim.api.nvim_buf_get_lines(buf, first, last + 1, false)
        for l, line in ipairs(lines) do
          local lnum = first + l - 1
          local ok, start, _, kw = pcall(hl_mod.match, line)
          if ok and start and kw then
            kw = Config.keywords[kw] or kw
            local kopts = Config.options.keywords[kw]
            if kopts then
              local show_sign = Config.options.signs
              if kopts.signs ~= nil then show_sign = kopts.signs end
              if show_sign then
                local placed = vim.fn.sign_getplaced(buf, { group = "todo-signs", lnum = lnum + 1 })
                if not placed[1] or #placed[1].signs == 0 then
                  vim.fn.sign_place(0, "todo-signs", "todo-sign-" .. kw, buf,
                    { lnum = lnum + 1, priority = Config.options.sign_priority })
                end
              end
            end
          end
        end
      end
    end,
  },

  -- ─── File Explorer (neo-tree only, no double explorer) ───────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- show dotfiles dimmed, not hidden
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
      dashboard = {
        preset = {
          header = [[
  ██████╗ ██████╗ ██████╗ ██╗███╗   ██╗ ██████╗     ████████╗██╗███╗   ███╗███████╗
 ██╔════╝██╔═══██╗██╔══██╗██║████╗  ██║██╔════╝     ╚══██╔══╝██║████╗ ████║██╔════╝
 ██║     ██║   ██║██║  ██║██║██╔██╗ ██║██║  ███╗       ██║   ██║██╔████╔██║█████╗
 ██║     ██║   ██║██║  ██║██║██║╚██╗██║██║   ██║       ██║   ██║██║╚██╔╝██║██╔══╝
 ╚██████╗╚██████╔╝██████╔╝██║██║ ╚████║╚██████╔╝       ██║   ██║██║ ╚═╝ ██║███████╗
  ╚═════╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
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
      -- When the float opens, map Esc to close it (buffer-local, won't affect other windows)
      post_open_hook = function(buf, _)
        vim.keymap.set("n", "<Esc>", function()
          require("goto-preview").close_all_win()
        end, { buffer = buf, silent = true, desc = "Close peek window" })
      end,
    },
    keys = {
      {
        "gp",
        function()
          require("goto-preview").goto_preview_definition()
        end,
        desc = "Peek Definition",
      },
      {
        "gpi",
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          local supported = vim.tbl_filter(function(c)
            return c.supports_method("textDocument/implementation")
          end, clients)
          if #supported == 0 then
            vim.notify("Peek implementation not supported for " .. vim.bo.filetype, vim.log.levels.WARN)
          else
            require("goto-preview").goto_preview_implementation()
          end
        end,
        desc = "Peek Implementation",
      },
      {
        "gpr",
        function()
          require("goto-preview").goto_preview_references()
        end,
        desc = "Peek References",
      },
      {
        "gpt",
        function()
          require("goto-preview").goto_preview_type_definition()
        end,
        desc = "Peek Type Definition",
      },
      {
        "gpc",
        function()
          require("goto-preview").close_all_win()
        end,
        desc = "Close All Peek Windows",
      },
    },
  },

  -- ─── Smooth Scrolling ────────────────────────────────────────────────────────
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      hide_cursor = false,
      duration_multiplier = 0.8, -- faster scroll (lower = faster)
      easing = "sine",
    },
  },
}
