-- Undotree — visual timeline of your entire edit history
-- Neovim tracks every change you make, even across sessions (undofile = true).
-- Undotree shows this as a tree so you can go back to ANY past state,
-- not just linear undo (which loses branches when you edit after undoing).
return {
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undo Tree" },
    },
    config = function()
      vim.g.undotree_WindowLayout       = 2     -- tree on left, diff on bottom
      vim.g.undotree_SplitWidth         = 35
      vim.g.undotree_DiffpanelHeight    = 12
      vim.g.undotree_SetFocusWhenToggle = 1     -- auto-focus tree when opened
      vim.g.undotree_ShortIndicators    = 1     -- compact timestamps
      vim.g.undotree_RelativeTimestamp  = 1     -- show "2 mins ago" style
    end,
  },
}
