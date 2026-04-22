return {
  -- ─── Better Folds (UFO) ───────────────────────────────────────────────────────
  -- Uses LSP + treesitter to fold functions, classes, imports intelligently
  -- Much smarter than Neovim's default folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    init = function()
      vim.opt.foldcolumn    = "0"   -- no gutter column; UFO virtual text shows fold counts instead
      vim.opt.foldlevel     = 99    -- open all folds by default
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable    = true
    end,
    opts = {
      -- Use LSP first, fall back to treesitter, then indent
      provider_selector = function(_, filetype, _)
        local lsp_filetypes = { "typescript", "javascript", "typescriptreact",
                                "javascriptreact", "python", "go", "json", "lua", "markdown",
                                "c", "cpp" }
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
  -- Press <leader>cg on any function, class, or type to generate the full
  -- doc comment template for the language automatically.
  -- TypeScript → TSDoc (@param, @returns)
  -- Python     → Google-style docstring (Args:, Returns:)
  -- Go         → godoc comment
  {
    "danymat/neogen",
    cmd  = "Neogen",
    keys = {
      { "<leader>cg", function() require("neogen").generate() end, desc = "Generate doc comment" },
    },
    opts = {
      snippet_engine = "luasnip",
      languages = {
        python     = { template = { annotation_convention = "google_docstrings" } },
        typescript = { template = { annotation_convention = "tsdoc" } },
        javascript = { template = { annotation_convention = "jsdoc" } },
        go         = { template = { annotation_convention = "godoc" } },
        c          = { template = { annotation_convention = "doxygen" } },
        cpp        = { template = { annotation_convention = "doxygen" } },
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
    opts = {
      act_as_tab = true, -- pass Tab through to blink.cmp when completion is active
    },
  },

  -- ─── Treesitter Textobjects — af/if ac/ic aa/ia text objects ─────────────────
  -- af/if  = around/inside function   ac/ic  = around/inside class
  -- aa/ia  = around/inside argument   al/il  = around/inside loop
  --
  -- Motion: ]m / [m jump to next/prev function,  ]k / [k for class
  -- Swap:   <leader>as  swap arg right,  <leader>aS  swap arg left
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = {
      textobjects = {
        select = {
          enable    = true,
          lookahead = true, -- jump to next textobject if not on one
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Around function" },
            ["if"] = { query = "@function.inner", desc = "Inside function" },
            ["ac"] = { query = "@class.outer",    desc = "Around class" },
            ["ic"] = { query = "@class.inner",    desc = "Inside class" },
            ["aa"] = { query = "@parameter.outer", desc = "Around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "Inside argument" },
            ["al"] = { query = "@loop.outer",      desc = "Around loop" },
            ["il"] = { query = "@loop.inner",      desc = "Inside loop" },
          },
        },
        move = {
          enable    = true,
          set_jumps = true, -- add to jumplist so <C-o>/<C-i> works
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function start" },
            ["]k"] = { query = "@class.outer",    desc = "Next class start" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next function end" },
            ["]K"] = { query = "@class.outer",    desc = "Next class end" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Prev function start" },
            ["[k"] = { query = "@class.outer",    desc = "Prev class start" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "Prev function end" },
            ["[K"] = { query = "@class.outer",    desc = "Prev class end" },
          },
        },
        swap = {
          enable = true,
          swap_next     = { ["<leader>as"] = { query = "@parameter.inner", desc = "Swap arg right" } },
          swap_previous = { ["<leader>aS"] = { query = "@parameter.inner", desc = "Swap arg left" } },
        },
      },
    },
  },

  -- ─── Various Textobjects — URL, number, indent, markdown, Python docstring ───
  -- Complements treesitter-textobjects (which handles functions/classes/args/loops).
  -- New textobjects (o/x mode):
  --   au/iu  = URL                    an/in  = number
  --   ai/ii  = indentation block      aV/iV  = value in assignment (x = |val|)
  --   am/im  = markdown link          aP/iP  = Python triple-quote string
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "BufReadPost",
    opts = { keymaps = { useDefaults = false } },
    config = function(_, opts)
      require("various-textobjs").setup(opts)
      local vt = require("various-textobjs")
      local map = function(lhs, fn, desc)
        vim.keymap.set({ "o", "x" }, lhs, fn, { desc = desc })
      end
      -- URL (open/yank a URL cleanly)
      map("au", function() vt.url("outer") end,          "Around URL")
      map("iu", function() vt.url("inner") end,          "Inner URL")
      -- Number
      map("an", function() vt.number("outer") end,       "Around number")
      map("in", function() vt.number("inner") end,       "Inner number")
      -- Indentation block (especially useful in Python)
      map("ai", function() vt.indentation("outer", "outer") end, "Around indent")
      map("ii", function() vt.indentation("inner", "inner") end, "Inner indent")
      -- Assignment value  x = |value|
      map("aV", function() vt.value("outer") end,        "Around value")
      map("iV", function() vt.value("inner") end,        "Inner value")
      -- Markdown link
      map("am", function() vt.mdLink("outer") end,       "Around md link")
      map("im", function() vt.mdLink("inner") end,       "Inner md link (URL part)")
      -- Python triple-quoted string / docstring
      map("aP", function() vt.pyTripleQuotes("outer") end, "Around Python triple-string")
      map("iP", function() vt.pyTripleQuotes("inner") end, "Inner Python triple-string")
    end,
  },

  -- ─── TypeScript Error Translator — human-readable TS errors ──────────────────
  -- TypeScript errors like "Type 'X' is not assignable to type 'Y' …" become
  -- plain English explanations inline in the diagnostic float.
  -- No keymaps needed — replaces the diagnostic text automatically.
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = { auto_override_publish_diagnostics = true },
  },

  -- ─── Completion ghost text — inline suggestion preview ───────────────────────
  -- Shows the top completion candidate greyed-out as you type (like VS Code inline).
  -- Accept with Tab (tabout.nvim already wires Tab → blink → tabout fallback).
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = { enabled = true },
      },
    },
  },
}
