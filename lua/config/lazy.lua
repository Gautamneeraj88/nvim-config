local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim core — gives you file search, LSP, git, completion, etc. out of the box
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Languages you actually use
    { import = "lazyvim.plugins.extras.lang.typescript" }, -- TypeScript + JavaScript
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.json" },

    -- Prettier for TS/JS/CSS formatting
    { import = "lazyvim.plugins.extras.formatting.prettier" },

    -- Markdown support (rendering, LSP, formatting)
    { import = "lazyvim.plugins.extras.lang.markdown" },

    -- Test runner (neotest core — adapters configured in lua/plugins/testing.lua)
    { import = "lazyvim.plugins.extras.test.core" },

    -- Code outline panel (aerial)
    { import = "lazyvim.plugins.extras.editor.aerial" },

    -- Live rename preview
    { import = "lazyvim.plugins.extras.editor.inc-rename" },

    -- Use fzf-lua as the LazyVim picker (replaces snacks.picker for built-in keymaps)
    { import = "lazyvim.plugins.extras.editor.fzf" },

    -- Your personal tweaks (lua/plugins/)
    { import = "plugins" },

    -- Disable LazyVim defaults we don't want
    { "folke/flash.nvim",      enabled = false }, -- not used; keep nav simple
    { "MagicDuck/grug-far.nvim", enabled = false }, -- using spectre instead (<leader>sr)
  },
  defaults = { lazy = false, version = false },
  install = { colorscheme = { "catppuccin", "tokyonight", "rose-pine", "kanagawa" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
