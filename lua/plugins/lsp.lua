local util = require("util")

return {
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- move cl to cli
      keys[#keys + 1] = { "<leader>cl", false }
      keys[#keys + 1] = { "<leader>cli", "<cmd>LspInfo<cr>", desc = "LspInfo" }

      -- add more lsp keymaps
      keys[#keys + 1] = { "<leader>cla", vim.lsp.buf.add_workspace_folder, desc = "Add Folder" }
      keys[#keys + 1] = { "<leader>clr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Folder" }
      keys[#keys + 1] = {
        "<leader>cll",
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
        desc = "List Folders",
      }
      keys[#keys + 1] = { "<leader>clh", vim.lsp.codelens.run, desc = "Run Code Lens" }
      keys[#keys + 1] = { "<leader>cld", vim.lsp.codelens.refresh, desc = "Refresh Code Lens" }
      keys[#keys + 1] = { "<leader>cls", "<cmd>LspRestart<cr>", desc = "Restart Lsp" }

      require("which-key").add({
        { "<leader>cl", group = "lsp" },
      })
    end,
    opts = {
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = false,
          },
        },
      },
      codelens = {
        enabled = true,
      },
      diagnostics = { virtual_text = { prefix = "icons" } },
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      ---@diagnostic disable: missing-fields
      setup = {
        ty = function(_, opts)
          require("lspconfig.configs").ty = {
            default_config = {
              cmd = { "ty", "server" },
              filetypes = { "python" },
              root_dir = require("lspconfig.util").root_pattern("ty.toml", "pyproject.toml", ".git"),
              single_file_support = true,
            },
          }
          require("lspconfig").ty.setup(opts)
          return true
        end,
      },
      servers = {
        cssls = {},
        html = {},
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                diagnosticSeverityOverrides = {
                  reportWildcardImportFromLibrary = "none",
                  reportUnusedImport = "information",
                  reportUnusedClass = "information",
                  reportUnusedFunction = "information",
                  reportOptionalMemberAccess = "none",
                  reportUnknownVariableType = "none",
                  reportUnusedCallResult = "none",
                },
              },
              disableTaggedHints = true,
            },
          },
        },
        lua_ls = {
          single_file_support = true,
          ---@type lspconfig.settings.lua_ls
          settings = {
            Lua = {
              hover = { expandAlias = false },
              type = {
                castNumberToInteger = true,
                inferParamType = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
            },
          },
        },
        -- prosemd_lsp = {},
        gopls = {
          settings = {
            gopls = {
              analyses = {
                fieldalignment = false,
              },
            },
          },
        },
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

  {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      excluded_lsp_clients = {
        "null-ls",
        "jdtls",
        "copilot",
        "rust-analyzer",
        "clangd",
      },
    },
  },
}
