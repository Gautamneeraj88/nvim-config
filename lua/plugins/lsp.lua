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
                maxTsServerMemory = 4096, -- prevent OOM on large monorepos
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

        -- ── Python (pyright) — merges with venv detection in python.lua ──────
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode      = "standard", -- real type errors (default is "off")
                reportUnusedImport    = "warning",
                reportUnusedVariable  = "warning",
              },
            },
          },
        },

      },
    },
  },
}
