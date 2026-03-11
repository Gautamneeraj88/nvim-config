return {
  -- ─── Color Highlighter ────────────────────────────────────────────────────────
  -- Shows hex/rgb/hsl/css/tailwind colors as colored backgrounds inline
  -- e.g. #ff0000 shows with a red background, "red" shows red, bg-red-500 shows red
  {
    "brenoprata18/nvim-highlight-colors",
    event = "BufReadPost",
    opts = {
      render              = "background", -- show color as background behind the code
      enable_named_colors = true,         -- highlight "red", "blue", etc.
      enable_tailwind     = true,         -- highlight Tailwind classes like bg-red-500
    },
  },

  -- ─── Package Info — npm version hints in package.json ────────────────────────
  -- Shows current installed version and whether a package is outdated
  -- Only activates when you open package.json
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = "json",
    config = function()
      require("package-info").setup({
        hide_up_to_date      = false, -- show version even when up to date
        hide_unstable_versions = false,
        package_manager      = "npm", -- change to "yarn" or "pnpm" if needed
      })
    end,
    keys = {
      { "<leader>np", "<cmd>lua require('package-info').toggle()<cr>",          desc = "Toggle package versions" },
      { "<leader>nu", "<cmd>lua require('package-info').update()<cr>",          desc = "Update package" },
      { "<leader>nd", "<cmd>lua require('package-info').delete()<cr>",          desc = "Delete package" },
      { "<leader>ni", "<cmd>lua require('package-info').install()<cr>",         desc = "Install new package" },
      { "<leader>nc", "<cmd>lua require('package-info').change_version()<cr>",  desc = "Change package version" },
    },
  },

  -- ─── Wakatime — automatic coding time tracking ───────────────────────────────
  -- Runs silently in the background, tracks time per project/language/file
  -- View stats at wakatime.com (free account available)
  -- First use: run :WakaTimeApiKey and paste your API key from wakatime.com
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
    -- No configuration needed — just needs your API key on first use
    -- :WakaTimeApiKey  → set your API key
    -- :WakaTimeToday   → see today's coding time
  },
}
