-- Python-specific plugins: venv-aware basedpyright, ruff formatter, iron.nvim REPL
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          before_init = function(params, config)
            -- 1. Use activated venv if one is already active in the shell
            local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")

            local root = (params.rootUri and vim.uri_to_fname(params.rootUri))
              or params.rootPath
              or vim.fn.getcwd()

            -- 2. Walk up from the project root, looking for a venv folder
            if not venv then
              local dir = root

              for _ = 1, 10 do -- walk up max 10 levels
                for _, name in ipairs({ ".venv", "venv", "env" }) do
                  local python = dir .. "/" .. name .. "/bin/python"
                  if vim.fn.executable(python) == 1 then
                    venv = dir .. "/" .. name
                    break
                  end
                end
                if venv then break end

                local parent = vim.fn.fnamemodify(dir, ":h")
                if parent == dir then break end -- reached filesystem root
                dir = parent
              end
            end

            -- 3. Also check subdirectories one level deep (e.g. monorepo/backend/.venv)
            if not venv then
              local subdirs = vim.fn.glob(root .. "/*/.venv/bin/python", false, true)
              if #subdirs > 0 then
                venv = vim.fn.fnamemodify(subdirs[1], ":h:h") -- strip /bin/python
              end
            end

            if venv then
              -- basedpyright inherits pyright's config schema: pythonPath lives under python.*
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = venv .. "/bin/python"
            end
          end,
        },
      },
    },
  },

  -- ─── Ruff — fast Python formatter + linter (replaces black + flake8) ────────
  -- Installed via mason. conform.nvim calls it on <leader>cf.
  -- ruff_format     → format code (like black, but 10-100x faster)
  -- ruff_organize_imports → sort + deduplicate imports
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "ruff" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
      },
    },
  },

  -- ─── Iron — Python + Node.js REPL inside Neovim ─────────────────────────────
  -- Send lines / selections / functions to an interactive REPL session.
  -- Python picks up the active venv automatically (VIRTUAL_ENV / CONDA_PREFIX).
  --
  -- Python workflow (<leader>p):
  --   <leader>po  → open REPL panel      <leader>pr  → restart REPL
  --   <leader>pl  → send current line    <leader>pv  → send visual selection
  --   <leader>pf  → send entire file     <leader>pc  → clear REPL screen
  --   <leader>ph  → hide REPL panel
  --
  -- Node.js workflow (<leader>j):
  --   <leader>jo  → open REPL panel      <leader>jr  → restart REPL
  --   <leader>jl  → send current line    <leader>jv  → send visual selection
  --   <leader>jf  → send entire file     <leader>jc  → clear REPL screen
  --   <leader>jh  → hide REPL panel
  {
    "Vigemus/iron.nvim",
    ft = { "python", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      require("iron.core").setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              -- use active venv's python if available
              command = function()
                local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
                if venv then return { venv .. "/bin/python" } end
                return { "python3" }
              end,
            },
            -- Node.js REPL — JS uses node directly; TS uses ts-node/tsx if installed
            javascript      = { command = { "node" } },
            javascriptreact = { command = { "node" } },
            typescript = {
              command = function()
                if vim.fn.executable("ts-node") == 1 then return { "ts-node" } end
                if vim.fn.executable("tsx") == 1 then return { "tsx" } end
                return { "node" } -- fallback: paste transpiled JS manually
              end,
            },
            typescriptreact = {
              command = function()
                if vim.fn.executable("ts-node") == 1 then return { "ts-node" } end
                if vim.fn.executable("tsx") == 1 then return { "tsx" } end
                return { "node" }
              end,
            },
          },
          repl_open_cmd = require("iron.view").split.horizontal.focus(0.35),
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      })
    end,
    keys = {
      -- Python keys
      { "<leader>po", "<cmd>IronRepl<cr>",    ft = "python", desc = "Open REPL" },
      { "<leader>pr", "<cmd>IronRestart<cr>", ft = "python", desc = "Restart REPL" },
      { "<leader>ph", "<cmd>IronHide<cr>",    ft = "python", desc = "Hide REPL" },
      { "<leader>pl", function() require("iron.core").send_line() end,
        ft = "python", desc = "Send line to REPL" },
      { "<leader>pv", function() require("iron.core").visual_send() end,
        mode = "v", ft = "python", desc = "Send selection to REPL" },
      { "<leader>pf", function() require("iron.core").send_file() end,
        ft = "python", desc = "Send file to REPL" },
      { "<leader>pc", function() require("iron.core").send(nil, string.char(12)) end,
        ft = "python", desc = "Clear REPL" },
      -- Node.js keys (js/ts/jsx/tsx)
      { "<leader>jo", "<cmd>IronRepl<cr>",    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }, desc = "Open Node REPL" },
      { "<leader>jr", "<cmd>IronRestart<cr>", ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }, desc = "Restart Node REPL" },
      { "<leader>jh", "<cmd>IronHide<cr>",    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }, desc = "Hide Node REPL" },
      { "<leader>jl", function() require("iron.core").send_line() end,
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }, desc = "Send line to Node REPL" },
      { "<leader>jv", function() require("iron.core").visual_send() end,
        mode = "v", ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }, desc = "Send selection to Node REPL" },
      { "<leader>jf", function() require("iron.core").send_file() end,
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }, desc = "Send file to Node REPL" },
      { "<leader>jc", function() require("iron.core").send(nil, string.char(12)) end,
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }, desc = "Clear Node REPL" },
    },
  },
}
