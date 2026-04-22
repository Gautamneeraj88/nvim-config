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
}
