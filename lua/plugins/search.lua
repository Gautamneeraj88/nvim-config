-- fzf-lua: fast fuzzy search powered by fzf
-- LazyVim's fzf extra (imported in lazy.lua) already handles the standard keymaps
-- (<leader>ff, <leader>fr, <leader>fb, <leader>/, <leader>ss, gr, etc.)
-- This file only configures appearance and adds keymaps the extra doesn't provide.
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
      -- Grep word under cursor / visual selection (LazyVim uses <leader>sw/<leader>sW)
      { "<leader>fw", "<cmd>FzfLua grep_cword<cr>",              desc = "Search Word Under Cursor" },
      { "<leader>fs", "<cmd>FzfLua grep_visual<cr>", mode = "v", desc = "Search Selection" },

      -- Git branches (not in LazyVim fzf extra)
      { "<leader>gB", "<cmd>FzfLua git_branches<cr>",            desc = "Git Branches" },

      -- TODOs / FIXMEs across the project (todo-comments integration)
      { "<leader>ft", function() require("todo-comments.fzf").todo() end, desc = "Search TODOs" },

      -- Switch colorscheme (LazyVim uses <leader>uC; keep <leader>uT as alias)
      { "<leader>uT", "<cmd>FzfLua colorschemes<cr>",            desc = "Switch Theme" },
    },
  },
}
