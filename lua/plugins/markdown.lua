return {
  -- Browser preview — opens a live-reloading tab in your browser
  -- Install once with :MarkdownPreviewInstall after :Lazy sync
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = "cd app && npx --yes yarn install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview (browser)" },
    },
    config = function()
      vim.g.mkdp_auto_close = 1      -- close preview when buffer closes
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ""        -- uses your default browser
    end,
  },
}
