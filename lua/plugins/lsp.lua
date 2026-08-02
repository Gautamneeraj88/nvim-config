-- LSP fine-tuning — only settings NOT already set by LazyVim extras

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {

        -- ── TypeScript / JavaScript (vtsls) ─────────────────────────────────
        vtsls = {
          settings = {
            vtsls = {
              tsserver = {
                maxTsServerMemory = 3072, -- 3GB: enough for large monorepos, less wasteful on small projects
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              preferences = {
                importModuleSpecifier = "shortest",
                quoteStyle = "single",
              },
              inlayHints = {
                parameterNames         = { enabled = "all" },   -- show param names at call sites
                parameterTypes         = { enabled = true },    -- show param types
                variableTypes          = { enabled = true },    -- show inferred variable types
                propertyDeclarationTypes = { enabled = true },  -- show property types
                functionLikeReturnTypes = { enabled = true },   -- show inferred return types
                enumMemberValues       = { enabled = true },    -- show enum values
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              preferences = {
                importModuleSpecifier = "shortest",
                quoteStyle = "single",
              },
              inlayHints = {
                parameterNames         = { enabled = "all" },
                parameterTypes         = { enabled = true },
                variableTypes          = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues       = { enabled = true },
              },
            },
          },
        },

        -- ── Go (gopls) ───────────────────────────────────────────────────────
        gopls = {
          settings = {
            gopls = {
              staticcheck = true, -- runs staticcheck on top of go vet
              gofumpt     = true, -- stricter formatting (grouped imports, blank lines)
              analyses = {
                unusedparams   = true,
                unusedvariable = true,
                unusedwrite    = true,
                useany         = true, -- prefer `any` over `interface{}`
                nilness        = true, -- detect nil dereferences
                shadow         = true, -- detect variable shadowing
              },
              hints = {
                assignVariableTypes    = true,
                compositeLiteralFields = true,
                compositeLiteralTypes  = true,
                constantValues         = true,
                functionTypeParameters = true,
                parameterNames         = true,
                rangeVariableTypes     = true,
              },
            },
          },
        },

        -- ── Python: basedpyright (chosen via vim.g.lazyvim_python_lsp in lazy.lua,
        --    which enables it and disables pyright). Settings section is the
        --    lowercase `basedpyright` key — a capitalised key is silently ignored.
        basedpyright = {
          -- before_init is in lua/plugins/python.lua (venv detection + vim.NIL guard)
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode      = "standard",
                reportUnusedImport    = "warning",
                reportUnusedVariable  = "warning",
                autoSearchPaths       = true,
                useLibraryCodeForTypes = true,
                diagnosticMode        = "openFilesOnly",
                -- FastAPI's documented `Depends()` default-arg idiom is a false
                -- positive for this rule; the Annotated style avoids it entirely.
                reportCallInDefaultInitializer = "none",
                -- Stylistic noise on idiomatic SQLAlchemy/Pydantic class attrs
                -- (__tablename__, model_config) and missing @override decorators.
                reportUnannotatedClassAttribute = "none",
                reportImplicitOverride          = "none",
                inlayHints = {
                  variableTypes      = true,  -- show inferred variable types
                  functionReturnTypes = true, -- show inferred return types
                  callArgumentNames  = "all", -- show param names at call sites
                  genericTypes       = false, -- skip noisy generic type params
                },
              },
            },
          },
        },

        -- ── CSS / SCSS — autocompletion + validation for Tailwind classes ──────
        cssls  = {},
        scssls = {},

        -- ── HTML — autocompletion for tags + attributes ─────────────────────────
        html = {},

        -- ── Bash / Shell — autocompletion + diagnostics for .sh / .bash ────────
        bashls = {},

      },
    },
  },

  -- Install LSP servers via mason
  {
    "mason-org/mason-lspconfig.nvim",
    opts = { ensure_installed = { "basedpyright", "cssls", "html", "bashls" } },
  },

  -- ─── Formatting (conform) ──────────────────────────────────────────────────
  -- <leader>cf and format-on-save both use the stricter formatter.
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "gofumpt", "stylua", "shfmt", "shellcheck", "stylelint" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go    = { "goimports", "gofumpt" },
        lua   = { "stylua" },
        sh    = { "shfmt" },
        bash  = { "shfmt" },
        css   = { "prettier" },
        scss  = { "prettier" },
        html  = { "prettier" },
        -- JS/TS: prettier is default. To switch to biome (faster, all-in-one):
        --   1. Uncomment biome below, comment out prettier
        --   2. Run :LazyExtras → enable extras.formatting.biome
        --   3. Install biome: :MasonInstall biome
        --   javascript      = { "biome" },
        --   typescript       = { "biome" },
        --   javascriptreact  = { "biome" },
        --   typescriptreact  = { "biome" },
      },
    },
  },

  -- Shell + CSS linting
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        sh   = { "shellcheck" },
        bash = { "shellcheck" },
        css  = { "stylelint" },
        scss = { "stylelint" },
      },
    },
  },
}
