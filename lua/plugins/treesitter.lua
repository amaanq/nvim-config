return {
	{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

	{
		"mfussenegger/nvim-treehopper",
		keys = { { "m", mode = { "o", "x" } } },
		config = function()
			vim.cmd([[
				omap     <silent> m :<C-U>lua require('tsht').nodes()<cr>
				xnoremap <silent> m :lua require('tsht').nodes()<cr>
			]])
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		config = true,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		-- dependencies = { "HiPhish/nvim-ts-rainbow2" },
		--- @type TSConfig
		opts = {
			ensure_installed = {
				"cmake",
				-- "comment",
				"diff",
				"dockerfile",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"git_rebase",
				"graphql",
				"haskell",
				"help",
				"http",
				"json",
				"jsonc",
				"json5",
				"kotlin",
				"latex",
				"lua",
				"markdown",
				"markdown_inline",
				"make",
				"meson",
				"ninja",
				"nix",
				"norg",
				"org",
				"php",
				"proto",
				"python",
				"query",
				"regex",
				"scss",
				"sql",
				"teal",
				"tsx",
				"vala",
				"vhs",
				"vim",
				"vue",
				"wgsl",
				"yaml",
				"zig",
			},
			autopairs = { enable = true },
			highlight = { enable = true },
			matchup = {
				enable = true,
			},
			playground = {
				enable = true,
				persist_queries = true, -- Whether the query persists across vim sessions
			},
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
			rainbow = {
				enable = true,
				disable = { "lua" },
			},
			refactor = {
				smart_rename = {
					enable = true,
					client = {
						smart_rename = "<leader>cr",
					},
				},
				navigation = {
					enable = true,
					keymaps = {
						-- goto_definition = "gd",
						-- list_definitions = "gnD",
						-- list_definitions_toc = "gO",
						-- goto_next_usage = "<a-*>",
						-- goto_previous_usage = "<a-#>",
					},
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
					goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
					goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
					goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
				},
				lsp_interop = {
					enable = true,
					peek_definition_code = {
						["gD"] = "@function.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
			textsubjects = {
				enable = true,
				keymaps = {
					["."] = "textsubjects-smart",
					[";"] = "textsubjects-container-outer",
				},
			},
		},
	},
}
