-- REST client — write and run HTTP requests inside Neovim
-- Create a file ending in .http and write requests like:
--
-- @baseUrl = http://localhost:3000
-- @token = my-jwt-token
--
-- ### Health check
-- GET {{baseUrl}}/health
--
-- ### Get all workflows
-- GET {{baseUrl}}/workflows
-- Authorization: Bearer {{token}}
--
-- ### Create workflow
-- POST {{baseUrl}}/workflows
-- Content-Type: application/json
--
-- {
--   "name": "my-workflow",
--   "steps": []
-- }
return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      split_direction        = "vertical",   -- response opens in right split
      default_view           = "body",       -- show body by default (not headers)
      show_variable_info_text = true,        -- show variable values inline in the file

      -- Response formatting per content type
      contenttypes = {
        ["application/json"] = {
          ft        = "json",
          formatter = { "jq", "." },         -- pretty-print JSON with jq
        },
        ["application/xml"] = {
          ft        = "xml",
          formatter = { "xmllint", "--format", "-" },
        },
        ["text/html"] = {
          ft        = "html",
          formatter = { "prettier", "--parser", "html" },
        },
      },

      icons = {
        inlay = {
          loading = "⏳",
          done    = "✅",
          error   = "❌",
        },
      },
    },
    keys = {
      -- Run requests
      { "<leader>rr", function() require("kulala").run() end,              ft = { "http", "rest" }, desc = "Run request" },
      { "<leader>ra", function() require("kulala").run_all() end,          ft = { "http", "rest" }, desc = "Run all requests" },
      { "<leader>rp", function() require("kulala").replay() end,           ft = { "http", "rest" }, desc = "Replay last request" },

      -- Inspect & copy
      { "<leader>ri", function() require("kulala").inspect() end,          ft = { "http", "rest" }, desc = "Inspect request" },
      { "<leader>rc", function() require("kulala").copy() end,             ft = { "http", "rest" }, desc = "Copy as cURL" },

      -- View response
      { "<leader>rv", function() require("kulala").toggle_view() end,      ft = { "http", "rest" }, desc = "Toggle body/headers/stats" },
      { "<leader>rS", function() require("kulala").show_stats() end,       ft = { "http", "rest" }, desc = "Show response stats" },

      -- Environment & scratchpad
      { "<leader>re", function() require("kulala").set_selected_env() end, ft = { "http", "rest" }, desc = "Switch environment" },
      { "<leader>rs", function() require("kulala").scratchpad() end,       ft = { "http", "rest" }, desc = "Open scratchpad" },

      -- Import from cURL (paste a curl command, convert to .http)
      { "<leader>rf", function() require("kulala").from_curl() end,        ft = { "http", "rest" }, desc = "Import from cURL" },

      -- Navigation
      { "]r",         function() require("kulala").jump_next() end,        ft = { "http", "rest" }, desc = "Next request" },
      { "[r",         function() require("kulala").jump_prev() end,        ft = { "http", "rest" }, desc = "Prev request" },
    },
  },
}
