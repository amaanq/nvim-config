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
		dependencies = { "HiPhish/nvim-ts-rainbow2" },
		--- @type TSConfig
		opts = {
			ensure_installed = {
				"capnp",
				"cmake",
				-- "comment", -- comments are slowing down TS bigtime, so disable for now
				"diff",
				"dockerfile",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"git_rebase",
				"graphql",
				"haskell",
				"http",
				"kotlin",
				"latex",
				"make",
				"meson",
				"ninja",
				"nix",
				"norg",
				"org",
				"php",
				"proto",
				"smali",
				"sql",
				"teal",
				"vala",
				"vhs",
				"vue",
				"zig",
			},
			autopairs = { enable = true },
			playground = {
				enable = true,
				disable = {},
				updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
				persist_queries = true, -- Whether the query persists across vim sessions
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
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
