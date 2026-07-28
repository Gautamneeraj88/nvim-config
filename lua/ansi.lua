-- ANSI escape code parser for Neovim buffers.
-- Converts ANSI CSI sequences to extmark highlights so logs render with color.
local M = {}

-- Map ANSI SGR codes to Neovim highlight groups
local sgr_to_hl = {
  [0]  = nil,         -- reset (handled specially)
  [1]  = "Bold",
  [2]  = "Dim",
  [3]  = "Italic",
  [4]  = "Underline",
  [7]  = "Reverse",
  [9]  = "Strikethrough",
  [30] = "AnsiBlack",  [31] = "AnsiRed",    [32] = "AnsiGreen",
  [33] = "AnsiYellow", [34] = "AnsiBlue",   [35] = "AnsiMagenta",
  [36] = "AnsiCyan",   [37] = "AnsiWhite",
  [90] = "AnsiBlack",  [91] = "AnsiRed",    [92] = "AnsiGreen",
  [93] = "AnsiYellow", [94] = "AnsiBlue",   [95] = "AnsiMagenta",
  [96] = "AnsiCyan",   [97] = "AnsiWhite",
  [40] = "AnsiBlackBg",  [41] = "AnsiRedBg",    [42] = "AnsiGreenBg",
  [43] = "AnsiYellowBg", [44] = "AnsiBlueBg",   [45] = "AnsiMagentaBg",
  [46] = "AnsiCyanBg",   [47] = "AnsiWhiteBg",
  [100] = "AnsiBlackBg",  [101] = "AnsiRedBg",    [102] = "AnsiGreenBg",
  [103] = "AnsiYellowBg", [104] = "AnsiBlueBg",   [105] = "AnsiMagentaBg",
  [106] = "AnsiCyanBg",   [107] = "AnsiWhiteBg",
}

local function color256_to_hl(n, bg)
  local suffix = bg and "Bg" or ""
  local names = { "Black", "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White" }
  if n < 8 then return "Ansi" .. names[n + 1] .. suffix end
  if n < 16 then return "Ansi" .. names[n - 7] .. suffix end
  if n < 232 then
    local idx = n - 16
    local r = math.floor(idx / 36)
    local g = math.floor((idx % 36) / 6)
    local b = idx % 6
    local function c(v) return v == 0 and 0 or v >= 4 and 1 or (v >= 2 and 1 or 0) end
    local ci = c(r) * 4 + c(g) * 2 + c(b)
    return "Ansi" .. (names[ci + 1] or "White") .. suffix
  end
  return "Ansi" .. (n > 243 and "White" or "Black") .. suffix
end

local function parse_sgr(params)
  local hl = {}
  local i = 1
  while i <= #params do
    local code = params[i]
    if code == 0 then
      hl = {}
    elseif code == 38 then
      if params[i + 1] == 5 and params[i + 2] then
        hl[#hl + 1] = color256_to_hl(params[i + 2], false)
        i = i + 2
      elseif params[i + 1] == 2 and params[i + 4] then
        i = i + 4
      end
    elseif code == 48 then
      if params[i + 1] == 5 and params[i + 2] then
        hl[#hl + 1] = color256_to_hl(params[i + 2], true)
        i = i + 2
      elseif params[i + 1] == 2 and params[i + 4] then
        i = i + 4
      end
    else
      local mapped = sgr_to_hl[code]
      if mapped then hl[#hl + 1] = mapped end
    end
    i = i + 1
  end
  return hl
end

---Parse raw text with ANSI escapes into lines + highlight extmarks.
---@param body string raw log text
---@return string[] lines plain text lines
---@return table[] extmarks { line, col_start, col_end, hl_group }
function M.parse(body)
  body = body or ""
  body = body:gsub("\27[@-Z\\-_]", "")
  body = body:gsub("section_[%a]+:%d+:[%w_%-%.]+\r?", "")
  body = body:gsub("\r\n", "\n"):gsub("\r", "")

  local lines = {}
  local extmarks = {}
  local active_hl = {}
  local line = ""
  local col = 0
  local line_idx = 0  -- 0-indexed current line

  local function close_open_extmarks(end_col)
    for ei = #extmarks, 1, -1 do
      local em = extmarks[ei]
      if em[4] and em[1] == line_idx and em[3] == -1 then
        em[3] = end_col
      end
    end
  end

  local function start_hl_extmarks(from_col)
    for _, hl in ipairs(active_hl) do
      if hl then
        extmarks[#extmarks + 1] = { line_idx, from_col, -1, hl }
      end
    end
  end

  local i = 1
  while i <= #body do
    local ch = body:sub(i, i)
    if ch == "\27" and body:sub(i + 1, i + 1) == "[" then
      -- CSI sequence
      local params_str = ""
      local j = i + 2
      while j <= #body do
        local c = body:byte(j)
        if c >= 0x30 and c <= 0x3F then
          params_str = params_str .. body:sub(j, j)
          j = j + 1
        elseif c >= 0x40 and c <= 0x7E then
          if body:sub(j, j) == "m" then
            local params = {}
            for p in params_str:gmatch("[^;]*") do
              if p ~= "" then params[#params + 1] = tonumber(p) or 0 end
            end
            if #params == 0 then params = { 0 } end
            -- Close open extmarks on reset
            if params[1] == 0 then close_open_extmarks(col) end
            active_hl = parse_sgr(params)
            start_hl_extmarks(col)
          end
          i = j + 1
          break
        else
          j = j + 1
        end
      end
      if j > #body then i = #body + 1 end
    elseif ch == "\n" then
      close_open_extmarks(col)
      lines[#lines + 1] = line
      line = ""
      col = 0
      line_idx = line_idx + 1
      i = i + 1
    else
      line = line .. ch
      col = col + 1
      i = i + 1
    end
  end

  if line ~= "" then
    close_open_extmarks(col)
    lines[#lines + 1] = line
  end

  local clean = {}
  for _, em in ipairs(extmarks) do
    if em[4] and em[2] < em[3] and em[1] < #lines then
      clean[#clean + 1] = em
    end
  end

  return lines, clean
end

---Define the ANSI highlight groups (call once on colorscheme change).
function M.setup_highlights()
  local colors = {
    Black   = "#4d4d4d", Red     = "#cd3131", Green   = "#0dbc79",
    Yellow  = "#e5e510", Blue    = "#2472c8", Magenta = "#bc3fbc",
    Cyan    = "#11a8cd", White   = "#e5e5e5",
  }

  for name, color in pairs(colors) do
    vim.api.nvim_set_hl(0, "Ansi" .. name,        { fg = color, bg = "NONE" })
    vim.api.nvim_set_hl(0, "Ansi" .. name .. "Bg", { fg = "NONE", bg = color })
  end

  vim.api.nvim_set_hl(0, "Bold",      { bold = true })
  vim.api.nvim_set_hl(0, "Dim",       { dim = true })
  vim.api.nvim_set_hl(0, "Italic",    { italic = true })
  vim.api.nvim_set_hl(0, "Underline", { underline = true })
  vim.api.nvim_set_hl(0, "Reverse",   { reverse = true })
end

return M
