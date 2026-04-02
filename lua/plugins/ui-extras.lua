return {
  -- ─── Breadcrumbs Bar (dropbar) ────────────────────────────────────────────
  -- Shows  file > class > function  at the top of each window
  -- Click any segment to jump there — like VS Code / Zed breadcrumbs
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPost",
    opts = {
      bar = {
        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils   = require("dropbar.utils")
          if vim.bo[buf].buftype == "terminal" then
            return { sources.terminal }
          end
          return {
            utils.source.fallback({ sources.lsp, sources.treesitter }),
          }
        end,
      },
    },
  },


  -- ─── Color Highlighter ────────────────────────────────────────────────────────
  -- Shows hex/rgb/hsl/css/tailwind colors as colored backgrounds inline
  -- e.g. #ff0000 shows with a red background, "red" shows red, bg-red-500 shows red
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {
      filetypes = {
        "*",                              -- enable for all filetypes
        css = { css = true },
        html = { names = true },
      },
      user_default_options = {
        names         = false,            -- don't highlight color names globally (too noisy in code)
        RRGGBBAA      = true,
        tailwind      = true,             -- highlight Tailwind classes
        mode          = "background",     -- show as colored background
      },
    },
  },

  -- ─── Package Info — npm version hints in package.json ────────────────────────
  -- Shows current installed version and whether a package is outdated
  -- Only activates when you open package.json
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = { "BufReadPost */package.json" },
    config = function()
      require("package-info").setup({
        package_manager = "npm", -- change to "yarn" or "pnpm" if needed
      })
    end,
    keys = {
      { "<leader>np", function() require("package-info").toggle() end,         desc = "Toggle package versions" },
      { "<leader>nu", function() require("package-info").update() end,         desc = "Update package" },
      { "<leader>nd", function() require("package-info").delete() end,         desc = "Delete package" },
      { "<leader>ni", function() require("package-info").install() end,        desc = "Install new package" },
      { "<leader>nc", function() require("package-info").change_version() end, desc = "Change package version" },
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
