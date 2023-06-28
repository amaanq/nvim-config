local util = require("util")

-- Disable semantic tokens for objc temporarily
-- vim.api.nvim_create_autocmd({ "LspAttach" }, {
--   callback = function(args)
--     ---@type lsp.Client
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     -- check if file is objc
--     if vim.fn.expand("%:e") == "m" then
--       client.server_capabilities.semanticTokensProvider = nil
--     end
--   end,
-- })

return {

  -- Add C/C++ to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        util.list_insert_unique(opts.ensure_installed, { "c", "cpp" })
      end
    end,
  },

  -- Correctly setup lspconfig for clangd 🚀
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "p00f/clangd_extensions.nvim",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
      },
    },
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(
              "compile_commands.json",
              "compile_flags.txt",
              "configure.ac",
              ".git"
            )(...)
          end,
        },
      },
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
          opts.cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          }
          opts.init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          }
          require("clangd_extensions").setup({
            server = opts,
            extensions = {
              inlay_hints = {
                inline = false,
              },
              ast = {
                --These require codicons (https://github.com/microsoft/vscode-codicons)
                role_icons = {
                  type = "",
                  declaration = "",
                  expression = "",
                  specifier = "",
                  statement = "",
                  ["template argument"] = "",
                },
                kind_icons = {
                  Compound = "",
                  Recovery = "",
                  TranslationUnit = "",
                  PackExpansion = "",
                  TemplateTypeParm = "",
                  TemplateTemplateParm = "",
                  TemplateParamObject = "",
                },
              },
            },
          })
          return true
        end,
      },
    },
  },
}
