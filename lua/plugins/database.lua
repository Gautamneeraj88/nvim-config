-- ─── Database — in-editor SQL client (vim-dadbod) ────────────────────────────
-- Replaces a standalone DB GUI: browse schemas, run queries, see results inline.
-- Open the drawer with <leader>Du, pick/add a connection, write SQL in a .sql
-- buffer, run with <leader>S (dadbod-ui's buffer-local map) or `:%DB`.
-- Connections persist via :DBUIAddConnection (stored under stdpath/data/db_ui).
--
-- Connection URLs (set per-project as an env var or add via DBUIAddConnection):
--   postgres://user:pass@localhost:5432/dbname
--   mysql://user:pass@localhost:3306/dbname
--   sqlite:/absolute/path/to/file.db
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      vim.g.db_ui_use_nerd_fonts        = 1
      vim.g.db_ui_show_database_icon    = 1
      vim.g.db_ui_win_position          = "left"
      vim.g.db_ui_winwidth              = 40
      vim.g.db_ui_execute_on_save       = 0  -- don't auto-run on :w; run explicitly
      vim.g.db_ui_use_nvim_notify       = 1
    end,
    keys = {
      { "<leader>Du", "<cmd>DBUIToggle<cr>",        desc = "Toggle DB UI" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>",    desc = "Find DB buffer" },
      { "<leader>DB", "<cmd>DBUIAddConnection<cr>", desc = "Add DB connection" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>",  desc = "Rename DB buffer" },
    },
  },

  -- SQL completion (tables, columns, keywords) wired into blink.cmp for sql buffers.
  -- vim-dadbod-completion ships a native blink source at vim_dadbod_completion.blink,
  -- so no blink.compat shim is needed.
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          sql   = { "dadbod", "snippets", "buffer" },
          mysql = { "dadbod", "snippets", "buffer" },
          plsql = { "dadbod", "snippets", "buffer" },
        },
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
    },
  },
}
