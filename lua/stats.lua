-- Floating window for WakaTime coding stats + notification history.
-- Opens with <leader>ws (stats) or <leader>wh (notification history).

local wakatime = require("wakatime")

local M = {}

local function build_stats_lines()
  local stats = wakatime.get_cached()
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
  add("  User:          " .. (stats.user or "Unknown"))
  add("  Date:          " .. (stats.date or os.date("%a, %b %d")))
  add("  Current:       " .. (stats.project or "—"))
  add("")

  add("  ┌─── Today ──────────────────────────────┐")
  local time_str = wakatime.format_time(stats.total)
  add("  │  Total:      " .. time_str .. string.rep(" ", 28 - #time_str) .. "│")
  add("  └────────────────────────────────────────┘")
  add("")

  if #stats.languages > 0 then
    add("  ┌─── Languages ──────────────────────────┐")
    local max_secs = stats.languages[1].seconds
    for i, lang in ipairs(stats.languages) do
      if i > 8 then break end
      local ts = wakatime.format_time(lang.seconds)
      local bar = wakatime.format_bar(lang.seconds, max_secs)
      local pad = 38 - #lang.name - #ts - #bar - 5
      if pad < 0 then pad = 0 end
      add("  │  " .. lang.name .. string.rep(" ", 14 - #lang.name) .. bar .. "  " .. ts .. string.rep(" ", pad) .. "│")
    end
    add("  └────────────────────────────────────────┘")
    add("")
  end

  if #stats.projects > 0 then
    add("  ┌─── Projects ───────────────────────────┐")
    local max_secs = stats.projects[1].seconds
    for i, proj in ipairs(stats.projects) do
      if i > 8 then break end
      local ts = wakatime.format_time(proj.seconds)
      local bar = wakatime.format_bar(proj.seconds, max_secs)
      local pad = 38 - #proj.name - #ts - #bar - 5
      if pad < 0 then pad = 0 end
      add("  │  " .. proj.name .. string.rep(" ", 14 - #proj.name) .. bar .. "  " .. ts .. string.rep(" ", pad) .. "│")
    end
    add("  └────────────────────────────────────────┘")
    add("")
  end

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

  local width = 50
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
