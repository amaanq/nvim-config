local util = require("util")

return {

	-- Add Go & related to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				util.list_insert_unique(opts.ensure_installed, { "go", "gomod", "gosum", "gowork" })
			end
		end,
	},

	-- Ensure Go LSP, linter, and imports reviser are installed
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				util.list_insert_unique(opts.ensure_installed, "goimports-reviser")
			end
		end,
	},

	{
		"jay-babu/mason-null-ls.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				util.list_insert_unique(opts.ensure_installed, { "gomodifytags", "gofumpt", "iferr", "impl" })
			end
		end,
	},

	{
		"leoluz/nvim-dap-go",
		dependencies = {
			"mfussenegger/nvim-dap",
			{
				"jay-babu/mason-nvim-dap.nvim",
				opts = function(_, opts)
					if type(opts.ensure_installed) == "table" then
						util.list_insert_unique(opts.ensure_installed, "delve")
					end
				end,
			},
		},
		ft = "go",
		config = true,
	},

	-- Correctly setup lspconfig for Go 🚀
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Ensure mason installs the server
				golangci_lint_ls = {},
				gopls = {},
			},
			settings = {
				golangci_lint_ls = {},
				gopls = {
					gofumpt = true,
					codelenses = {
						gc_details = false,
						generate = true,
						regenerate_cgo = true,
						run_govulncheck = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						vendor = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					analyses = {
						fieldalignment = true,
						nilness = true,
						unusedparams = true,
						unusedwrite = true,
						useany = true,
					},
					usePlaceholders = true,
					completeUnimported = true,
					staticcheck = true,
					directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
					semanticTokens = true,
				},
			},
		},
	},

	-- Add go.nvim
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = true,
		event = "CmdlineEnter",
		ft = { "go", "gomod", "gosum", "gowork" },
	},

	-- Add gopher.nvim
	{
		"olexsmir/gopher.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		config = true,
	},
}
