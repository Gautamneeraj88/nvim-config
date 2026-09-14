return {
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
      { "<leader>gd",  "<cmd>DiffviewOpen<cr>", desc = "Diff View (all changes)" },
      { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diff View Open" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Close Diff View" },
      { "<leader>gdd", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff vs last commit" },
      {
        "<leader>gdm",
        function()
          local branch = vim.fn.system("git rev-parse --verify origin/main 2>/dev/null")
          local name = vim.v.shell_error == 0 and "main" or "master"
          vim.cmd("DiffviewOpen origin/" .. name .. "...HEAD")
        end,
        desc = "Diff branch vs origin/main(master)",
      },
      {
        "<leader>gdM",
        function()
          local branch = vim.fn.system("git rev-parse --verify main 2>/dev/null")
          local name = vim.v.shell_error == 0 and "main" or "master"
          vim.cmd("DiffviewOpen " .. name .. "...HEAD")
        end,
        desc = "Diff branch vs local main(master)",
      },
      { "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current)" },
      { "<leader>gdH", "<cmd>DiffviewFileHistory<cr>",   desc = "File history (project)" },
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
}
