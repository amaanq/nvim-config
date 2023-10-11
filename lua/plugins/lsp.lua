local util = require("util")

return {
  -- neodev
  {
    "folke/neodev.nvim",
    opts = {
      debug = true,
      experimental = {
        pathStrict = true,
      },
    },
  },

  -- tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "eslint_d",
        "luacheck",
        "prettierd",
        "prosemd-lsp",
        "ruff",
        "selene",
        "shellcheck",
        "shfmt",
        "stylua",
      },
    },
  },

  -- {
  --   "jay-babu/mason-null-ls.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "nvimtools/none-ls.nvim",
  --   },
  --   opts = {
  --     ensure_installed = {},
  --     automatic_installation = true,
  --   },
  --   config = true,
  -- },

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {},
      automatic_installation = true,
    },
    config = true,
  },

  {
    "DNLHC/glance.nvim",
    event = "BufReadPre",
    config = true,
    keys = {
      { "gM", "<cmd>Glance implementations<cr>", desc = "Goto Implementations (Glance)" },
      { "gY", "<cmd>Glance type_definitions<cr>", desc = "Goto Type Definition (Glance)" },
    },
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true, inlay_hints = { enabled = true } } },
        keys = {
          { "<leader>cln", "<cmd>Navbuddy<cr>", desc = "Lsp Navigation" },
        },
      },
    },
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

      require("which-key").register({
        ["<leader>cl"] = { name = "+lsp" },
      })
    end,
    opts = {
      diagnostics = { virtual_text = { prefix = "icons" } },
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = false,
          },
        },
      },
      ---@type lspconfig.options
      servers = {
        ansiblels = {},
        asm_lsp = {},
        bashls = {},
        cmake = {},
        cssls = {},
        html = {},
        lua_ls = {
          single_file_support = true,
          ---@type lspconfig.settings.lua_ls
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  "--log-level=trace",
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
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
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "tab",
                  indent_size = "4",
                  continuation_indent_size = "4",
                },
              },
            },
          },
        },
        marksman = {},
        omnisharp = {},
        prosemd_lsp = {},
        pyright = {},
        texlab = {},
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        vimls = {},
        yamlls = {
          settings = {
            yaml = {
              customTags = {
                "!reference sequence", -- necessary for gitlab-ci.yaml files
              },
            },
          },
        },
      },
      setup = {},
    },
  },

  -- Rust Crates 🚀
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["markdown"] = { { "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "prettierd", "prettier" } },
        ["javascript"] = { "eslint_d" },
        ["javascriptreact"] = { "eslint_d" },
        ["typescript"] = { "eslint_d" },
        ["typescriptreact"] = { "eslint_d" },
        ["python"] = { "isort", "black" },
        ["sh"] = { "shfmt" },
        ["c"] = { "uncrustify" },
        ["cpp"] = { "uncrustify" },
      },
      formatters = {
        eslint_d = {
          condition = function(ctx)
            return vim.fs.find({ ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" }, {
              path = ctx.filename,
              upward = true,
            })[1]
          end,
        },
        dprint = {
          condition = function(ctx)
            return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        uncrustify = {
          condition = function(ctx)
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
        markdown = { "markdownlint" },
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

  -- null-ls
  {
    "nvimtools/none-ls.nvim",
    enabled = false,
    -- opts = function(_, opts)
    -- local util = require("util")
    -- local nls = require("null-ls")
    -- local fmt = nls.builtins.formatting
    -- local dgn = nls.builtins.diagnostics
    --
    -- opts.debounce = 150
    -- opts.save_after_format = false
    -- opts.root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git")
    --
    -- vim.list_extend(opts.sources, {
    --   --  ╭────────────╮
    --   --  │ Formatting │
    --   --  ╰────────────╯
    --   fmt.black.with({
    --     condition = function()
    --       return util.executable("black", true)
    --     end,
    --     args = { "--line-length", "120" },
    --   }),
    --   -- fmt.dprint.with({
    --   --   condition = function()
    --   --     -- return util.executable("dprint", true)
    --   --     return true
    --   --   end,
    --   -- }),
    --   fmt.eslint_d.with({
    --     condition = function()
    --       return util.executable("eslint_d", true)
    --         and not vim.tbl_isempty(vim.fs.find({
    --           ".eslintrc",
    --           ".eslintrc.js",
    --           ".eslintrc.cjs",
    --           ".eslintrc.json",
    --           ".eslintrc.yaml",
    --           ".eslintrc.yml",
    --         }, { path = vim.fn.expand("%:p"), upward = true }))
    --     end,
    --   }),
    --   fmt.isort.with({
    --     condition = function()
    --       return util.executable("isort", true)
    --     end,
    --   }),
    --   fmt.nginx_beautifier.with({
    --     condition = function()
    --       return util.executable("nginxbeautifier", true)
    --     end,
    --   }),
    --   fmt.pg_format.with({
    --     condition = function()
    --       return util.executable("pg_format", true)
    --     end,
    --   }),
    --   fmt.prettierd.with({
    --     filetypes = { "graphql", "html", "json", "markdown", "yaml" },
    --     condition = function()
    --       return util.executable("prettierd", true)
    --     end,
    --   }),
    --   fmt.shfmt.with({
    --     condition = function()
    --       return util.executable("shfmt", true)
    --     end,
    --   }),
    --   fmt.sqlfluff.with({
    --     condition = function()
    --       return util.executable("sqlfluff", true)
    --     end,
    --   }),
    --   fmt.stylua.with({
    --     condition = function()
    --       return util.executable("stylua", true)
    --         and not vim.tbl_isempty(
    --           vim.fs.find({ ".stylua.toml", "stylua.toml" }, { path = vim.fn.expand("%:p"), upward = true })
    --         )
    --     end,
    --   }),
    --   fmt.uncrustify.with({
    --     condition = function()
    --       local paths = vim.fs.find(
    --         { "uncrustify.cfg", ".uncrustify.cfg" },
    --         { path = vim.fn.expand("%:p"), upward = true }
    --       )
    --       if vim.tbl_isempty(paths) then
    --         return false
    --       end
    --       if not util.executable("uncrustify", true) then
    --         return false
    --       end
    --       ---@type string
    --       vim.env.UNCRUSTIFY_CONFIG = paths[1]
    --       return true
    --     end,
    --   }),
    --
    --   --  ╭─────────────╮
    --   --  │ Diagnostics │
    --   --  ╰─────────────╯
    --   dgn.ansiblelint.with({
    --     condition = function()
    --       return util.executable("ansible-lint", true)
    --     end,
    --   }),
    --   dgn.buf.with({
    --     condition = function()
    --       return util.executable("buf", true)
    --     end,
    --   }),
    --   -- dgn.eslint_d.with({
    --   --   condition = function()
    --   --     return util.executable("eslint_d", true)
    --   --       and not vim.tbl_isempty(vim.fs.find({
    --   --         ".eslintrc",
    --   --         ".eslintrc.js",
    --   --         ".eslintrc.cjs",
    --   --         ".eslintrc.json",
    --   --         ".eslintrc.yaml",
    --   --         ".eslintrc.yml",
    --   --       }, { path = vim.fn.expand("%:p"), upward = true }))
    --   --   end,
    --   -- }),
    --   dgn.markdownlint.with({
    --     condition = function()
    --       return util.executable("markdownlint", true)
    --     end,
    --   }),
    --   dgn.protolint.with({
    --     condition = function()
    --       return util.executable("protolint", true)
    --     end,
    --   }),
    --   dgn.selene.with({
    --     condition = function(utils)
    --       return utils.root_has_file({ "selene.toml" }) and util.executable("selene", true)
    --     end,
    --   }),
    --   dgn.sqlfluff.with({
    --     condition = function()
    --       return util.executable("sqlfluff", true)
    --     end,
    --   }),
    -- })
    -- end,
  },
}
