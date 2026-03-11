-- Auto-save: saves automatically so you never lose work
-- Saves when you: leave insert mode, switch buffers, or lose focus
return {
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" }, -- save instantly when leaving
        defer_save     = { "InsertLeave", "TextChanged" }, -- save after short delay
        cancel_deferred_save = { "InsertEnter" }, -- cancel if you start typing again
      },
      write_all_buffers = false, -- only save the current buffer
      noautocmd = false,
      lockmarks = false,
      debounce_delay = 1500, -- wait 1.5s after last keystroke before saving

      -- Don't auto-save these file types
      condition = function(buf)
        local excluded_filetypes = { "oil", "neo-tree", "lazy", "mason", "TelescopePrompt" }
        local ft = vim.bo[buf].filetype
        if vim.tbl_contains(excluded_filetypes, ft) then return false end
        if not vim.bo[buf].modifiable then return false end
        return true
      end,
    },
  },
}
