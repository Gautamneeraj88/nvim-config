-- Background CI/CD status monitor for Neovim.
-- Polls GitHub Actions and sends notifications on status changes.
local M = {}

local POLL_INTERVAL = 30000  -- 30 seconds
local timer = nil
local seen = {}  -- { ["owner/repo/run_id"] = status }

---Get the token for GitHub API
local function get_token()
  local token = vim.env.GITHUB_TOKEN
  if token and token ~= "" then return token end
  local out = vim.fn.system("gh auth token 2>/dev/null"):gsub("%s+", "")
  return out ~= "" and out or nil
end

---Get current repo as owner/repo
local function get_repo()
  local remote = vim.fn.system("git remote get-url origin 2>/dev/null"):gsub("%s+", "")
  if remote == "" then return nil end
  -- ssh: git@github.com:owner/repo.git  or  https://github.com/owner/repo.git
  local owner_repo = remote:match("github%.com[:/](.+)%.git$")
    or remote:match("github%.com[:/](.+)$")
  return owner_repo
end

---Fetch latest workflow runs for a repo
local function fetch_runs(repo, token, cb)
  local url = "https://api.github.com/repos/" .. repo .. "/actions/runs?per_page=5&status=completed"
  vim.system({
    "curl", "-s", "-H", "Authorization: token " .. token,
    "-H", "Accept: application/vnd.github+json",
    url,
  }, { text = true }, function(result)
    if result.code ~= 0 then return cb(nil, "curl failed") end
    local ok, data = pcall(vim.json.decode, result.stdout)
    if not ok or not data or not data.workflow_runs then return cb(nil, "parse error") end
    cb(data.workflow_runs)
  end)
end

---Check for status changes and notify
local function poll()
  local token = get_token()
  if not token then return end
  local repo = get_repo()
  if not repo then return end

  fetch_runs(repo, token, function(runs, err)
    if not runs then return end
    vim.schedule(function()
      for _, run in ipairs(runs) do
        local key = repo .. "/" .. tostring(run.id)
        local prev = seen[key]
        local status = run.conclusion or run.status
        if prev and prev ~= status then
          local icon = ({
            success = "\231\142\159",   -- 
            failure = "\231\145\169",   -- 
            cancelled = "\226\153\128", -- 
          })[status] or "\226\134\181"  -- 
          local msg = string.format("%s %s — %s (%s)",
            icon, run.name, status, run.head_branch or "")
          vim.notify(msg, status == "success" and vim.log.levels.INFO
            or status == "failure" and vim.log.levels.ERROR
            or vim.log.levels.WARN,
            { title = "GitHub Actions", timeout = 5000 })
        end
        seen[key] = status
      end
    end)
  end)
end

---Start background polling
function M.start()
  if timer then return end
  poll()  -- initial check
  timer = vim.fn.timer_start(POLL_INTERVAL, function()
    poll()
  end, { ["repeat"] = -1 })
end

---Stop background polling
function M.stop()
  if timer then
    vim.fn.timer_stop(timer)
    timer = nil
  end
end

return M
