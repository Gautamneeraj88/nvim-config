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
      "nvim-neotest/neotest-go",         -- Go
    },
    opts = {
      adapters = {
        -- Jest (detects jest.config.* automatically)
        ["neotest-jest"] = {
          jestCommand = "npx jest",
          jestConfigFile = function()
            local file = vim.fn.expand("%:p")
            if string.find(file, "/packages/") then
              return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
            end
            return vim.fn.getcwd() .. "/jest.config.ts"
          end,
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
        -- Vitest (detects vitest.config.* automatically)
        ["neotest-vitest"] = {},
        -- Python pytest
        ["neotest-python"] = {
          dap = { justMyCode = false },
          runner = "pytest",
        },
        -- Go
        ["neotest-go"] = {
          experimental = { test_table = true },
          args = { "-count=1", "-timeout=60s", "-race" },
        },
      },
      -- Show output in a floating window
      output = { open_on_run = true },
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
      { "]t",         function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next failed test" },
      { "[t",         function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Prev failed test" },
    },
  },
}
