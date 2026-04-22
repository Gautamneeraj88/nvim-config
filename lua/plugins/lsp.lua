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

        -- ── Python: disable pyright, use basedpyright (stricter, faster, maintained) ──
        pyright = { enabled = false },
        basedpyright = {
          settings = {
            basedPyright = {
              analysis = {
                typeCheckingMode      = "standard",
                reportUnusedImport    = "warning",
                reportUnusedVariable  = "warning",
                autoSearchPaths       = true,
                useLibraryCodeForTypes = true,
                diagnosticMode        = "openFilesOnly",
              },
            },
          },
        },

      },
    },
  },

  -- Install basedpyright via mason
  {
    "mason-org/mason-lspconfig.nvim",
    opts = { ensure_installed = { "basedpyright" } },
  },

  -- ─── Go: wire gofumpt in conform (gopls alone won't override conform's formatter) ─
  -- LazyVim's lang.go extra defaults to gofmt. Override to gofumpt so
  -- <leader>cf and format-on-save both use the stricter formatter.
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "gofumpt", "stylua" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go  = { "goimports", "gofumpt" },
        lua = { "stylua" },
      },
    },
  },
}
