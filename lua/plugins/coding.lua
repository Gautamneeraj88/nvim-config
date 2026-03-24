return {
  -- ─── Better Folds (UFO) ───────────────────────────────────────────────────────
  -- Uses LSP + treesitter to fold functions, classes, imports intelligently
  -- Much smarter than Neovim's default folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    init = function()
      vim.opt.foldcolumn    = "1"   -- show fold indicators in gutter
      vim.opt.foldlevel     = 99    -- open all folds by default
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable    = true
    end,
    opts = {
      -- Use LSP first, fall back to treesitter, then indent
      provider_selector = function(_, filetype, _)
        local lsp_filetypes = { "typescript", "javascript", "typescriptreact",
                                "javascriptreact", "python", "go", "json", "lua", "markdown" }
        if vim.tbl_contains(lsp_filetypes, filetype) then
          return { "lsp", "treesitter" }
        end
        -- Only use treesitter if a parser is actually installed — avoids UfoFallbackException
        -- for filetypes like 'http', 'rest', etc. that have no treesitter parser
        -- vim.treesitter.language.inspect() errors when parser is missing — pcall gives us a boolean
        if pcall(vim.treesitter.language.inspect, filetype) then
          return { "treesitter", "indent" }
        end
        return { "indent" }
      end,
      -- Show how many lines are folded in a virtual text hint
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d lines"):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,          desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end,         desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end,  desc = "Open folds except kinds" },
      { "zm", function() require("ufo").closeFoldsWith() end,        desc = "Close folds with level" },
      { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek folded lines" },
    },
  },

  -- ─── Refactoring — extract function / variable / block ───────────────────────
  -- Select code in visual mode and extract it into a new function or variable.
  -- Works for TypeScript, JavaScript, Python, Go, Lua.
  -- Uses <leader>R prefix to avoid conflict with REST client's <leader>r prefix.
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPre",
    opts = {},
    keys = {
      -- Visual: select code → extract to a named function
      { "<leader>Re", function() require("refactoring").refactor("Extract Function") end, mode = "v", desc = "Refactor: Extract Function" },
      -- Visual: select expression → extract to a named variable
      { "<leader>Rv", function() require("refactoring").refactor("Extract Variable") end, mode = "v", desc = "Refactor: Extract Variable" },
      -- Normal/Visual: inline a variable back into its usages
      { "<leader>Ri", function() require("refactoring").refactor("Inline Variable") end,  mode = { "n", "v" }, desc = "Refactor: Inline Variable" },
      -- Normal: extract a block of statements into its own function
      { "<leader>Rb", function() require("refactoring").refactor("Extract Block") end,    mode = "n", desc = "Refactor: Extract Block" },
    },
  },

  -- ─── Auto-tag — auto-close and auto-rename HTML/JSX tags ─────────────────────
  -- Type <div → becomes <div></div> with cursor inside.
  -- Rename the opening tag → closing tag renames automatically.
  -- Works in: html, jsx, tsx, vue, svelte, xml, markdown, php.
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },

  -- ─── Neogen — generate doc comments from function signatures ──────────────────
  -- Press <leader>nd on any function, class, or type to generate the full
  -- doc comment template for the language automatically.
  -- TypeScript → TSDoc (@param, @returns)
  -- Python     → Google-style docstring (Args:, Returns:)
  -- Go         → godoc comment
  {
    "danymat/neogen",
    cmd  = "Neogen",
    keys = {
      { "<leader>nd", function() require("neogen").generate() end, desc = "Generate doc comment" },
    },
    opts = {
      snippet_engine = "luasnip",
      languages = {
        python     = { template = { annotation_convention = "google_docstrings" } },
        typescript = { template = { annotation_convention = "tsdoc" } },
        javascript = { template = { annotation_convention = "jsdoc" } },
        go         = { template = { annotation_convention = "godoc" } },
      },
    },
  },

  -- ─── Tabout — Tab key jumps out of brackets/quotes ───────────────────────────
  -- When cursor is inside brackets/quotes, Tab jumps to after the closing symbol
  -- e.g. inside "hello|" → press Tab → cursor moves after the closing "
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
