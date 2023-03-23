local util = require("util")

return {

  -- Extend auto completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "vuki656/package-info.nvim",
        event = { "BufRead package.json" },
        config = true,
      },
      {
        "David-Kunz/cmp-npm",
        event = { "BufRead package.json" },
        config = true,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "npm", keyword_length = 3, priority = 750 },
      }))
    end,
  },

  -- Add JavaScript & friends to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        util.list_insert_unique(opts.ensure_installed, { "css", "html", "javascript", "jsdoc", "scss" })
      end
    end,
  },

  -- Ensure CSS LSP, HTML LSP, and JS Debug Adapter are installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        util.list_insert_unique(opts.ensure_installed, { "css-lsp", "html-lsp", "js-debug-adapter" })
      end
    end,
  },

  -- Add debug plugin for JavaScript
  {
    "mxsdev/nvim-dap-vscode-js",
    event = "VeryLazy",
    config = function()
      local dap = require("dap")
      local dap_js = require("dap-vscode-js")
      local mason_registry = require("mason-registry")
      local js_debug_pkg = mason_registry.get_package("js-debug-adapter")
      local js_debug_path = js_debug_pkg:get_install_path()
      dap_js.setup({
        debugger_path = js_debug_path,
        adapters = { "pwa-node", "node-terminal" }, -- which adapters to register in nvim-dap
      })
      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (" .. language .. ")",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach (" .. language .. ")",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
