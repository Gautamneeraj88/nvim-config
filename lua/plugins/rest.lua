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
      contenttypes = {
        ["application/json"] = {
          ft        = "json",
          formatter = { "jq", "." }, -- format JSON responses with jq
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
      { "<leader>rr", function() require("kulala").run() end,              ft = "http", desc = "Run request" },
      { "<leader>ra", function() require("kulala").run_all() end,          ft = "http", desc = "Run all requests" },
      { "<leader>rp", function() require("kulala").replay() end,           ft = "http", desc = "Replay last request" },
      { "<leader>ri", function() require("kulala").inspect() end,          ft = "http", desc = "Inspect request" },
      { "<leader>rc", function() require("kulala").copy() end,             ft = "http", desc = "Copy as cURL" },
      { "<leader>re", function() require("kulala").set_selected_env() end, ft = "http", desc = "Switch environment" },
      { "]r",         function() require("kulala").jump_next() end,        ft = "http", desc = "Next request" },
      { "[r",         function() require("kulala").jump_prev() end,        ft = "http", desc = "Prev request" },
    },
  },
}
