-- ─── Neo-tree explorer helpers ───────────────────────────────────────────────
-- Defined at module level so both keymaps (<leader>e / <leader>o) share state.
-- NOTE: these keymaps live in the neo-tree `keys` spec (not keymaps.lua) so
-- lazy.nvim registers them AFTER LazyVim's defaults in the merged key list —
-- last registration wins, which is why this approach reliably overrides <leader>e.
local _neo_focus = false

local function _find_pkg_root(file)
  local markers = { "package.json", "tsconfig.json", "Cargo.toml", "go.mod", "pyproject.toml", ".git" }
  local dir = vim.fn.fnamemodify(file, ":p:h")
  while true do
    for _, m in ipairs(markers) do
      if vim.fn.filereadable(dir .. "/" .. m) == 1 or vim.fn.isdirectory(dir .. "/" .. m) == 1 then
        return dir
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then break end
    dir = parent
  end
  return vim.fn.getcwd()
end

-- Opens/navigates neo-tree to `dir` using the MAIN filesystem state so that
-- filtered_items (hide_dotfiles=false) from plugin config is always active.
-- Using cmd.execute({ dir = ... }) creates a separate extra-state that ignores
-- those opts and can accidentally open a second panel — avoid that by navigating
-- the existing state in-place via fs.navigate() instead.
local function _neo_open(dir)
  local reveal = vim.fn.expand("%:p")
  -- Open/focus the main filesystem state (lazy.nvim loads neo-tree if needed)
  vim.cmd("Neotree filesystem reveal")
  vim.schedule(function()
    local ok, manager = pcall(require, "neo-tree.sources.manager")
    if not ok then return end
    local state = manager.get_state("filesystem")
    if not state then return end
    -- Ensure dotfiles stay visible (H key can toggle this at runtime)
    if state.filtered_items then
      state.filtered_items.hide_dotfiles = false
    end
    -- Navigate the existing state to the target root without opening a second tree
    local ok2, fs = pcall(require, "neo-tree.sources.filesystem")
    if ok2 and type(fs.navigate) == "function" then
      fs.navigate(state, dir, reveal)
    end
  end)
end

return {
  -- ─── TODO Comments — custom colors only, everything else default ─────────────
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        TODO  = { color = "#89b4fa" }, -- catppuccin blue
        FIXME = { color = "#f38ba8" }, -- catppuccin red
        NOTE  = { color = "#a6e3a1", alt = { "INFORMATION" } }, -- catppuccin green
        HACK  = { color = "#f9e2af" }, -- catppuccin yellow
        WARN  = { color = "#fab387" }, -- catppuccin peach
        PERF  = { color = "#cba6f7" }, -- catppuccin mauve
        TEST  = { color = "#94e2d5" }, -- catppuccin teal
        INFO  = { color = "#89dceb" }, -- catppuccin sky
      },
    },
  },

  -- ─── Diagnostics — inline text only on cursor line, full float via <leader>cd ─
  {
    "LazyVim/LazyVim",
    opts = {
      diagnostics = {
        virtual_text = {
          only_current_line = true, -- no clutter on other lines
          source = "if_many",       -- show source when multiple (eslint vs ts)
          spacing = 2,
          prefix = "●",
          format = function(d)
            local msg = d.message
            if #msg > 60 then msg = msg:sub(1, 57) .. "..." end
            return msg
          end,
        },
        float = { source = true, border = "rounded" },
      },
    },
  },

  -- ─── Inline Git Blame (GitLens-style) ───────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- show blame at end of current line
      current_line_blame_opts = {
        delay = 500,
        virt_text_pos = "eol",
      },
      current_line_blame_formatter = "  <author>, <author_time:%d %b %Y> · <summary>",
    },
  },

  -- ─── File Explorer (neo-tree only, no double explorer) ───────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- <leader>e  → toggle explorer (cwd root, reveals current file)
    -- <leader>o  → toggle focus mode (roots tree at nearest package root)
    -- <leader>fe / <leader>fE still work via LazyVim defaults
    keys = {
      {
        "<leader>e",
        function()
          _neo_focus = false
          local ok1, renderer = pcall(require, "neo-tree.ui.renderer")
          local ok2, manager  = pcall(require, "neo-tree.sources.manager")
          if ok1 and ok2 and renderer.tree_is_visible(manager.get_state("filesystem")) then
            require("neo-tree.command").execute({ action = "close" })
            return
          end
          _neo_open(vim.fn.getcwd())
        end,
        desc = "Toggle Explorer",
      },
      {
        "<leader>o",
        function()
          _neo_focus = not _neo_focus
          local dir = _neo_focus and _find_pkg_root(vim.fn.expand("%:p")) or vim.fn.getcwd()
          _neo_open(dir)
        end,
        desc = "Toggle Explorer Focus Mode",
      },
    },
    opts = function(_, opts)
      -- Resize helper: update edgy.config.layout.left.size (the edgebar's total
      -- width) then call layout.update() — this is the only way that persists.
      -- Direct nvim_win_set_width gets reverted by edgy on its next layout pass.
      local function neo_resize(delta)
        local ok, cfg = pcall(require, "edgy.config")
        if ok and cfg.layout and cfg.layout.left then
          cfg.layout.left.size = math.max(20, cfg.layout.left.size + delta)
          require("edgy.layout").update()
          return
        end
        -- Fallback when edgy is not active
        vim.cmd("vertical resize " .. math.max(20, vim.fn.winwidth(0) + delta))
      end

      -- Use nui.nvim floating popups for create/rename input and delete confirm
      -- This bypasses noice/cmdheight entirely so prompts are always visible
      opts.use_popups_for_input = true
      opts.popup_border_style   = "rounded"

      opts.filesystem = vim.tbl_deep_extend("force", opts.filesystem or {}, {
        filtered_items = {
          visible       = true,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
        follow_current_file = { enabled = false }, -- handled manually above to avoid handle_reveal crash
      })
      opts.window = vim.tbl_deep_extend("force", opts.window or {}, {
        width = 40,
        mappings = {
          ["<space>"] = "none",
          [">"]       = function() neo_resize(5) end,
          ["<"]       = function() neo_resize(-5) end,
        },
      })
      return opts
    end,
  },

  -- Disable snacks.explorer so only neo-tree is used
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
      dashboard = {
        preset = {
          header = [[
  ██████╗ ██████╗ ██████╗ ██╗███╗   ██╗ ██████╗     ████████╗██╗███╗   ███╗███████╗
 ██╔════╝██╔═══██╗██╔══██╗██║████╗  ██║██╔════╝     ╚══██╔══╝██║████╗ ████║██╔════╝
 ██║     ██║   ██║██║  ██║██║██╔██╗ ██║██║  ███╗       ██║   ██║██╔████╔██║█████╗
 ██║     ██║   ██║██║  ██║██║██║╚██╗██║██║   ██║       ██║   ██║██║╚██╔╝██║██╔══╝
 ╚██████╗╚██████╔╝██████╔╝██║██║ ╚████║╚██████╔╝       ██║   ██║██║ ╚═╝ ██║███████╗
  ╚═════╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },

  -- ─── Peek Definition (gp = peek, q = close) ─────────────────────────────────
  {
    "rmagatti/goto-preview",
    event = "LspAttach",
    opts = {
      width = 120,
      height = 20,
      border = "rounded",
      default_mappings = false, -- we set our own below
      -- When the float opens, map Esc to close it (buffer-local, won't affect other windows)
      post_open_hook = function(buf, _)
        vim.keymap.set("n", "<Esc>", function()
          require("goto-preview").close_all_win()
        end, { buffer = buf, silent = true, desc = "Close peek window" })
      end,
    },
    keys = {
      {
        "gp",
        function()
          require("goto-preview").goto_preview_definition()
        end,
        desc = "Peek Definition",
      },
      {
        "gpi",
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          local supported = vim.tbl_filter(function(c)
            return c.supports_method("textDocument/implementation")
          end, clients)
          if #supported == 0 then
            vim.notify("Peek implementation not supported for " .. vim.bo.filetype, vim.log.levels.WARN)
          else
            require("goto-preview").goto_preview_implementation()
          end
        end,
        desc = "Peek Implementation",
      },
      {
        "gpr",
        function()
          require("goto-preview").goto_preview_references()
        end,
        desc = "Peek References",
      },
      {
        "gpt",
        function()
          require("goto-preview").goto_preview_type_definition()
        end,
        desc = "Peek Type Definition",
      },
      {
        "gpc",
        function()
          require("goto-preview").close_all_win()
        end,
        desc = "Close All Peek Windows",
      },
    },
  },

}
