-- Floating window for detailed WakaTime coding stats.
-- Opens with <leader>ws — shows language breakdown, project breakdown,
-- daily coding history, and total coding time.

local M = {}

local function build_lines()
  local stats = require("plugins.coding-stats").get_cached()
  if not stats then
    return {
      "",
      "  No WakaTime stats available.",
      "",
      "  Press <leader>wS to fetch stats",
      "  (requires ~/.wakatime.cfg with api_key)",
      "",
    }
  end

  local lines = {}
  local function add(s) lines[#lines + 1] = s end

  add("")
  add("  ┌─────────────────────────────────────────┐")
  add("  │           WakaTime Coding Stats          │")
  add("  └─────────────────────────────────────────┘")
  add("")

  -- User info
  add("  User:          " .. (stats.user or "Unknown"))
  add("  Date:          " .. (stats.date or os.date("%a, %b %d")))
  add("  Current:       " .. (stats.project or "—"))
  add("")

  -- Today's total
  add("  ┌─── Today ──────────────────────────────┐")
  add("  │  Total:      " .. require("plugins.coding-stats").format_time(stats.total) .. string.rep(" ", 28 - #require("plugins.coding-stats").format_time(stats.total)) .. "│")
  add("  └────────────────────────────────────────┘")
  add("")

  -- Language breakdown
  if #stats.languages > 0 then
    add("  ┌─── Languages ──────────────────────────┐")
    local max_secs = stats.languages[1] and stats.languages[1].seconds or 1
    for i, lang in ipairs(stats.languages) do
      if i > 8 then break end
      local time_str = require("plugins.coding-stats").format_time(lang.seconds)
      local bar = require("plugins.coding-stats").format_bar(lang.seconds, max_secs)
      local padding = 38 - #lang.name - #time_str - #bar - 5
      if padding < 0 then padding = 0 end
      add("  │  " .. lang.name .. string.rep(" ", 14 - #lang.name) .. bar .. "  " .. time_str .. string.rep(" ", padding) .. "│")
    end
    add("  └────────────────────────────────────────┘")
    add("")
  end

  -- Project breakdown
  if #stats.projects > 0 then
    add("  ┌─── Projects ───────────────────────────┐")
    local max_secs = stats.projects[1] and stats.projects[1].seconds or 1
    for i, proj in ipairs(stats.projects) do
      if i > 8 then break end
      local time_str = require("plugins.coding-stats").format_time(proj.seconds)
      local bar = require("plugins.coding-stats").format_bar(proj.seconds, max_secs)
      local padding = 38 - #proj.name - #time_str - #bar - 5
      if padding < 0 then padding = 0 end
      add("  │  " .. proj.name .. string.rep(" ", 14 - #proj.name) .. bar .. "  " .. time_str .. string.rep(" ", padding) .. "│")
    end
    add("  └────────────────────────────────────────┘")
    add("")
  end

  -- Tips
  add("  Refresh:  <leader>wS")
  add("  Close:    q / <Esc>")
  add("")

  return lines
end

function M.open()
  local lines = build_lines()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].modifiable = false

  local width = 48
  local height = #lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " WakaTime ",
    title_pos = "center",
  })

  -- Close on q or Esc
  vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end,
    { buffer = buf, silent = true, desc = "Close stats" })
  vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win, true) end,
    { buffer = buf, silent = true, desc = "Close stats" })
end

return M
