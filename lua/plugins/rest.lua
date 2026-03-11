-- REST client — write and run HTTP requests inside Neovim
-- Create a file ending in .http or .rest and write requests like:
--
-- ### Get all users
-- GET https://api.example.com/users
-- Content-Type: application/json
--
-- ### Create user
-- POST https://api.example.com/users
-- Content-Type: application/json
--
-- {
--   "name": "John",
--   "email": "john@example.com"
-- }
return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      default_view = "body",          -- show response body by default
      default_env = "dev",            -- default environment
      debug = false,
      contenttypes = {
        ["application/json"] = {
          ft = "json",
          formatter = { "jq", "." },  -- format JSON responses with jq
          pathresolver = require("kulala.parser.jsonpath").parse,
        },
      },
      show_icons = "on_request",
      icons = {
        inlay = {
          loading = "⏳",
          done    = "✅",
          error   = "❌",
        },
      },
    },
    keys = {
      { "<leader>rr", "<cmd>lua require('kulala').run()<cr>",            ft = "http", desc = "Run request" },
      { "<leader>ra", "<cmd>lua require('kulala').run_all()<cr>",        ft = "http", desc = "Run all requests" },
      { "<leader>rp", "<cmd>lua require('kulala').replay()<cr>",         ft = "http", desc = "Replay last request" },
      { "<leader>ri", "<cmd>lua require('kulala').inspect()<cr>",        ft = "http", desc = "Inspect request" },
      { "<leader>rc", "<cmd>lua require('kulala').copy()<cr>",           ft = "http", desc = "Copy as cURL" },
      { "<leader>re", "<cmd>lua require('kulala').set_selected_env()<cr>", ft = "http", desc = "Switch environment" },
      { "]r",         "<cmd>lua require('kulala').jump_next()<cr>",      ft = "http", desc = "Next request" },
      { "[r",         "<cmd>lua require('kulala').jump_prev()<cr>",      ft = "http", desc = "Prev request" },
    },
  },
}
