return {
  -- ─── Statusline with IST time ─────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- IST = UTC + 5:30 (India Standard Time), 24-hour format
      local function ist_time()
        local utc = os.time(os.date("!*t"))
        local ist = utc + (5 * 3600 + 30 * 60)
        return " " .. os.date("%H:%M", ist) .. " IST"
      end

      -- Replace default clock with IST time in the rightmost section
      opts.sections = opts.sections or {}
      opts.sections.lualine_z = { ist_time }

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
        backend = { "telescope", "fzf_lua", "builtin" },
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
