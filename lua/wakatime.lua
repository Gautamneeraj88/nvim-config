-- WakaTime API integration — fetches coding stats, caches to disk, provides
-- data for the dashboard and floating stats window.
--
-- Requires ~/.wakatime.cfg with a valid api_key.
-- Stats are cached for 10 minutes to avoid hitting the API on every dashboard load.

local M = {}

local CACHE_DIR = vim.fn.stdpath("data") .. "/wakatime"
local CACHE_FILE = CACHE_DIR .. "/stats.json"
local CACHE_TTL = 600 -- 10 minutes

--- Read API key from ~/.wakatime.cfg
function M.get_api_key()
  local cfg = io.open(vim.fn.expand("~/.wakatime.cfg"), "r")
  if not cfg then return nil end
  local content = cfg:read("*a")
  cfg:close()
  local key = content:match("api_key%s*=%s*(.+)")
  return key and key:match("^%s*(.-)%s*$") or nil
end

--- Read cached stats from disk
function M.get_cached()
  local f = io.open(CACHE_FILE, "r")
  if not f then return nil end
  local content = f:read("*a")
  f:close()
  local ok, data = pcall(vim.json.decode, content)
  if not ok then return nil end
  if os.time() - (data._cached_at or 0) > CACHE_TTL then return nil end
  return data
end

--- Write stats to cache file
function M.save_cache(data)
  data._cached_at = os.time()
  vim.fn.mkdir(CACHE_DIR, "p")
  local f = io.open(CACHE_FILE, "w")
  if f then
    f:write(vim.json.encode(data))
    f:close()
  end
end

--- Async HTTP GET via curl (non-blocking)
---@param url string
---@param callback fun(body: string|nil)
function M.http_get(url, callback)
  local api_key = M.get_api_key()
  if not api_key then callback(nil) return end
  vim.fn.jobstart({
    "curl", "-s", "-u", api_key .. ":",
    "--max-time", "10", url,
  }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        callback(table.concat(data))
      else
        callback(nil)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then callback(nil) end
    end,
  })
end

--- Format seconds into human-readable string (e.g. "2h 34m", "45m", "1h 12s")
function M.format_time(seconds)
  if not seconds or seconds <= 0 then return "0m" end
  local h = math.floor(seconds / 3600)
  local m = math.floor((seconds % 3600) / 60)
  if h > 0 then
    return string.format("%dh %dm", h, m)
  elseif m > 0 then
    return string.format("%dm", m)
  else
    return string.format("%ds", math.floor(seconds))
  end
end

--- Format seconds into bar chart (e.g. "████░░")
function M.format_bar(seconds, max_seconds)
  if not seconds or seconds <= 0 then return "░░░░░░" end
  local width = 6
  local filled = max_seconds > 0 and math.floor((seconds / max_seconds) * width) or 0
  filled = math.max(1, math.min(filled, width))
  return string.rep("█", filled) .. string.rep("░", width - filled)
end

--- Build stats object from WakaTime API responses
function M.build_stats(user_data, summary_data)
  local total_seconds = 0
  local languages = {}
  local projects = {}

  if summary_data and summary_data.data then
    for _, day in ipairs(summary_data.data) do
      if day.grand_total then
        total_seconds = total_seconds + (day.grand_total.total_seconds or 0)
      end
      if day.languages then
        for _, lang in ipairs(day.languages) do
          local name = lang.name or "Other"
          languages[name] = (languages[name] or 0) + (lang.total_seconds or 0)
        end
      end
      if day.projects then
        for _, proj in ipairs(day.projects) do
          local name = proj.name or "unknown"
          projects[name] = (projects[name] or 0) + (proj.total_seconds or 0)
        end
      end
    end
  end

  local sorted_langs = {}
  for name, secs in pairs(languages) do
    sorted_langs[#sorted_langs + 1] = { name = name, seconds = secs }
  end
  table.sort(sorted_langs, function(a, b) return a.seconds > b.seconds end)

  local sorted_projs = {}
  for name, secs in pairs(projects) do
    sorted_projs[#sorted_projs + 1] = { name = name, seconds = secs }
  end
  table.sort(sorted_projs, function(a, b) return a.seconds > b.seconds end)

  local cwd = vim.fn.getcwd()
  local project_name = vim.fn.fnamemodify(cwd, ":t")

  return {
    user = user_data and user_data.data and user_data.data.display_name or "Coder",
    date = os.date("%a, %b %d"),
    project = project_name,
    total = total_seconds,
    languages = sorted_langs,
    projects = sorted_projs,
  }
end

--- Fetch stats from WakaTime API (async, writes to cache on completion)
function M.fetch()
  local api_key = M.get_api_key()
  if not api_key then
    vim.notify("No API key in ~/.wakatime.cfg", vim.log.levels.ERROR)
    return
  end

  vim.notify("Fetching WakaTime stats...", vim.log.levels.INFO)

  M.http_get("https://wakatime.com/api/v1/users/current", function(user_body)
    if not user_body then
      vim.notify("WakaTime API unreachable — check your internet connection", vim.log.levels.ERROR)
      return
    end
    local user_ok, user_data = pcall(vim.json.decode, user_body)

    if not user_ok or (user_data and user_data.errors) then
      local err = user_data and user_data.errors and table.concat(user_data.errors, ", ") or "Invalid response"
      vim.notify("WakaTime auth failed: " .. err, vim.log.levels.ERROR)
      return
    end

    -- Correct endpoint: /api/v1/users/current/summaries (not /api/v1/summaries)
    M.http_get("https://wakatime.com/api/v1/users/current/summaries?start=" .. os.date("%Y-%m-01") .. "&end=" .. os.date("%Y-%m-%d"), function(summary_body)
      if not summary_body then
        vim.notify("WakaTime summaries API unreachable", vim.log.levels.ERROR)
        return
      end
      local sum_ok, summary_data = pcall(vim.json.decode, summary_body)

      if sum_ok and summary_data and not summary_data.errors then
        local stats = M.build_stats(user_data, summary_data)
        M.save_cache(stats)
        local time = M.format_time(stats.total)
        local langs = #stats.languages
        vim.notify("WakaTime updated — " .. time .. " coded, " .. langs .. " languages", vim.log.levels.INFO)
        pcall(function()
          require("stats").open_stats()
        end)
      else
        local err = summary_data and summary_data.errors and table.concat(summary_data.errors, ", ") or "Unknown error"
        vim.notify("WakaTime summaries failed: " .. err, vim.log.levels.ERROR)
      end
    end)
  end)
end

return M
