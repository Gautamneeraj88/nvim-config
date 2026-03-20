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


  -- ─── Statusline with system time ─────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local function clock()
        return " " .. os.date("%H:%M")
      end

      opts.sections = opts.sections or {}
      opts.sections.lualine_z = { clock }

      return opts
    end,
  },

  -- ─── Better UI for inputs & selects (vim.ui.input / vim.ui.select) ─────────
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        default_prompt = "➤ ",
        win_options = { winblend = 0 },
      },
      select = {
        backend = { "fzf_lua", "builtin" },
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
