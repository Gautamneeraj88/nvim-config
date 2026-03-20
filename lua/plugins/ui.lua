return {
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
    "echasnovski/mini.indentscope",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
  },
}
