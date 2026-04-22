return {
  -- ─── Sticky Context Header ────────────────────────────────────────────────
  -- Pins the current function/class signature at the top when you scroll past it
  -- Like VS Code / Zed's "sticky scroll" feature
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines      = 3,  -- max lines of context shown at top
      min_window_height = 20,
      mode           = "cursor",
      separator      = "─",
    },
  },

  -- ─── LSP Progress Indicator ──────────────────────────────────────────────
  -- Shows a spinner in the bottom-right while LSP is indexing/loading
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        display = { render_limit = 4, done_ttl = 2 },
      },
      notification = {
        override_vim_notify = false, -- let snacks/noice handle vim.notify
        window = { winblend = 0 },
      },
    },
  },


  -- ─── Noice — centered floating cmdline popup ─────────────────────────────
  -- LazyVim already enables noice — this just repositions the command-line
  -- from the default bottom position to a centered floating dialog.
  -- Pressing : or / now opens a clean popup in the middle of the screen.
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      -- Filter noisy one-line messages that don't need notification treatment
      opts.routes = vim.list_extend(opts.routes or {}, {
        { filter = { event = "msg_show", find = "written" },          opts = { skip = true } },
        { filter = { event = "msg_show", find = "%d+ lines? yanked" }, opts = { skip = true } },
        { filter = { event = "msg_show", find = "search hit" },        opts = { skip = true } },
        { filter = { event = "msg_show", find = "Already at" },        opts = { skip = true } },
        { filter = { event = "msg_show", find = "%d+ fewer lines" },   opts = { skip = true } },
        { filter = { event = "msg_show", find = "%d+ more lines" },    opts = { skip = true } },
        { filter = { event = "msg_show", find = "%d+ lines" },         opts = { skip = true } },
      })

      opts.views = vim.tbl_deep_extend("force", opts.views or {}, {
        cmdline_popup = {
          position = { row = "40%", col = "50%" }, -- centered in screen
          size     = { width = 90, height = "auto" }, -- 90 wide so neo-tree prompts aren't cut off
          border   = { style = "rounded", padding = { 0, 1 } },
          zindex   = 200, -- above neo-tree and other panels
        },
        popupmenu = {                              -- completion dropdown below cmdline
          relative = "editor",
          position = { row = "57%", col = "50%" },
          size     = { width = 90, height = 10 },
          border   = { style = "rounded", padding = { 0, 1 } },
          zindex   = 200,
        },
      })
      return opts
    end,
  },

  -- ─── Statusline ───────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local function clock()
        return " " .. os.date("%H:%M")
      end

      -- Show active Python venv name in statusline (only for Python files)
      local function venv()
        if vim.bo.filetype ~= "python" then return "" end
        local path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
        if not path then return "" end
        return " " .. vim.fn.fnamemodify(path, ":t")
      end

      -- Show count of unresolved merge conflict markers.
      -- Cached by changedtick — only rescans when buffer content actually changes.
      local _cc = {}
      local function conflicts()
        local buf  = vim.api.nvim_get_current_buf()
        local tick = vim.api.nvim_buf_get_changedtick(buf)
        if not _cc[buf] or _cc[buf].tick ~= tick then
          local n = 0
          for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
            if line:match("^<<<<<<<") then n = n + 1 end
          end
          _cc[buf] = { tick = tick, n = n }
        end
        return _cc[buf].n > 0 and (" ⚡" .. _cc[buf].n) or ""
      end

      opts.sections = opts.sections or {}
      opts.sections.lualine_x = vim.list_extend(opts.sections.lualine_x or {}, { conflicts, venv })
      opts.sections.lualine_z = { "location", clock }

      return opts
    end,
  },

  -- ─── Code Action Lightbulb ────────────────────────────────────────────────
  -- Shows 󰌶 in the sign column when LSP code actions are available on this line
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      autocmd  = { enabled = true },
      sign     = { enabled = true, text = "󰌶" },
      virtual_text = { enabled = false },
    },
  },

  -- ─── Panel Layout (edgy) — VS Code-style persistent sidebars ────────────────
  -- neo-tree always opens left, aerial right, quickfix/trouble/help bottom
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      animate = { enabled = false }, -- mini.animate handles window animations
      left = {
        {
          title = " Explorer",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { width = 40 },
        },
      },
      right = {
        {
          title = " Outline",
          ft = "aerial",
          size = { width = 30 },
        },
      },
      bottom = {
        { ft = "qf",      title = " QuickFix",    size = { height = 0.3 } },
        { ft = "trouble", title = " Diagnostics", size = { height = 0.3 } },
        {
          ft = "help",
          size = { height = 0.4 },
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
      },
    },
  },

  -- ─── Indent guides ────────────────────────────────────────────────────────
  -- LazyVim includes mini.indentscope — this just tweaks the style
  {
    "nvim-mini/mini.indentscope",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
  },
}
