return {

	-- better text objects
	{
		"echasnovski/mini.ai",
		keys = { { "[f", desc = "Prev function" }, { "]f", desc = "Next function" } },
		opts = function(plugin)
			-- call config of parent spec
			plugin._.super.config()

			-- add treesitter jumping
			local function jump(capture, start, down)
				local rhs = function()
					local parser = vim.treesitter.get_parser()
					if not parser then
						return vim.notify("No treesitter parser for the current buffer", vim.log.levels.ERROR)
					end

					local query = vim.treesitter.get_query(vim.bo.filetype, "textobjects")
					if not query then
						return vim.notify("No textobjects query for the current buffer", vim.log.levels.ERROR)
					end

					local cursor = vim.api.nvim_win_get_cursor(0)

					---@type {[1]:number, [2]:number}[]
					local locs = {}
					for _, tree in ipairs(parser:trees()) do
						for capture_id, node, _ in query:iter_captures(tree:root(), 0) do
							if query.captures[capture_id] == capture then
								local range = { node:range() } ---@type number[]
								local row = (start and range[1] or range[3]) + 1
								local col = (start and range[2] or range[4]) + 1
								if down and row > cursor[1] or (not down) and row < cursor[1] then
									table.insert(locs, { row, col })
								end
							end
						end
					end
					return pcall(vim.api.nvim_win_set_cursor, 0, down and locs[1] or locs[#locs])
				end

				local c = capture:sub(1, 1):lower()
				local lhs = (down and "]" or "[") .. (start and c or c:upper())
				local desc = (down and "Next " or "Prev ")
					.. (start and "start" or "end")
					.. " of "
					.. capture:gsub("%..*", "")
				vim.keymap.set("n", lhs, rhs, { desc = desc })
			end

			for _, capture in ipairs({ "function.outer", "class.outer" }) do
				for _, start in ipairs({ true, false }) do
					for _, down in ipairs({ true, false }) do
						jump(capture, start, down)
					end
				end
			end
		end,
	},

	{
		"danymat/neogen",
		keys = {
			{
				"<leader>cc",
				function()
					require("neogen").generate({})
				end,
				desc = "Neogen Comment",
			},
		},
		opts = { snippet_engine = "luasnip" },
	},

	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},

	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<leader>r",
				function()
					require("refactoring").select_refactor()
				end,
				mode = "v",
				noremap = true,
				silent = true,
				expr = false,
			},
		},
		opts = {},
	},

	-- better yank/paste
	{
		"kkharji/sqlite.lua",
		enabled = function()
			return not jit.os:find("Windows")
		end,
	},
	{
		"gbprod/yanky.nvim",
		enabled = true,
		event = "BufReadPost",
		config = function()
			-- vim.g.clipboard = {
			--   name = "xsel_override",
			--   copy = {
			--     ["+"] = "xsel --input --clipboard",
			--     ["*"] = "xsel --input --primary",
			--   },
			--   paste = {
			--     ["+"] = "xsel --output --clipboard",
			--     ["*"] = "xsel --output --primary",
			--   },
			--   cache_enabled = 1,
			-- }

			require("yanky").setup({
				highlight = {
					timer = 150,
				},
				ring = {
					storage = jit.os:find("Windows") and "shada" or "sqlite",
				},
			})

			vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")

			vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
			vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
			vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
			vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

			vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
			vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

			vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
			vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
			vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
			vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

			vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
			vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
			vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
			vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

			vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
			vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")

			vim.keymap.set("n", "<leader>P", function()
				require("telescope").extensions.yank_history.yank_history({})
			end, { desc = "Paste from Yanky" })
		end,
	},

	-- better increase/descrease
	{
		"monaqa/dial.nvim",
		event = "VeryLazy",
		-- splutylua: ignore
		keys = {
			{
				"<C-a>",
				function()
					return require("dial.map").inc_normal()
				end,
				expr = true,
				desc = "Increment",
			},
			{
				"<C-x>",
				function()
					return require("dial.map").dec_normal()
				end,
				expr = true,
				desc = "Decrement",
			},
		},
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool,
					augend.semver.alias.semver,
				},
			})
		end,
	},

	{
		"simrat39/symbols-outline.nvim",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		config = function()
			local icons = require("lazyvim.config").icons
			require("symbols-outline").setup({
				symbols = {
					File = { icon = icons.kinds.File, hl = "TSURI" },
					Module = { icon = icons.kinds.Module, hl = "TSNamespace" },
					Namespace = { icon = icons.kinds.Namespace, hl = "TSNamespace" },
					Package = { icon = icons.kinds.Package, hl = "TSNamespace" },
					Class = { icon = icons.kinds.Class, hl = "TSType" },
					Method = { icon = icons.kinds.Method, hl = "TSMethod" },
					Property = { icon = icons.kinds.Property, hl = "TSMethod" },
					Field = { icon = icons.kinds.Field, hl = "TSField" },
					Constructor = { icon = icons.kinds.Constructor, hl = "TSConstructor" },
					Enum = { icon = icons.kinds.Enum, hl = "TSType" },
					Interface = { icon = icons.kinds.Interface, hl = "TSType" },
					Function = { icon = icons.kinds.Function, hl = "TSFunction" },
					Variable = { icon = icons.kinds.Variable, hl = "TSConstant" },
					Constant = { icon = icons.kinds.Constant, hl = "TSConstant" },
					String = { icon = icons.kinds.String, hl = "TSString" },
					Number = { icon = icons.kinds.Number, hl = "TSNumber" },
					Boolean = { icon = icons.kinds.Boolean, hl = "TSBoolean" },
					Array = { icon = icons.kinds.Array, hl = "TSConstant" },
					Object = { icon = icons.kinds.Object, hl = "TSType" },
					Key = { icon = icons.kinds.Key, hl = "TSType" },
					Null = { icon = icons.kinds.Null, hl = "TSType" },
					EnumMember = { icon = icons.kinds.EnumMember, hl = "TSField" },
					Struct = { icon = icons.kinds.Struct, hl = "TSType" },
					Event = { icon = icons.kinds.Event, hl = "TSType" },
					Operator = { icon = icons.kinds.Operator, hl = "TSOperator" },
					TypeParameter = { icon = icons.kinds.TypeParameter, hl = "TSParameter" },
				},
			})
		end,
	},

	{
		"nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"jc-doyle/cmp-pandoc-references",
			-- "kdheepak/cmp-latex-symbols",
			"zbirenbaum/copilot-cmp",
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.sources = cmp.config.sources(vim.tbl_deep_extend("force", opts.sources, {
				{ name = "nvim_lsp", priority = 1000 },
				{ name = "luasnip", priority = 750 },
				{ name = "pandoc_references", priority = 725 },
				{ name = "emoji", priority = 700 },
				-- { name = "latex_symbols", priority = 700 },
				{ name = "calc", priority = 650 },
				{ name = "path", priority = 500 },
				{ name = "buffer", priority = 250 },
			}))
		end,
	},

	{
		"gorbit99/codewindow.nvim",
		enabled = false,
		event = "BufReadPre",
		keys = {
			-- stylua: ignore
			{ "<leader>um", function() require("codewindow").toggle_minimap() end, desc = "Toggle Minimap" },
		},
		config = function()
			-- require("as.highlights").plugin("codewindow", {
			-- 	{ CodewindowBorder = { link = "WinSeparator" } },
			-- 	{ CodewindowWarn = { bg = "NONE", fg = { from = "DiagnosticSignWarn", attr = "bg" } } },
			-- 	{ CodewindowError = { bg = "NONE", fg = { from = "DiagnosticSignError", attr = "bg" } } },
			-- })
			require("codewindow").setup({
				z_index = 25,
				auto_enable = true,
				exclude_filetypes = {
					"alpha",
					"dap-terminal",
					"git",
					"gitcommit",
					"help",
					"NeogitCommitMessage",
					"NeogitStatus",
					"neotest-summary",
					"neo-tree",
					"neo-tree-popup",
					"Outline",
					"qf",
				},
			})
		end,
	},

	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "UndoTree Toggle" } },
		config = function()
			vim.g.undotree_TreeNodeShape = "◦" -- Alternative: '◉'
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	},
}
