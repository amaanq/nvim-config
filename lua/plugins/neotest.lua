local M = {
	"nvim-neotest/neotest",
	event = "BufEnter",
	dependencies = {
		"nvim-neotest/neotest-go",
		"mrcjkb/neotest-haskell",
		"haydenmeade/neotest-jest",
		"nvim-neotest/neotest-plenary",
		"nvim-neotest/neotest-python",
		"rouge8/neotest-rust",
	},
}

function M.config()
	-- get neotest namespace (api call creates or returns namespace)
	local neotest_ns = vim.api.nvim_create_namespace("neotest")
	vim.diagnostic.config({
		virtual_text = {
			format = function(diagnostic)
				local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
				return message
			end,
		},
	}, neotest_ns)
	require("neotest").setup({
		adapters = {
			require("neotest-go"),
			require("neotest-haskell"),
			require("neotest-jest"),
			require("neotest-plenary"),
			require("neotest-python")({
				dap = { justMyCode = false },
			}),
			require("neotest-rust"),
		},
	})
end

return M
