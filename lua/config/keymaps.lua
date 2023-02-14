-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local util = require("util")

-- util.cowboy()

local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	---@cast keys LazyKeysHandler
	-- do not create the keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

-- Move to window using the movement keys
vim.keymap.set("n", "<left>", "<C-w>h")
vim.keymap.set("n", "<down>", "<C-w>j")
vim.keymap.set("n", "<up>", "<C-w>k")
vim.keymap.set("n", "<right>", "<C-w>l")

-- change word with <c-c>
vim.keymap.set("n", "<C-c>", "<cmd>normal! ciw<cr>a")

-- plenary testing
vim.keymap.set("n", "<leader>tt", function()
	util.test(true)
end, { desc = "Test File" })
vim.keymap.set("n", "<leader>tT", function()
	util.test()
end, { desc = "Test All Files" })

-- run lua
vim.keymap.set("n", "<leader>cR", util.runlua, { desc = "Run Lua" })

-- terminal
map("n", "<leader>1", "<cmd>1ToggleTerm<cr>", { desc = "ToggleTerm 1" })
map("n", "<leader>2", "<cmd>2ToggleTerm<cr>", { desc = "ToggleTerm 2" })
map("n", "<leader>3", "<cmd>3ToggleTerm<cr>", { desc = "ToggleTerm 3" })
map("n", "<leader>4", "<cmd>4ToggleTerm<cr>", { desc = "ToggleTerm 4" })
map("n", "<leader>5", "<cmd>5ToggleTerm<cr>", { desc = "ToggleTerm 5" })

------------------------------------------------------------------------------
-- Credit: June Gunn <Leader>?/! | Google it / Feeling lucky
------------------------------------------------------------------------------
---@param pat string
---@param lucky boolean
local function google(pat, lucky)
	local query = '"' .. vim.fn.substitute(pat, '["\n]', " ", "g") .. '"'
	query = vim.fn.substitute(query, "[[:punct:] ]", [[\=printf("%%%02X", char2nr(submatch(0)))]], "g")
	vim.fn.system(
		vim.fn.printf(vim.g.open_command .. ' "https://www.google.com/search?%sq=%s"', lucky and "btnI&" or "", query)
	)
end

vim.keymap.set("n", "<leader>?", function()
	google(vim.fn.expand("<cWORD>"), false)
end, { desc = "Google" })

vim.keymap.set("n", "<leader>!", function()
	google(vim.fn.expand("<cWORD>"), true)
end, { desc = "Google (Lucky)" })

vim.keymap.set("x", "<leader>?", function()
	google(vim.fn.getreg("g"), false)
end, { desc = "Google" })

vim.keymap.set("x", "<leader>!", function()
	google(vim.fn.getreg("g"), true)
end, { desc = "Google (Lucky)" })

---@param path string
local function open(path)
	vim.fn.jobstart({ vim.g.open_command, path }, { detach = true })
	vim.notify(string.format("Opening %s", path))
end
-----------------------------------------------------------------------------//
-- GX - replicate netrw functionality
-----------------------------------------------------------------------------//
local function open_link()
	local file = vim.fn.expand("<cfile>")
	if not file or vim.fn.isdirectory(file) > 0 then
		return vim.cmd.edit(file)
	end

	if file:match("http[s]?://") then
		return open(file)
	end

	-- consider anything that looks like string/string a github link
	local plugin_url_regex = "[%a%d%-%.%_]*%/[%a%d%-%.%_]*"
	local link = string.match(file, plugin_url_regex)
	if link then
		return open(string.format("https://www.github.com/%s", link))
	end
end

vim.keymap.set("n", "gx", open_link, { desc = "Open Link" })
vim.keymap.set("n", "gf", "<Cmd>e <cfile><CR>", { desc = "Open File" })

-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
util.command("ToggleBackground", function()
	vim.o.background = vim.o.background == "dark" and "light" or "dark"
end)
