-- ─── Neo-tree explorer helpers ───────────────────────────────────────────────
-- Defined at module level so keymaps.lua and the FileType autocmd can share them.

-- Update edgy's left panel width (persists across layout redraws).
-- Falls back to a direct window resize when edgy is not active.
local function neo_resize(delta)
  local ok, cfg = pcall(require, "edgy.config")
  if ok and cfg.layout and cfg.layout.left then
    cfg.layout.left.size = math.max(20, cfg.layout.left.size + delta)
    require("edgy.layout").update()
    return
  end
  vim.cmd("vertical resize " .. math.max(20, vim.fn.winwidth(0) + delta))
end

return {
  -- ─── TODO Comments — custom colors only, everything else default ─────────────
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        TODO  = { color = "#89b4fa" }, -- catppuccin blue
        FIXME = { color = "#f38ba8" }, -- catppuccin red
        NOTE  = { color = "#a6e3a1", alt = { "INFORMATION" } }, -- catppuccin green
        HACK  = { color = "#f9e2af" }, -- catppuccin yellow
        WARN  = { color = "#fab387" }, -- catppuccin peach
        PERF  = { color = "#cba6f7" }, -- catppuccin mauve
        TEST  = { color = "#94e2d5" }, -- catppuccin teal
        INFO  = { color = "#89dceb" }, -- catppuccin sky
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
  -- <leader>e / <leader>o are registered in keymaps.lua (VeryLazy + LazyLoad re-apply).
  -- > / < resize keys are set in opts.window.mappings AND in a FileType autocmd
  -- so they work regardless of load order.
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      -- Use nui.nvim floating popups for create/rename input and delete confirm
      opts.use_popups_for_input = true
      opts.popup_border_style   = "rounded"

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
    config = function(_, opts)
      -- Standard neo-tree setup (mirrors LazyVim's config + our opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end
      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED,   handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)

      -- Belt-and-suspenders: also register > / < as buffer-local keymaps
      -- every time a neo-tree buffer opens, so they survive any opts ordering.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          vim.keymap.set("n", ">", function() neo_resize(5) end,
            { buffer = buf, nowait = true, silent = true, desc = "Widen explorer" })
          vim.keymap.set("n", "<", function() neo_resize(-5) end,
            { buffer = buf, nowait = true, silent = true, desc = "Narrow explorer" })
        end,
      })

      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
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

  -- ─── VSCode-style smooth scrolling ──────────────────────────────────────────
  {
    "declancm/cinnamon.nvim",
    event = "VeryLazy",
    opts = {
      keymaps  = { basic = true, extra = true },
      options  = { mode = "cursor", easing = "quadratic", max_delta = { time = 150 } },
    },
    config = function(_, opts)
      require("cinnamon").setup(opts)
      -- Mouse: scroll viewport only, cursor stays (VSCode behaviour)
      local modes = { "n", "v", "i" }
      vim.keymap.set(modes, "<ScrollWheelDown>", "<C-e><C-e><C-e>", { silent = true })
      vim.keymap.set(modes, "<ScrollWheelUp>",   "<C-y><C-y><C-y>", { silent = true })
    end,
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

}
