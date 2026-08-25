-- fzf-lua: fast fuzzy search powered by fzf
-- LazyVim's fzf extra (imported in lazy.lua) already handles the standard keymaps
-- (<leader>ff, <leader>fr, <leader>fb, <leader>/, <leader>ss, gr, etc.)
-- This file only configures appearance and adds keymaps the extra doesn't provide.
return {

  -- ─── HlSearch Lens — [n/total] count shown inline next to each match ─────────
  -- While searching with / or *, shows [2/14] next to the current match.
  -- n/N/*/# all trigger the lens. The scrollbar also gains search-position markers.
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufReadPost",
    opts = {
      calm_down        = true,   -- clear lens when cursor moves away
      nearest_only     = true,   -- annotate only the nearest match (cleaner)
      nearest_float_when = "never", -- inline virt text, no floating window
    },
    config = function(_, opts)
      require("hlslens").setup(opts)

      -- wrap n/N/*/# so the lens updates after each jump
      local function set_lens_maps()
        local map = function(key, cmd)
          vim.keymap.set("n", key, cmd, { noremap = true, silent = true })
        end
        map("n",  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]])
        map("N",  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]])
        map("*",  [[*<Cmd>lua require('hlslens').start()<CR>]])
        map("#",  [[#<Cmd>lua require('hlslens').start()<CR>]])
        map("g*", [[g*<Cmd>lua require('hlslens').start()<CR>]])
        map("g#", [[g#<Cmd>lua require('hlslens').start()<CR>]])
      end

      -- These must be registered LAST or they are silently clobbered: LazyVim's
      -- own keymaps take n/N on VeryLazy, while this plugin loads earlier on
      -- BufReadPost. vim.schedule pushes us past every synchronous VeryLazy handler.
      if vim.v.vim_did_enter == 1 then
        vim.schedule(set_lens_maps)
      end
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function() vim.schedule(set_lens_maps) end,
      })
    end,
  },

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
          -- `true` inherits fzf-lua's own builtin maps (<F1> help, <F4> preview
          -- toggle, <S-Up>/<S-Down> preview paging). Without it this table
          -- REPLACES them and they are silently gone.
          true,
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          true,
          ["ctrl-j"] = "down", -- same hand position as the arrows
          ["ctrl-k"] = "up",
        },
      },
      fzf_opts = {
        ["--prompt"] = "  ",
        ["--info"] = "inline",
        ["--layout"] = "reverse",
        -- Wrap at both ends. Without it the arrows go dead once the selection
        -- sits on the first or last entry, which reads as "arrows don't work"
        -- in a 2-buffer list where you are already on the last one.
        ["--cycle"] = true,
      },
      buffers = {
        -- fzf-lua freezes the current buffer as a --header-lines=1 row whenever
        -- sort_lastused is on, so it is drawn but not selectable. With two
        -- buffers open that leaves exactly one reachable entry and the arrows
        -- look broken. Unfreeze it; MRU ordering is kept.
        fzf_opts = { ["--header-lines"] = false },
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


    },
  },
}
