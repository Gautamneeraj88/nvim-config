-- Multiple themes available — switch with <leader>uT
-- Current default: oxocarbon
return {
  -- Oxocarbon (IBM Carbon design — near-black bg, electric blue accents)
  {
    "nyoom-engineering/oxocarbon.nvim",
    priority = 1000,
  },

  -- Cyberdream (cyberpunk neon, vibrant)
  {
    "scottmckendry/cyberdream.nvim",
    priority = 1000,
    opts = {
      italic_comments = true,
      transparent = false,
    },
  },

  -- Catppuccin
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

  -- Set oxocarbon as the default
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "oxocarbon" },
  },
}
