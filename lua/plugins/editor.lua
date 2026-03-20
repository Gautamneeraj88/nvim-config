return {
  -- ─── TODO Comments — custom colors only, everything else default ─────────────
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        TODO  = { color = "#4fc1ff" }, -- blue
        FIXME = { color = "#f7768e" }, -- red
        NOTE  = { color = "#9ece6a", alt = { "INFORMATION" } }, -- green
        HACK  = { color = "#e0af68" }, -- yellow
        WARN  = { color = "#ff9e64" }, -- orange
        PERF  = { color = "#bb9af7" }, -- purple
        TEST  = { color = "#1abc9c" }, -- teal
        INFO  = { color = "#C44A3A" }, -- reddish-orange
      },
    },
  },

  -- ─── Diagnostics — inline text only on cursor line, full float via <leader>cd ─
  {
    "LazyVim/LazyVim",
    opts = {
      diagnostics = {
        virtual_text = {
          only_current_line = true, -- no clutter on other lines
          source = "if_many",       -- show source when multiple (eslint vs ts)
          spacing = 2,
          prefix = "●",
          format = function(d)
            local msg = d.message
            if #msg > 60 then msg = msg:sub(1, 57) .. "..." end
            return msg
          end,
        },
        float = { source = true, border = "rounded" },
      },
    },
  },

  -- ─── Inline Git Blame (GitLens-style) ───────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- show blame at end of current line
      current_line_blame_opts = {
        delay = 500,
        virt_text_pos = "eol",
      },
      current_line_blame_formatter = "  <author>, <author_time:%d %b %Y> · <summary>",
    },
  },

  -- ─── File Explorer (neo-tree only, no double explorer) ───────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      -- Resize helper: update edgy.config.layout.left.size (the edgebar's total
      -- width) then call layout.update() — this is the only way that persists.
      -- Direct nvim_win_set_width gets reverted by edgy on its next layout pass.
      local function neo_resize(delta)
        local ok, cfg = pcall(require, "edgy.config")
        if ok and cfg.layout and cfg.layout.left then
          cfg.layout.left.size = math.max(20, cfg.layout.left.size + delta)
          require("edgy.layout").update()
          return
        end
        -- Fallback when edgy is not active
        vim.cmd("vertical resize " .. math.max(20, vim.fn.winwidth(0) + delta))
      end

      opts.filesystem = vim.tbl_deep_extend("force", opts.filesystem or {}, {
        filtered_items = {
          visible       = true,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
        follow_current_file = { enabled = true },
      })
      opts.window = vim.tbl_deep_extend("force", opts.window or {}, {
        width = 40,
        mappings = {
          ["<space>"] = "none",
          [">"]       = function() neo_resize(5) end,
          ["<"]       = function() neo_resize(-5) end,
        },
      })
      return opts
    end,
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
