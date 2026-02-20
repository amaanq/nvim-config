local util = require("util")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ty = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "eslint_d" },
        ["javascriptreact"] = { "eslint_d" },
        ["typescript"] = { "eslint_d" },
        ["typescriptreact"] = { "eslint_d" },
        ["sh"] = { "shfmt" },
        ["c"] = { "uncrustify" },
        ["cpp"] = { "uncrustify" },
        ["xml"] = { "xmllint" },
      },
      formatters = {
        eslint_d = {
          condition = function(_self, ctx)
            local package_json = vim.fs.find({ "package.json" }, { path = ctx.filename, upward = true })[1]
            if package_json then
              local f = io.open(package_json, "r")
              if f then
                local data = vim.json.decode(f:read("*all"))
                f:close()
                if data and data.eslintConfig then
                  return true
                end
              end
            end
            return vim.fs.find(
              { ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", "eslint.config.mjs" },
              {
                path = ctx.filename,
                upward = true,
              }
            )[1]
          end,
        },
        dprint = {
          condition = function(_, ctx)
            return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        uncrustify = {
          condition = function(_self, ctx)
            local paths = vim.fs.find({ "uncrustify.cfg", ".uncrustify.cfg" }, {
              path = ctx.filename,
              upward = true,
            })
            if vim.tbl_isempty(paths) then
              return false
            end
            if not util.executable("uncrustify", true) then
              return false
            end
            ---@type string
            vim.env.UNCRUSTIFY_CONFIG = paths[1]
            return true
          end,
        },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene", "luacheck" },
      },
      linters = {
        selene = {
          condition = function(ctx)
            return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        luacheck = {
          condition = function(ctx)
            return vim.fs.find({ ".luacheckrc" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
}
