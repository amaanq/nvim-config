local debug = require("util.debug")

if vim.env.VIMCONFIG then
	return debug.switch(vim.env.VIMCONFIG)
end

-- require("util.profiler").start()

require("config.lazy")

-- require("util.dashboard").setup()

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("util").version()
	end,
})
