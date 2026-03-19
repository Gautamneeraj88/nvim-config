-- Debugger (DAP) — set breakpoints, step through code, inspect variables
-- Supports: Python (debugpy), Go (delve), TypeScript/JavaScript (vscode-js-debug)
-- Adapters are installed automatically by mason-nvim-dap on first launch.
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
          icons = { expanded = "▾", collapsed = "▸", current_frame = "→" },
          controls = {
            icons = {
              pause        = "⏸",
              play         = "▶",
              step_into    = "↓",
              step_over    = "→",
              step_out     = "↑",
              step_back    = "←",
              run_last     = "↺",
              terminate    = "⏹",
              disconnect   = "⏏",
            },
          },
          layouts = {
            {
              -- LEFT PANEL — 4 sections, each with its own header label
              elements = {
                { id = "scopes",      size = 0.40 }, -- header: "Scopes"      → variables & values
                { id = "breakpoints", size = 0.20 }, -- header: "Breakpoints" → all breakpoints set
                { id = "stacks",      size = 0.25 }, -- header: "Stacks"      → call stack / how you got here
                { id = "watches",     size = 0.15 }, -- header: "Watches"     → expressions you're monitoring
              },
              size     = 45,
              position = "left",
            },
            {
              -- BOTTOM PANEL — 2 sections with header labels
              elements = {
                { id = "repl",    size = 0.45 }, -- header: "DAP REPL"  → type expressions to evaluate
                { id = "console", size = 0.55 }, -- header: "Console"   → print() output shows here
              },
              size     = 12,
              position = "bottom",
            },
          },
          floating = {
            max_height  = 0.9,
            max_width   = 0.5,
            border      = "rounded",
          },
        },
        config = function(_, opts)
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup(opts)

          -- Add visible header labels to each DAP panel
          local dap_titles = {
            dapui_scopes      = "  Variables",
            dapui_breakpoints = "  Breakpoints",
            dapui_stacks      = "  Call Stack",
            dapui_watches     = "  Watches",
            dapui_console     = "  Console",
            ["dap-repl"]      = "  REPL",
          }
          vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
            callback = function(args)
              local ft = vim.bo[args.buf].filetype
              local title = dap_titles[ft]
              if not title then return end
              -- defer so window is fully initialized before setting winbar
              vim.schedule(function()
                for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
                  vim.api.nvim_set_option_value("winbar", title, { win = win })
                end
              end)
            end,
          })

          -- Auto-open UI when debugging starts, auto-close when done
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      -- Shows variable values inline in your code while debugging
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          highlight_changed_variables = true,
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
      local dap = require("dap")

      -- Breakpoint sign styling
      vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint",         linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected",  { text = "○", texthl = "DapBreakpointRejected",  linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint",            { text = "◎", texthl = "DapLogPoint",            linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })

      -- ─── TypeScript / JavaScript adapter ────────────────────────────────────────
      local js_debug = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
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
    opts = {},
    keys = {
      { "<leader>dgt", function() require("dap-go").debug_test() end,           ft = "go", desc = "Debug: Go Test" },
      { "<leader>dgl", function() require("dap-go").debug_last_test() end,      ft = "go", desc = "Debug: Go Last Test" },
    },
  },

}
