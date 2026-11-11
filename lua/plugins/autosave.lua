-- Auto-save: saves automatically so you never lose work
-- Saves when you: leave insert mode, switch buffers, or lose focus
--
-- Agent-safe: if another program (Claude Code, a formatter, git checkout) wrote
-- the file after this buffer last read/wrote it, autosave pauses for that buffer
-- instead of silently overwriting the newer version on disk.

-- Disk mtime as one comparable number (sec + nsec), or nil for unsaved files.
local function disk_mtime(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then return nil end
  local stat = vim.uv.fs_stat(name)
  return stat and (stat.mtime.sec + stat.mtime.nsec / 1e9) or nil
end

-- Remember the mtime we last saw for each buffer — after reading, writing,
-- or reloading (FileChangedShellPost fires when checktime reloads a buffer).
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "FileChangedShellPost" }, {
  group = vim.api.nvim_create_augroup("autosave_mtime", { clear = true }),
  callback = function(ev)
    -- FileChangedShellPost also fires when you chose to KEEP your edits at the
    -- "file changed" prompt — the buffer is still modified then, so don't
    -- adopt the new mtime (that would let autosave overwrite the disk version).
    if ev.event == "FileChangedShellPost" and vim.bo[ev.buf].modified then return end
    vim.b[ev.buf].autosave_mtime = disk_mtime(ev.buf)
    vim.b[ev.buf].autosave_warned = nil
  end,
})

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

        -- File changed on disk since we last saw it → don't clobber it
        local seen, now = vim.b[buf].autosave_mtime, disk_mtime(buf)
        if seen and now and now > seen then
          if not vim.b[buf].autosave_warned then
            vim.b[buf].autosave_warned = true
            vim.notify(
              vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
                .. " changed on disk — autosave paused.\n:e! to load it, :w! to keep yours.",
              vim.log.levels.WARN
            )
          end
          return false
        end
        return true
      end,
    },
  },
}
