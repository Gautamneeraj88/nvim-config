-- Neotest: run tests without leaving Neovim
-- Supports Jest/Vitest (TS/JS), pytest (Python), Go test
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Adapters for your languages
      "nvim-neotest/neotest-jest",       -- TypeScript / JavaScript (Jest)
      "marilari88/neotest-vitest",       -- TypeScript / JavaScript (Vitest)
      "nvim-neotest/neotest-python",     -- Python (pytest)
      "fredrikaverpil/neotest-golang",   -- Go (newer, replaces neotest-go)
    },
    opts = {
      adapters = {
        -- Jest (detects jest.config.* automatically)
        ["neotest-jest"] = {
          jestCommand = "npx jest",
          jestConfigFile = function()
            local file = vim.fn.expand("%:p")
            local root = string.find(file, "/packages/")
              and string.match(file, "(.-/[^/]+/)src")
              or (vim.fn.getcwd() .. "/")
            for _, ext in ipairs({ "ts", "js", "mjs", "cjs" }) do
              local path = root .. "jest.config." .. ext
              if vim.fn.filereadable(path) == 1 then return path end
            end
          end,
          env = { CI = true },
        },
        -- Vitest (detects vitest.config.* automatically)
        ["neotest-vitest"] = {},
        -- Python pytest
        ["neotest-python"] = {
          dap = { justMyCode = false },
          runner = "pytest",
        },
        -- Go
        ["neotest-golang"] = {
          go_test_args = { "-count=1", "-timeout=60s", "-race" },
        },
      },
      -- Don't auto-open output panel — use <leader>to to check output when needed
      -- ("failed" is not a valid value; only true/false/"short" are supported)
      output = { open_on_run = false },
      status = { virtual_text = true }, -- show pass/fail inline in code
      icons = {
        passed  = " ",
        failed  = " ",
        running = " ",
        skipped = " ",
        unknown = " ",
      },
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end,                    desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,  desc = "Run all tests in file" },
      { "<leader>tl", function() require("neotest").run.run_last() end,               desc = "Re-run last test" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,             desc = "Toggle test summary" },
      { "<leader>to", function() require("neotest").output_panel.toggle() end,        desc = "Toggle test output" },
      { "<leader>tS", function() require("neotest").run.stop() end,                   desc = "Stop test" },
      { "]f",         function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next failed test" },
      { "[f",         function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Prev failed test" },
    },
  },
}
