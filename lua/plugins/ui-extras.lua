return {

  -- ─── Color Highlighter ────────────────────────────────────────────────────────
  -- Shows hex/rgb/hsl/css/tailwind colors as colored backgrounds inline
  -- e.g. #ff0000 shows with a red background, "red" shows red, bg-red-500 shows red
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {
      filetypes = {
        -- only web/style filetypes where color values actually appear
        "css", "scss", "less",
        "html",
        "javascript", "typescript", "javascriptreact", "typescriptreact",
        "svelte", "vue",
        "json", "jsonc",
        css  = { css = true },
        html = { names = true },
      },
      user_default_options = {
        names         = false,            -- don't highlight color names globally (too noisy in code)
        RRGGBBAA      = true,
        tailwind      = true,             -- highlight Tailwind classes
        mode          = "background",     -- show as colored background
      },
    },
  },

  -- ─── Package Info — npm version hints in package.json ────────────────────────
  -- Shows current installed version and whether a package is outdated
  -- Only activates when you open package.json
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = { "BufReadPost */package.json", "BufReadPost package.json" },
    config = function()
      local dir = vim.fn.expand("%:p:h")
      local pm = "npm"
      if vim.fn.filereadable(dir .. "/pnpm-lock.yaml") == 1 then
        pm = "pnpm"
      elseif vim.fn.filereadable(dir .. "/yarn.lock") == 1 then
        pm = "yarn"
      end
      require("package-info").setup({ package_manager = pm })

      local function bind_keys(buf)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc, silent = true })
        end
        map("<leader>Pp", function() require("package-info").toggle() end, "Toggle package versions")
        map("<leader>Pu", function() require("package-info").update() end, "Update package")
        map("<leader>Pd", function() require("package-info").delete() end, "Delete package")
        map("<leader>Pi", function() require("package-info").install() end, "Install new package")
        map("<leader>Pc", function() require("package-info").change_version() end, "Change package version")
        local ok, wk = pcall(require, "which-key")
        if ok then
          wk.add({ { "<leader>P", group = "Package / npm", buffer = buf } })
        end
      end

      bind_keys(vim.api.nvim_get_current_buf())

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*/package.json", "package.json" },
        callback = function(ev)
          bind_keys(ev.buf)
        end,
      })
    end,
  },

}
