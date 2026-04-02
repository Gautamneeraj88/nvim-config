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

  -- ─── LSP Lens — reference & implementation counts above functions ─────────
  -- Shows  ● 4 references   ⚡ 2 implementations  above each function/class.
  -- Like VS Code's CodeLens — requires the LSP to support it (TS, Python, Go all do).
  -- Toggle with <leader>ll if you need a clean view temporarily.
  {
    "VidocqH/lsp-lens.nvim",
    event = "LspAttach",
    opts = {
      enable           = true,
      include_declaration = false,
      sections = {
        definition  = false, -- skip "1 definition" (not useful)
        references  = true,  -- show "X references"
        implements  = true,  -- show "X implementations"
        git_authors = false, -- skip git authors (noisy)
      },
    },
    keys = {
      { "<leader>ll", "<cmd>LspLensToggle<cr>", desc = "Toggle LSP Lens" },
    },
  },

  -- ─── Statusline ───────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local function clock()
        return " " .. os.date("%H:%M")
      end

      opts.sections = opts.sections or {}
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
