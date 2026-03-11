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
      { "<leader>gd",  "<cmd>DiffviewOpen<cr>",                desc = "Diff View (all changes)" },
      { "<leader>gD",  "<cmd>DiffviewOpen HEAD~1<cr>",         desc = "Diff vs last commit" },
      { "<leader>gfh", "<cmd>DiffviewFileHistory %<cr>",       desc = "File history (current)" },
      { "<leader>gFH", "<cmd>DiffviewFileHistory<cr>",         desc = "File history (project)" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>",               desc = "Close Diff View" },
    },
  },

  -- ─── Git Conflict — highlight & resolve merge conflicts ──────────────────────
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    opts = {
      default_mappings = true,
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current  = "DiffText",
      },
    },
    -- When you open a file with merge conflicts, these keymaps activate:
    -- co  → choose OURS   (current branch)
    -- ct  → choose THEIRS (incoming branch)
    -- cb  → choose BOTH   (keep both changes)
    -- c0  → choose NONE   (delete the conflict block)
    -- ]x  → next conflict
    -- [x  → previous conflict
  },
}
