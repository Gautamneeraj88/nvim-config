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
