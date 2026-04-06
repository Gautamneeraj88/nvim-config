-- ── Defensive cwd patches ────────────────────────────────────────────────────
-- vim.uv.cwd() returns nil when libuv can't resolve the working directory
-- (deleted dir, certain macOS path edge cases). Every caller that does
-- assert(vim.uv.cwd()) then crashes — including vim/fs.lua, LazyVim root
-- detection, and lualine. Fix the root cause first, then wrap the higher-level
-- fs functions as a safety net.
do
  local uv = vim.uv

  -- 1. Patch uv.cwd itself: return HOME instead of nil on failure.
  --    This fixes LazyVim root.get(), lualine, and anything else that calls
  --    vim.uv.cwd() directly without going through vim.fs.*.
  local _orig_cwd = uv.cwd
  uv.cwd = function()
    local result = _orig_cwd()
    return result or os.getenv("HOME") or "/"
  end

  -- 2. Patch vim.fs.abspath — belt-and-suspenders.
  local _orig_abspath = vim.fs.abspath
  vim.fs.abspath = function(path)
    local ok, result = pcall(_orig_abspath, path)
    if ok then return result end
    if type(path) ~= "string" then return "" end
    if path:sub(1, 1) == "/" then return path end
    return (os.getenv("HOME") or "/") .. "/" .. path
  end

  -- 3. Patch vim.fs.find — belt-and-suspenders.
  local _orig_find = vim.fs.find
  vim.fs.find = function(names, opts)
    local ok, result = pcall(_orig_find, names, opts)
    if ok then return result end
    return {}
  end
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
