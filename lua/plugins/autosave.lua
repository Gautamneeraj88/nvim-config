-- Auto-save: saves automatically so you never lose work
-- Saves when you: leave insert mode, switch buffers, or lose focus
return {
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "BufLeave", "FocusLost" },
    opts = {
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" }, -- save instantly when leaving
        defer_save     = { "InsertLeave" },            -- save after short delay
        cancel_deferred_save = { "InsertEnter" }, -- cancel if you start typing again
      },
      lockmarks = true, -- preserve marks when autosave fires
      debounce_delay = 1500, -- wait 1.5s after last keystroke before saving

      -- Don't auto-save these file types
      condition = function(buf)
        if vim.bo[buf].buftype ~= "" then return false end          -- skip special buffers (terminal, prompt, etc.)
        if not vim.bo[buf].modifiable then return false end          -- skip read-only buffers
        local excluded_filetypes = { "oil", "neo-tree", "lazy", "mason", "gitcommit", "gitrebase", "dap-repl" }
        if vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype) then return false end
        return true
      end,
    },
  },
}
