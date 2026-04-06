-- Multiple themes available — switch with <leader>uT
-- Current default: kanagawa wave
return {
  -- ─── Catppuccin Mocha ─────────────────────────────────────────────────────
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    opts = {
      flavour    = "mocha",    -- mocha=dark | macchiato | frappe | latte=light
      term_colors = true,      -- set terminal colors to catppuccin palette

      styles = {
        comments     = { "italic" },
        conditionals = { "italic" },
        keywords     = { "bold" },
        functions    = { "bold" },
        types        = { "bold" },
        operators    = {},
        strings      = {},
        variables    = {},
        numbers      = {},
        booleans     = {},
        properties   = {},
        loops        = {},
      },

      integrations = {
        -- Editor
        aerial           = true,
        blink_cmp        = true,
        diffview         = true,
        fidget           = true,
        fzf              = true,
        gitsigns         = true,
        lsp_trouble      = true,
        markdown         = true,
        mason            = true,
        neo_tree         = true,
        neotest          = true,
        noice            = true,
        notify           = true,
        rainbow_delimiters = true,
        snacks           = { enabled = true, indent = true },
        treesitter       = true,
        treesitter_context = true,
        which_key        = true,
        -- mini
        mini             = { enabled = true, indentscope_color = "lavender" },
        -- DAP
        dap              = true,
        dap_ui           = true,
      },
    },
  },

  -- ─── Other themes (lazy — load on demand via <leader>uT) ─────────────────
  { "nyoom-engineering/oxocarbon.nvim" },  -- near-black IBM Carbon

  {
    "scottmckendry/cyberdream.nvim",
    opts = { italic_comments = true, transparent = false },
  },

  {
    "folke/tokyonight.nvim",
    opts = { style = "night" },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = { variant = "main" },
  },

  -- ─── Kanagawa Wave — default ──────────────────────────────────────────────
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,           -- load first so other plugins pick up highlights
    opts = {
      compile      = true,     -- compile to Lua bytecode for faster startup (run :KanagawaCompile once if colors look off)
      theme        = "wave",   -- wave=dark | dragon=darker | lotus=light
      background   = { dark = "wave", light = "lotus" },
      terminalColors = true,
      styles = {
        comments   = { italic = true },
        keywords   = { bold = true },
        functions  = { bold = true },
        types      = { bold = true },
      },
    },
  },

  -- ─── Set kanagawa wave as the default ────────────────────────────────────
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "kanagawa" },
  },
}
