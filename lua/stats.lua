-- Floating window for WakaTime coding stats + notification history.
-- Opens with <leader>ws (stats) or <leader>wh (notification history).

local wakatime = require("wakatime")

local M = {}

local function build_stats_lines()
  local stats = wakatime.get_cached()

  local lines = {}
  local function add(s) lines[#lines + 1] = s end

  add("")
  add("  ┌─────────────────────────────────────────┐")
  add("  │           WakaTime Coding Stats          │")
  add("  └─────────────────────────────────────────┘")
  add("")

  if not stats then
    add("  Status:  No cached data")
    add("")
    local key = wakatime.get_api_key()
    if key then
      add("  API Key: " .. key:sub(1, 10) .. "...")
    else
      add("  API Key: NOT FOUND")
      add("  Add to ~/.wakatime.cfg:")
      add("    api_key=your_key_here")
    end
    add("")
    add("  Press <leader>wS to fetch from WakaTime")
    add("  Get key: wakatime.com/settings/api-key")
    add("")
    add("  Close:  q / <Esc>")
    add("")
    return lines
  end

  add("  User:      " .. (stats.user or "Unknown"))
  add("  Date:      " .. (stats.date or os.date("%a, %b %d")))
  add("  Project:   " .. (stats.project or "—"))
  add("")

  -- Total time
  local time_str = wakatime.format_time(stats.total)
  if stats.total > 0 then
    add("  ┌─── Today ──────────────────────────────┐")
    add("  │  Total:  " .. time_str .. string.rep(" ", 30 - #time_str) .. "│")
    add("  └────────────────────────────────────────┘")
  else
    add("  ┌─── Today ──────────────────────────────┐")
    add("  │  Total:  0m (no coding data for today) │")
    add("  └────────────────────────────────────────┘")
  end
  add("")

  -- Language breakdown
  if stats.languages and #stats.languages > 0 then
    add("  ┌─── Languages ──────────────────────────┐")
    local max_secs = stats.languages[1].seconds
    for i, lang in ipairs(stats.languages) do
      if i > 8 then break end
      local ts = wakatime.format_time(lang.seconds)
      local bar = wakatime.format_bar(lang.seconds, max_secs)
      local name = lang.name
      if #name > 12 then name = name:sub(1, 11) .. "~" end
      local pad = 38 - #name - #ts - #bar - 5
      if pad < 0 then pad = 0 end
      add("  │  " .. name .. string.rep(" ", 13 - #name) .. bar .. "  " .. ts .. string.rep(" ", pad) .. "│")
    end
    add("  └────────────────────────────────────────┘")
    add("")
  else
    add("  Languages:  none recorded today")
    add("")
  end

  -- Project breakdown
  if stats.projects and #stats.projects > 0 then
    add("  ┌─── Projects ───────────────────────────┐")
    local max_secs = stats.projects[1].seconds
    for i, proj in ipairs(stats.projects) do
      if i > 8 then break end
      local ts = wakatime.format_time(proj.seconds)
      local bar = wakatime.format_bar(proj.seconds, max_secs)
      local name = proj.name
      if #name > 12 then name = name:sub(1, 11) .. "~" end
      local pad = 38 - #name - #ts - #bar - 5
      if pad < 0 then pad = 0 end
      add("  │  " .. name .. string.rep(" ", 13 - #name) .. bar .. "  " .. ts .. string.rep(" ", pad) .. "│")
    end
    add("  └────────────────────────────────────────┘")
    add("")
  else
    add("  Projects:   none recorded today")
    add("")
  end

  -- Cache info
  if stats._cached_at then
    local age = os.time() - stats._cached_at
    local age_str = age < 60 and "just now" or (math.floor(age / 60) .. "m ago")
    add("  Cached: " .. age_str)
  end
  add("")
  add("  Refresh:  <leader>wS")
  add("  Close:    q / <Esc>")
  add("")
  return lines
end

local function build_history_lines()
  local ok, history = pcall(function()
    return vim.fn.execute("messages")
  end)
  if not ok or not history or history == "" then
    return { "", "  No messages or notifications recorded.", "" }
  end
  local lines = {}
  lines[#lines + 1] = ""
  lines[#lines + 1] = "  ┌─────────────────────────────────────────┐"
  lines[#lines + 1] = "  │        Message / Notification History    │"
  lines[#lines + 1] = "  └─────────────────────────────────────────┘"
  lines[#lines + 1] = ""
  for line in history:gmatch("[^\n]+") do
    lines[#lines + 1] = "  " .. line
  end
  lines[#lines + 1] = ""
  lines[#lines + 1] = "  Close:  q / <Esc>"
  lines[#lines + 1] = ""
  return lines
end

--- Open a centered floating buffer with the given lines
local function open_float(lines, title)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].modifiable = false

  -- Calculate width from longest line
  local width = 46
  for _, line in ipairs(lines) do
    if #line + 2 > width then width = math.min(#line + 2, 60) end
  end
  local height = math.min(#lines, vim.o.lines - 4)
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
    title = title,
    title_pos = "center",
  })

  vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end,
    { buffer = buf, silent = true, desc = "Close" })
  vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win, true) end,
    { buffer = buf, silent = true, desc = "Close" })
end

function M.open_stats()
  open_float(build_stats_lines(), " WakaTime ")
end

function M.open_history()
  open_float(build_history_lines(), " Messages ")
end

return M
