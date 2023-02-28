return {

	-- This is meant for tree-sitter development.
	{
		"nvim-treesitter",
		init = function()
			local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

			local local_configs = {
				thrift = {
					install_info = {
						url = "~/projects/treesitter/tree-sitter-thrift",
						files = { "src/parser.c" },
					},
				},
				capnp = {
					install_info = {
						url = "~/projects/treesitter/tree-sitter-capnp",
						files = { "src/parser.c" },
					},
				},
				smali = {
					install_info = {
						url = "~/projects/treesitter/tree-sitter-smali",
						files = { "src/parser.c" },
					},
				},
				kdl = {
					install_info = {
						url = "~/projects/treesitter/tree-sitter-kdl",
						files = { "src/parser.c", "src/scanner.c" },
					},
				},
				smithy = {
					install_info = {
						url = "~/projects/treesitter/tree-sitter-smithy",
						files = { "src/parser.c" },
					},
				},
				func = {
					install_info = {
						url = "~/projects/treesitter/tree-sitter-func",
						files = { "src/parser.c" },
					},
				},
				ungrammar = {
					install_info = {
						url = "~/projects/treesitter/tree-sitter-ungrammar",
						files = { "src/parser.c" },
					},
				},
				yuck = {
					install_info = {
						url = "~/projects/treesitter/tree-sitter-yuck",
						files = { "src/parser.c", "src/scanner.c" },
					},
				},
				bicep = {
					install_info = {
						url = "~/projects/treesitter/tree-sitter-bicep",
						files = { "src/parser.c" },
					},
				},
				dhall = {
					install_info = {
						url = "~/projects/treesitter/tree-sitter-dhall",
						files = { "src/parser.c" },
					},
				},
				cue = {
					install_info = {
						url = "~/projects/treesitter/tree-sitter-cue",
						files = { "src/parser.c", "src/scanner.c" },
					},
				},
			}

			for lang, install_info in pairs(local_configs) do
				parser_configs[lang] = install_info
			end
		end,
	},
}
