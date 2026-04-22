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
  -- ─── Neoconf — project-local LSP / Neovim settings ───────────────────────────
  -- Drop a .neoconf.json at the project root to override LSP settings per-project.
  -- Example: set typeCheckingMode=strict for one repo, off for another.
  -- Also teaches luals about Neovim's Lua API when editing this config.
  {
    "folke/neoconf.nvim",
    cmd   = "Neoconf",
    opts  = { global_settings = "neoconf.json" },
    -- Must be set up before nvim-lspconfig so it can hook on_new_config for each server
    config = function(_, opts) require("neoconf").setup(opts) end,
  },
  -- Wire neoconf as a dependency so it's guaranteed to load first
  {
    "neovim/nvim-lspconfig",
    dependencies = { "folke/neoconf.nvim" },
  },

  -- ─── Hardtime — break bad vim habits ─────────────────────────────────────────
  -- Notifies (doesn't block) when you repeat hjkl more than once or spam dd.
  -- Arrow keys are kept enabled (useful in insert mode / non-vim contexts).
  -- Toggle with <leader>uh if it gets annoying during a specific task.
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "VeryLazy",
    opts = {
      max_time       = 1000,  -- ms window to detect repeated keys
      max_count      = 3,     -- allow up to 3 repeats before notifying
      disable_mouse  = false, -- keep mouse (we use it intentionally)
      hint           = true,
      notification   = true,
      restriction_mode = "hint", -- hint only, don't block the key
      -- Allow arrow keys — useful in insert mode and for non-vim-native contexts.
      -- Hardtime's default disabled_keys blocks them; empty table re-enables.
      disabled_keys = {
        ["<Up>"]    = {},
        ["<Down>"]  = {},
        ["<Left>"]  = {},
        ["<Right>"] = {},
      },
      disabled_filetypes = {
        "neo-tree", "aerial", "lazy", "mason", "trouble", "qf",
        "dap-repl", "dapui_scopes", "dapui_breakpoints",
        "dapui_stacks", "dapui_watches", "help", "undotree",
        "oil", "toggleterm",
      },
    },
    keys = {
      { "<leader>uh", "<cmd>Hardtime toggle<cr>", desc = "Toggle Hardtime" },
    },
  },

  -- ─── TODO Comments — custom colors only, everything else default ─────────────
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        TODO  = { color = "#7E9CD8" }, -- kanagawa crystalBlue
        FIXME = { color = "#E82424" }, -- kanagawa samuraiRed
        NOTE  = { color = "#98BB6C", alt = { "INFORMATION" } }, -- kanagawa springGreen
        HACK  = { color = "#E6C384" }, -- kanagawa carpYellow
        WARN  = { color = "#FF9E3B" }, -- kanagawa roninYellow
        PERF  = { color = "#957FB8" }, -- kanagawa oniViolet
        TEST  = { color = "#7AA89F" }, -- kanagawa waveAqua2
        INFO  = { color = "#6A9589" }, -- kanagawa waveAqua1
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
        float = { source = true }, -- border from global opt.winborder
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

  -- Disable snacks.explorer (neo-tree is used instead) and snacks.words
  -- (vim-illuminate already handles word highlighting with LSP+treesitter fallback)
  -- Also lower the big-file threshold — LazyVim default is 1.5MB which is too high;
  -- at 200KB files start causing noticeable lag with treesitter + biscuits + hlargs running together
  {
    "folke/snacks.nvim",
    opts = {
      bigfile  = { size = 200 * 1024 }, -- 200KB — disables treesitter/syntax/indentscope automatically
      explorer = { enabled = false },
      words    = { enabled = false }, -- illuminate handles this with more control
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
      keymaps = { basic = true, extra = true },
      options = { mode = "cursor", easing = "quadratic", max_delta = { time = 150 } },
    },
    config = function(_, opts)
      require("cinnamon").setup(opts)
      -- Mouse: scroll viewport only, cursor stays (VSCode behaviour)
      -- Use "3<C-e>" not "<C-e><C-e><C-e>" — one command = one cinnamon animation
      local modes = { "n", "v", "i" }
      vim.keymap.set(modes, "<ScrollWheelDown>", "3<C-e>", { silent = true })
      vim.keymap.set(modes, "<ScrollWheelUp>",   "3<C-y>", { silent = true })
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

  -- ─── Oil — edit filesystem as a buffer ───────────────────────────────────────
  -- Open parent dir with  -  and edit like text: rename, move (dd/p), bulk delete
  -- Writes happen only on :w — nothing is destructive until you save.
  -- neo-tree stays as the default explorer; oil handles bulk file operations.
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent dir (oil)" },
    },
    opts = {
      default_file_explorer = false,          -- keep neo-tree as <leader>e
      columns = { "icon", "permissions", "size", "mtime" },
      delete_to_trash = true,                 -- safer than permanent delete
      skip_confirm_for_simple_edits = true,
      view_options = { show_hidden = true },
      float = { padding = 2, border = "rounded" },
      keymaps = {
        ["<CR>"] = "actions.select",
        ["-"]    = "actions.parent",
        ["_"]    = "actions.open_cwd",
        ["g."]   = "actions.toggle_hidden",
        ["gs"]   = "actions.change_sort",
        ["gx"]   = "actions.open_external",
        ["<C-c>"] = "actions.close",
        ["?"]    = "actions.show_help",
      },
    },
  },

}
