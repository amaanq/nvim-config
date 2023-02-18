return {

	-- add Go+more to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "go", "gomod", "gosum", "gowork" })
			end
		end,
	},

	-- correctly setup mason lsp / dap extensions
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "gopls", "golangci-lint", "goimports-reviser" })
			end
		end,
	},

	-- correctly setup lspconfig for Go
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- make sure mason installs the server
			servers = {
				golangci_lint_ls = {},
				gopls = {},
			},
		},
	},

	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = true,
		event = "CmdlineEnter",
		ft = { "go", "gomod" },
		build = '<cmd>lua require("go.install").update_all_sync()<cr>', -- if you need to install/update all binaries
	},

	{
		"olexsmir/gopher.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		config = true,
	},
}
