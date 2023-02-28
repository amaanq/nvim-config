--  ╭──────────────────────────────────────────────────────────────────────────────╮
--  │           Autocmds are automatically loaded on the VeryLazy event            │
--  │                    Default autocmds that are always set:                     │
--  │ https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua │
--  ╰──────────────────────────────────────────────────────────────────────────────╯

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	callback = function()
		local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
		if ok and cl then
			vim.wo.cursorline = true
			vim.api.nvim_win_del_var(0, "auto-cursorline")
		end
	end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	callback = function()
		local cl = vim.wo.cursorline
		if cl then
			vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
			vim.wo.cursorline = false
		end
	end,
})

-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
	callback = function(event)
		local file = vim.loop.fs_realpath(event.match) or event.match

		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
		local backup = vim.fn.fnamemodify(file, ":p:~:h")
		backup = backup:gsub("[/\\]", "%%")
		vim.go.backupext = backup
	end,
})

-- Fix conceallevel for json & help files
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "json", "jsonc" },
	callback = function()
		vim.wo.spell = false
		vim.wo.conceallevel = 0
	end,
})

-- Set indent level for certain filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "lua", "query", "javascript", "typescript" },
	callback = function()
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
		vim.bo.expandtab = true
	end,
})

-- Tree-Sitter highlighting for filetypes not autodetected
vim.filetype.add({
	extension = {},
})

-- close dap-float with <q>
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"dap-float",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close Dap Float" })
	end,
})

-- close dap-terminal with <q>
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"dap-terminal",
	},
	callback = function(event)
		vim.keymap.set(
			"n",
			"q",
			"<cmd>bdelete!<cr>",
			{ buffer = event.buf, silent = true, desc = "Close Dap Terminal" }
		)
	end,
})

-- Disable diagnostics in a .env file
vim.cmd([[
  augroup _env
   autocmd!
   autocmd BufEnter .env lua vim.diagnostic.disable(0)
  augroup end
]])
