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

    -- Better UI (floating cmdline, notifications, search popup)
    { import = "lazyvim.plugins.extras.ui.noice" },

    -- Test runner (neotest core — adapters configured in lua/plugins/testing.lua)
    { import = "lazyvim.plugins.extras.test.core" },

    -- Your personal tweaks (lua/plugins/)
    { import = "plugins" },
  },
  defaults = { lazy = false, version = false },
  install = { colorscheme = { "catppuccin", "tokyonight" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
