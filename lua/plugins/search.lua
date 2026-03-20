-- fzf-lua: fast fuzzy search powered by fzf
-- This replaces telescope with a faster, fzf-based picker
return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    opts = {
      winopts = {
        height = 0.85,
        width = 0.85,
        row = 0.35,
        col = 0.50,
        border = "rounded",
        preview = {
          border = "border",
          wrap = "nowrap",
          hidden = "nohidden",
          vertical = "down:45%",
          horizontal = "right:50%",
          layout = "flex",
          flip_columns = 120,
        },
      },
      keymap = {
        builtin = {
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
      },
      fzf_opts = {
        ["--prompt"] = "  ",
        ["--info"] = "inline",
        ["--layout"] = "reverse",
      },
    },
    keys = {
      -- File search
      { "<leader>ff", "<cmd>FzfLua files<cr>",                   desc = "Find Files (fzf)" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>",                desc = "Recent Files" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>",                 desc = "Open Buffers" },

      -- Search in files
      { "<leader>/",  "<cmd>FzfLua live_grep<cr>",               desc = "Live Grep" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<cr>",              desc = "Search Word Under Cursor" },
      { "<leader>fs", "<cmd>FzfLua grep_visual<cr>",   mode = "v", desc = "Search Selection" },

      -- LSP
      { "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>",    desc = "Document Symbols" },
      { "<leader>sS", "<cmd>FzfLua lsp_workspace_symbols<cr>",   desc = "Workspace Symbols" },
      { "gr",         "<cmd>FzfLua lsp_references<cr>",          desc = "LSP References" },

      -- Git
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>",             desc = "Git Commits" },
      { "<leader>gB", "<cmd>FzfLua git_branches<cr>",            desc = "Git Branches" },

      -- TODOs / FIXMEs across the project
      { "<leader>ft", function() require("todo-comments.fzf").todo() end, desc = "Search TODOs" },

      -- Misc
      { "<leader>:",  "<cmd>FzfLua command_history<cr>",         desc = "Command History" },
      { "<leader>sk", "<cmd>FzfLua keymaps<cr>",                 desc = "Search Keymaps" },
      { "<leader>uT", "<cmd>FzfLua colorschemes<cr>",            desc = "Switch Theme" },
    },
  },
}
