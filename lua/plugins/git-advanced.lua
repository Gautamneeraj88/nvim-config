return {
  -- ─── Octo — GitHub PRs and Issues inside Neovim ──────────────────────────────
  -- Browse, review, and merge PRs without leaving the editor
  -- Requires: gh CLI installed and authenticated (`gh auth login`)
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enable_builtin = true,
    },
    keys = {
      { "<leader>gop", "<cmd>Octo pr list<cr>",      desc = "List PRs" },
      { "<leader>goi", "<cmd>Octo issue list<cr>",   desc = "List Issues" },
      { "<leader>gor", "<cmd>Octo review start<cr>", desc = "Start PR Review" },
      { "<leader>gom", "<cmd>Octo pr merge<cr>",     desc = "Merge PR" },
    },
  },

  -- ─── Diffview — side-by-side diffs, file history, merge conflicts ────────────
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    opts = {
      enhanced_diff_hl = true, -- better diff highlighting
      view = {
        default = {
          layout = "diff2_horizontal", -- side-by-side view
        },
        merge_tool = {
          layout = "diff3_mixed", -- 3-way merge: OURS | RESULT | THEIRS
          disable_diagnostics = true,
        },
      },
    },
    keys = {
      { "<leader>gd",  "<cmd>DiffviewOpen<cr>",                desc = "Diff View (all changes)" },
      { "<leader>gD",  "<cmd>DiffviewOpen HEAD~1<cr>",         desc = "Diff vs last commit" },
      { "<leader>gdm", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diff branch vs origin/main" },
      { "<leader>gdM", "<cmd>DiffviewOpen main...HEAD<cr>",        desc = "Diff branch vs local main" },
      { "<leader>gfh", "<cmd>DiffviewFileHistory %<cr>",       desc = "File history (current)" },
      { "<leader>gFH", "<cmd>DiffviewFileHistory<cr>",         desc = "File history (project)" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>",               desc = "Close Diff View" },
    },
  },

  -- ─── Git Conflict — highlight & resolve merge conflicts ──────────────────────
  -- co  → choose OURS   (current branch)   ct  → choose THEIRS (incoming)
  -- cb  → choose BOTH   (keep both)        c0  → choose NONE   (delete block)
  -- ]x  → next conflict                    [x  → previous conflict
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPost",
    opts = {
      disable_diagnostics = true, -- LSP errors on conflict markers are noise
      list_opener         = "copen",
    },
    keys = {
      { "<leader>gx", "<cmd>GitConflictListQf<cr>", desc = "List all conflicts (quickfix)" },
    },
  },

  -- ─── Lazygit — full git TUI in a floating window ────────────────────────────
  -- <leader>gg  → lazygit rooted at project root (git top-level)
  -- <leader>gG  → lazygit rooted at cwd (useful in monorepos)
  -- Both open in a centered floating window (85% x 90% of screen).
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>gg",
        function()
          Snacks.lazygit({ cwd = LazyVim.root.git(), win = {
            width = 0.85, height = 0.9,
            position = "float",
          } })
        end,
        desc = "Lazygit (Root Dir)",
      },
      {
        "<leader>gG",
        function()
          Snacks.lazygit({ win = {
            width = 0.85, height = 0.9,
            position = "float",
          } })
        end,
        desc = "Lazygit (cwd)",
      },
    },
  },

  -- ─── CI/CD — GitHub Actions in a floating window ────────────────────────────
  -- <leader>ga  → open CI/CD pipeline browser (float)
  -- <leader>gA  → open Actions workflow file (if in .github/workflows/)
  -- Requires: gh CLI authenticated (`gh auth login`)
  {
    "D3xter87/cicd.nvim",
    init = function()
      if not vim.env.GITHUB_TOKEN then
        local token = vim.fn.system("gh auth token 2>/dev/null"):gsub("%s+", "")
        if token ~= "" then vim.env.GITHUB_TOKEN = token end
      end
      vim.api.nvim_create_user_command("Cicd", function()
        require("cicd").open_pipeline_browser()
      end, { desc = "CI/CD Pipeline Browser" })
      vim.api.nvim_create_user_command("Actions", function()
        require("cicd").open_pipeline_browser()
      end, { desc = "GitHub Actions" })
    end,
    config = function(_, opts)
      require("cicd").setup(opts)

      -- Patch logview to render ANSI colors instead of stripping them
      local ansi = require("ansi")
      local logview = require("cicd.ui.logview")

      ansi.setup_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function() ansi.setup_highlights() end,
      })

      local orig_set_body = logview.set_body
      function logview.set_body(view, body)
        if not view or not view.buf then return end
        local lines, extmarks = ansi.parse(body)
        if #lines == 0 or (#lines == 1 and lines[1] == "") then
          lines = { "", "  (logs not available yet — job may still be queued)" }
        end

        local follow = true
        local cur
        if view.loaded and view.win and vim.api.nvim_win_is_valid(view.win) then
          local total = vim.api.nvim_buf_line_count(view.buf)
          local ok, pos = pcall(vim.api.nvim_win_get_cursor, view.win)
          if ok then
            cur = pos
            follow = pos[1] >= total
          end
        end

        vim.api.nvim_set_option_value("modifiable", true, { buf = view.buf })
        vim.api.nvim_buf_set_lines(view.buf, 0, -1, false, lines)
        vim.api.nvim_set_option_value("modifiable", false, { buf = view.buf })

        local ns = vim.api.nvim_create_namespace("cicd_ansi")
        vim.api.nvim_buf_clear_namespace(view.buf, ns, 0, -1)
        for _, em in ipairs(extmarks) do
          pcall(vim.api.nvim_buf_set_extmark, view.buf, ns, em[1], em[2], {
            end_col = em[3],
            hl_group = em[4],
          })
        end

        view.loaded = true
        if view.win and vim.api.nvim_win_is_valid(view.win) then
          local count = vim.api.nvim_buf_line_count(view.buf)
          if follow then
            pcall(vim.api.nvim_win_set_cursor, view.win, { count, 0 })
          elseif cur then
            pcall(vim.api.nvim_win_set_cursor, view.win, { math.min(cur[1], count), cur[2] })
          end
        end
      end

      -- Patch HTTP client to pcall callbacks — prevents nil-ctx crash in async vim.schedule
      local client = require("cicd.http.client")
      local orig_request = client.request
      function client.request(opts, cb)
        return orig_request(opts, function(result)
          local ok, err = pcall(cb, result)
          if not ok then
            -- Swallow "index upvalue 'ctx'" — happens when browser closes mid-request
            if not err or not err:match("'ctx'") then
              vim.notify("cicd: " .. tostring(err), vim.log.levels.WARN)
            end
          end
        end)
      end

      -- Start background CI/CD status notifications
      require("cicd_notify").start()
    end,
    opts = {
      intervals = {
        auto_refresh = 10000,
        min = 5000,
      },
    },
    keys = {
      { "<leader>ga", function() require("cicd").open_pipeline_browser() end, desc = "CI/CD Pipelines (float)" },
      { "<leader>gA", function() require("cicd").open_pipeline_browser() end, desc = "GitHub Actions (float)" },
    },
  },
}
