-- Fix pyright not finding venv packages in monorepos
-- Walks UP from the project root (params.rootPath) looking for a venv,
-- and also checks one level of subdirectories (e.g. monorepo/backend/.venv)
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(params, config)
            -- 1. Use activated venv if one is already active in the shell
            local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")

            -- 2. Walk up from the project root (params.rootPath), looking for a venv folder
            if not venv then
              -- params.rootPath is the project root detected by pyright
              -- params.rootUri gives us the workspace root
              local root = params.rootPath or vim.fn.getcwd()
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
              local root = params.rootPath or vim.fn.getcwd()
              local subdirs = vim.fn.glob(root .. "/*/.venv/bin/python", false, true)
              if #subdirs > 0 then
                venv = vim.fn.fnamemodify(subdirs[1], ":h:h") -- strip /bin/python
              end
            end

            if venv then
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = venv .. "/bin/python"
            end
          end,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
      },
    },
  },
}
