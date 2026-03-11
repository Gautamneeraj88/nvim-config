-- Debugger (DAP) — set breakpoints, step through code, inspect variables
-- Supports: Python (debugpy), Go (delve), TypeScript/JavaScript (vscode-js-debug)
--
-- FIRST TIME SETUP:
-- Run :Mason and install:
--   • debugpy          (Python debugger)
--   • delve            (Go debugger)
--   • js-debug-adapter (TypeScript/JavaScript debugger)
return {
  -- ─── Core DAP ─────────────────────────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Beautiful UI panels for the debugger
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {
          icons = { expanded = "", collapsed = "", current_frame = "" },
          layouts = {
            {
              elements = {
                { id = "scopes",      size = 0.40 }, -- variables & their values
                { id = "breakpoints", size = 0.20 }, -- all breakpoints
                { id = "stacks",      size = 0.20 }, -- call stack
                { id = "watches",     size = 0.20 }, -- custom watch expressions
              },
              size = 40,
              position = "left",
            },
            {
              elements = {
                { id = "repl",   size = 0.5 }, -- debug console / REPL
                { id = "console", size = 0.5 }, -- program output
              },
              size = 12,
              position = "bottom",
            },
          },
        },
        config = function(_, opts)
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup(opts)
          -- Auto-open UI when debugging starts
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          -- Do NOT auto-close — user closes manually with <leader>du
          -- Auto-close was causing the UI to flash and disappear immediately
        end,
      },
      -- Shows variable values inline in your code while debugging
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          enabled         = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed    = false,
          show_stop_reason            = true,
          commented                   = false,
          virt_text_pos               = "eol", -- show at end of line
          all_frames                  = false,
          virt_lines                  = false,
          virt_text_win_col           = nil,
        },
      },
      -- Auto-installs debug adapters via Mason
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason.nvim" },
        opts = {
          automatic_installation = true,
          ensure_installed = { "python", "delve", "js" },
          handlers = {},
        },
      },
    },
    keys = {
      -- Start / control debugging
      { "<F5>",       function() require("dap").continue() end,           desc = "Debug: Start / Continue" },
      { "<F10>",      function() require("dap").step_over() end,          desc = "Debug: Step Over" },
      { "<F11>",      function() require("dap").step_into() end,          desc = "Debug: Step Into" },
      { "<F12>",      function() require("dap").step_out() end,           desc = "Debug: Step Out" },
      { "<F9>",       function() require("dap").step_back() end,          desc = "Debug: Step Back" },
      { "<leader>dq", function() require("dap").terminate() end,          desc = "Debug: Stop / Quit" },
      { "<leader>dr", function() require("dap").restart() end,            desc = "Debug: Restart" },

      -- Breakpoints
      { "<leader>db", function() require("dap").toggle_breakpoint() end,  desc = "Debug: Toggle Breakpoint" },
      { "<leader>dB", function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end, desc = "Debug: Conditional Breakpoint" },
      { "<leader>dl", function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
        end, desc = "Debug: Log Point" },

      -- UI
      { "<leader>du", function() require("dapui").toggle() end,           desc = "Debug: Toggle UI" },
      { "<leader>de", function() require("dapui").eval() end,             mode = { "n", "v" }, desc = "Debug: Eval Expression" },
      { "<leader>dc", function() require("dap").run_to_cursor() end,      desc = "Debug: Run to Cursor" },

      -- Inspect
      { "<leader>dh", function() require("dap.ui.widgets").hover() end,   desc = "Debug: Hover Variables" },
    },
    config = function()
      -- Breakpoint sign styling
      vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint",         linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected",  { text = "○", texthl = "DapBreakpointRejected",  linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint",            { text = "◎", texthl = "DapLogPoint",            linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
    end,
  },

  -- ─── Python Debugger ──────────────────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- Use debugpy installed by Mason
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(mason_path)
      -- Test method debugging
      require("dap-python").test_runner = "pytest"
    end,
    keys = {
      { "<leader>dtm", function() require("dap-python").test_method() end,  ft = "python", desc = "Debug: Test Method" },
      { "<leader>dtc", function() require("dap-python").test_class() end,   ft = "python", desc = "Debug: Test Class" },
    },
  },

  -- ─── Go Debugger ──────────────────────────────────────────────────────────────
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      delve = {
        path              = "dlv",
        initialize_timeout_sec = 20,
        port              = "${port}",
        args              = {},
        build_flags       = "",
      },
    },
    keys = {
      { "<leader>dgt", function() require("dap-go").debug_test() end,           ft = "go", desc = "Debug: Go Test" },
      { "<leader>dgl", function() require("dap-go").debug_last_test() end,      ft = "go", desc = "Debug: Go Last Test" },
    },
  },

  -- ─── TypeScript / JavaScript Debugger ─────────────────────────────────────────
  -- Uses js-debug-adapter installed via Mason (no build step needed)
  -- Run :Mason and install: js-debug-adapter
  {
    "mfussenegger/nvim-dap",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      local dap = require("dap")
      local js_debug = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      -- Register the adapter using Mason's installed js-debug-adapter
      for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "node-terminal" }) do
        dap.adapters[adapter] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args    = { js_debug, "${port}" },
          },
        }
      end

      -- Launch configurations for JS/TS files
      for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[lang] = {
          {
            type    = "pwa-node",
            request = "launch",
            name    = "Launch file (Node)",
            program = "${file}",
            cwd     = "${workspaceFolder}",
          },
          {
            type      = "pwa-node",
            request   = "attach",
            name      = "Attach to running process",
            processId = require("dap.utils").pick_process,
            cwd       = "${workspaceFolder}",
          },
          {
            type    = "pwa-chrome",
            request = "launch",
            name    = "Launch Chrome (localhost:3000)",
            url     = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
