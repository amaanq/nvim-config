-- vim: ft=lua tw=80

stds.nvim = {
  read_globals = { "jit" },
}
std = "lua51+nvim"

-- Don't report unused self arguments of methods.
self = false

-- Rerun tests only if their modification time changed.
cache = true

ignore = {
  "613", -- trailing whitespace in a string
  "631", -- max_line_length
  "212/_.*", -- unused argument, for vars with "_" prefix
  "121", -- setting read-only global variable 'vim'
  "122", -- setting read-only field of global variable 'vim'
}

-- Global objects defined by the C code
read_globals = {
  "vim",
}

globals = {
  "dd",
  "vim.g",
  "vim.b",
  "vim.w",
  "vim.o",
  "vim.bo",
  "vim.wo",
  "vim.go",
  "vim.env",
}
