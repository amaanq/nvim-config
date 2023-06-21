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
        -- "deno",
        -- "dprint",
        "eslint_d",
        "isort",
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

  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    opts = {
      ensure_installed = {},
      automatic_installation = true,
    },
    config = true,
  },

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

      local format = require("lazyvim.plugins.lsp.format")
      ---@diagnostic disable-next-line: duplicate-set-field
      format.on_attach = function(client, buf)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
            buffer = buf,
            callback = function()
              if format.autoformat then
                format.format()
              end
            end,
          })
        end

        if client.supports_method("textDocument/codeLens") then
          vim.cmd([[
						augroup lsp_document_codelens
							au! * <buffer>
							autocmd BufEnter ++once         <buffer> lua require"vim.lsp.codelens".refresh()
							autocmd BufWritePost,CursorHold <buffer> lua require"vim.lsp.codelens".refresh()
						augroup END
					]])
        end
      end

      -- disable lsp watcher. Too slow on linux
      local ok, wf = pcall(require, "vim.lsp._watchfiles")
      if ok then
        wf._watchfunc = function()
          return function() end
        end
      end
    end,
    opts = {
      ---@type lspconfig.options
      diagnostics = { virtual_text = { prefix = "icons" } },
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
              diagnostics = {
                disable = { "incomplete-signature-doc" },
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
        teal_ls = {},
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
        vala_ls = {},
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
        zls = {},
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

  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local util = require("util")
      local nls = require("null-ls")
      local fmt = nls.builtins.formatting
      local dgn = nls.builtins.diagnostics
      local cda = nls.builtins.code_actions

      opts.debounce = 150
      opts.save_after_format = false
      opts.root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git")

      vim.list_extend(opts.sources, {
        --  ╭────────────╮
        --  │ Formatting │
        --  ╰────────────╯
        fmt.asmfmt.with({
          condition = function()
            return util.executable("asmfmt", true)
          end,
        }),
        fmt.cbfmt.with({
          condition = function()
            return util.executable("cbfmt", true)
          end,
        }),
        -- fmt.clang_format.with({
        --   condition = function()
        --     return util.executable("clang-format", true)
        --   end,
        -- }),
        -- fmt.dprint.with({
        --   condition = function()
        --     -- return util.executable("dprint", true)
        --     return true
        --   end,
        -- }),
        fmt.eslint_d.with({
          condition = function()
            return util.executable("eslint_d", true)
              and not vim.tbl_isempty(vim.fs.find({
                ".eslintrc",
                ".eslintrc.js",
                ".eslintrc.cjs",
                ".eslintrc.json",
                ".eslintrc.yaml",
                ".eslintrc.yml",
              }, { path = vim.fn.expand("%:p"), upward = true }))
          end,
        }),
        -- fmt.gofmt.with({
        --   condition = function()
        --     return util.executable("gofmt", true)
        --   end,
        -- }),
        fmt.goimports_reviser.with({
          condition = function()
            return util.executable("goimports-reviser", true)
              and not vim.tbl_isempty(vim.fs.find("go.mod", {
                path = vim.fn.expand("%:p"),
                upward = true,
              }))
          end,
        }),
        fmt.isort.with({
          condition = function()
            return util.executable("isort", true)
          end,
        }),
        fmt.nginx_beautifier.with({
          condition = function()
            return util.executable("nginxbeautifier", true)
          end,
        }),
        fmt.pg_format.with({
          condition = function()
            return util.executable("pg_format", true)
          end,
        }),
        fmt.prettierd.with({
          filetypes = { "graphql", "html", "json", "markdown", "yaml" },
          condition = function()
            return util.executable("prettierd", true)
          end,
        }),
        fmt.ruff.with({
          condition = function()
            return util.executable("ruff", true)
          end,
        }),
        fmt.rustfmt.with({
          condition = function()
            return util.executable("rustfmt", true)
          end,
        }),
        fmt.shfmt.with({
          condition = function()
            return util.executable("shfmt", true)
          end,
        }),
        fmt.sqlfluff.with({
          condition = function()
            return util.executable("sqlfluff", true)
          end,
        }),
        fmt.stylua.with({
          condition = function()
            return util.executable("stylua", true)
              and not vim.tbl_isempty(
                vim.fs.find({ ".stylua.toml", "stylua.toml" }, { path = vim.fn.expand("%:p"), upward = true })
              )
          end,
        }),
        -- fmt.uncrustify.with({
        --   condition = function()
        --     return util.executable("uncrustify", true)
        --   end,
        -- }),
        fmt.zigfmt.with({
          condition = function()
            return util.executable("zig", true)
          end,
        }),

        --  ╭─────────────╮
        --  │ Diagnostics │
        --  ╰─────────────╯
        dgn.ansiblelint.with({
          condition = function()
            return util.executable("ansible-lint", true)
          end,
        }),
        dgn.buf.with({
          condition = function()
            return util.executable("buf", true)
          end,
        }),
        -- dgn.deno_lint.with({
        --   condition = function()
        --     return util.executable("deno", true)
        --   end,
        -- }),
        dgn.eslint_d.with({
          condition = function()
            return util.executable("eslint_d", true)
              and not vim.tbl_isempty(vim.fs.find({
                ".eslintrc",
                ".eslintrc.js",
                ".eslintrc.cjs",
                ".eslintrc.json",
                ".eslintrc.yaml",
                ".eslintrc.yml",
              }, { path = vim.fn.expand("%:p"), upward = true }))
          end,
        }),
        dgn.gitlint.with({
          condition = function()
            return util.executable("gitlint", true)
          end,
        }),
        -- dgn.golangci_lint.with({
        --   condition = function()
        --     return util.executable("golangci-lint", true)
        --       and not vim.tbl_isempty(vim.fs.find("go.mod", {
        --         path = vim.fn.expand("%:p"),
        --         upward = true,
        --       }))
        --   end,
        -- }),
        dgn.markdownlint.with({
          condition = function()
            return util.executable("markdownlint", true)
          end,
        }),
        dgn.protolint.with({
          condition = function()
            return util.executable("protolint", true)
          end,
        }),
        dgn.ruff.with({
          condition = function()
            return util.executable("ruff", true)
          end,
        }),
        -- dgn.shellcheck.with({
        --   condition = function()
        --     return util.executable("shellcheck", true)
        --   end,
        -- }),
        dgn.selene.with({
          condition = function(utils)
            return utils.root_has_file({ "selene.toml" }) and util.executable("selene", true)
          end,
        }),
        dgn.sqlfluff.with({
          condition = function()
            return util.executable("sqlfluff", true)
          end,
        }),
        dgn.tsc.with({
          condition = function()
            return util.executable("tsc", true)
          end,
        }),
        dgn.write_good.with({
          condition = function()
            return util.executable("write-good", true)
          end,
        }),
        dgn.zsh,

        --  ╭──────────────╮
        --  │ Code Actions │
        --  ╰──────────────╯
        cda.eslint_d.with({
          condition = function()
            return util.executable("eslint_d", true)
              and not vim.tbl_isempty(vim.fs.find({
                ".eslintrc",
                ".eslintrc.js",
                ".eslintrc.cjs",
                ".eslintrc.json",
                ".eslintrc.yaml",
                ".eslintrc.yml",
              }, { path = vim.fn.expand("%:p"), upward = true }))
          end,
        }),
        cda.gitrebase,
        -- cda.shellcheck.with({
        --   condition = function()
        --     return util.executable("shellcheck", true)
        --   end,
        -- }),
      })
    end,
  },

  -- inlay hints
  {
    "lvimuser/lsp-inlayhints.nvim",
    branch = "anticonceal",
    event = "LspAttach",
    opts = {},
    config = function(_, opts)
      require("lsp-inlayhints").setup(opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          -- Ignore grammar.js files
          if args.file:match("grammar.js$") then
            return
          end

          ---@type lsp.Client
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          -- Ignore these, they provide inlay hints already
          local ignore_lsps = {
            "clangd",
            "gopls",
            "rust_analyzer",
          }

          if vim.tbl_contains(ignore_lsps, client.name) then
            return
          end

          require("lsp-inlayhints").on_attach(client, args.buf, false)
        end,
      })
    end,
  },
}
