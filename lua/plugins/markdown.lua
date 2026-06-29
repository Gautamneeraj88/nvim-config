return {
  -- Browser preview — opens a live-reloading tab in your browser
  -- Install once with :MarkdownPreviewInstall after :Lazy sync
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    build = "cd app && npx --yes yarn install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview (browser)" },
    },
    config = function()
      vim.g.mkdp_auto_close = 1 -- close preview when buffer closes
    end,
  },

  -- ─── Image paste — drop clipboard screenshots straight into markdown ─────────
  -- Copy an image (screenshot, browser image), then <leader>mi in a .md buffer:
  -- the file is saved under ./assets/ and a ![](path) link is inserted at the cursor.
  {
    "HakonHarnes/img-clip.nvim",
    ft = { "markdown" },
    opts = {
      default = {
        dir_path = "assets",        -- save images next to the note in ./assets/
        relative_to_current_file = true,
        prompt_for_file_name = false,
        use_absolute_path = false,
      },
    },
    keys = {
      { "<leader>mi", "<cmd>PasteImage<cr>", ft = "markdown", desc = "Paste image from clipboard" },
    },
  },

  -- ─── Table mode — auto-format markdown tables as you type ────────────────────
  -- Toggle with <leader>mt, then type `|` separators — columns align automatically.
  -- Use `||` then Enter on a header row to draw the separator line.
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown" },
    cmd = { "TableModeToggle", "TableModeEnable" },
    init = function()
      vim.g.table_mode_corner = "|" -- markdown-compatible corners
    end,
    keys = {
      { "<leader>mt", "<cmd>TableModeToggle<cr>", ft = "markdown", desc = "Toggle table mode" },
    },
  },
}
