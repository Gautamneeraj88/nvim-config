-- Multiple themes available — switch with <leader>uT
-- Current default: catppuccin-mocha
return {
  -- Catppuccin (default)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",                   -- mocha=dark, macchiato, frappe, latte=light
      integrations = {
        neo_tree = true,
        which_key = true,
        fzf = true,
        mason = true,
        cmp = true,
        gitsigns = true,
        treesitter = true,
        mini = { enabled = true },
      },
    },
  },

  -- Tokyonight (classic, clean)
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = { style = "night" }, -- night, storm, moon, day
  },

  -- Rose Pine (warm, elegant)
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = { variant = "main" }, -- main, moon, dawn
  },

  -- Kanagawa (dark Japanese aesthetic)
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = { theme = "wave" }, -- wave, dragon, lotus
  },

  -- Set catppuccin as the default
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
