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
    local file = vim.uv.fs_realpath(event.match) or event.match

    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

-- Set indent level for certain filetypes
vim.api.nvim_create_autocmd({ "FileType", "BufRead", "BufNewFile" }, {
  pattern = { "firrtl", "lua", "javascript", "typescript", "typescriptreact", "text", "query", "systemverilog", "norg" },
  callback = function(args)
    -- ignore frida scripts
    if args.filetype == "javascript" and vim.fn.expand("%:e") == "so" then
      return
    end
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufRead", "BufNewFile" }, {
  pattern = { "markdown" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufRead", "BufNewFile" }, {
  pattern = { "test" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
    vim.wo.conceallevel = 0
  end,
})

-- Set commentstring for certain filetypes
vim.api.nvim_create_autocmd({ "FileType", "BufRead" }, {
  pattern = { "cs" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

-- Tree-Sitter highlighting for filetypes not autodetected
vim.filetype.add({
  extension = {
    nasm = "nasm",
    qmljs = "qmljs",
    pp = "puppet",
    objdump = "objdump",
    gn = "gn",
    gni = "gn",
    tv = "testvector",
    slint = "slint",
  },
  pattern = {
    [".*.js.so"] = "javascript",
  },
})

-- close dap-float with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "dap-float",
    "httpResult",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close Window" })
  end,
})

-- close dap-terminal with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "dap-terminal",
  },
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>bdelete!<cr>", { buffer = event.buf, silent = true, desc = "Close Dap Terminal" })
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   callback = function()
--     local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
--     if lang and pcall(vim.treesitter.language.add, lang) then
--       -- vim.treesitter.start()  -- sync
--       vim.treesitter.start(nil, nil, { timeout = 1 }) -- async
--     end
--   end,
-- })

-- Disable diagnostics in a .env file
vim.api.nvim_create_autocmd("BufRead", {
  pattern = ".env",
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- Disable tree-sitter for files over 1MB in size
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*",
  callback = function()
    local size = vim.fn.getfsize(vim.fn.expand("%:p"))
    if size > 500000 then
      -- vim.treesitter.stop()
    end
  end,
})
