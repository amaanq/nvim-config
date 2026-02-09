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
  pattern = {
    "firrtl",
    "lua",
    "javascript",
    "typescript",
    "typescriptreact",
    "text",
    "query",
    "systemverilog",
    "norg",
    "nix",
  },
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
    [".*/%.cache/go%-build/.*"] = "go",
    [".*.c.inc"] = "c",
    [".*.h.inc"] = "c",
  },
})
vim.treesitter.language.register("fasm", { "asm" })

-- Respond to OSC 4 (palette color queries) and OSC 10/11 (fg/bg queries)
-- in :terminal so apps like OpenCode can detect the actual colorscheme.
--
-- Neovim's default TermRequest handler (in nvim.terminal augroup) returns
-- white/black for OSC 10/11 and ignores OSC 4 entirely. We delete the
-- default OSC handler and replace it with one that returns real colors.
--
-- NOTE: returning true from an autocmd callback *deletes the autocmd* (oneshot),
-- it does NOT stop other callbacks from running. So we must never return true.
do
  -- Delete the default OSC 10/11 handler from nvim.terminal augroup so it
  -- doesn't send wrong (white/black) responses before our handler runs.
  local ok, aus = pcall(vim.api.nvim_get_autocmds, {
    group = "nvim.terminal",
    event = "TermRequest",
  })
  if ok then
    for _, au in ipairs(aus) do
      if au.desc and au.desc:match("OSC foreground/background") then
        vim.api.nvim_del_autocmd(au.id)
      end
    end
  end

  local function hex_to_osc_rgb(hex)
    if not hex then
      return nil
    end
    local r, g, b = hex:match("^#(%x%x)(%x%x)(%x%x)$")
    if not r then
      return nil
    end
    -- Scale 8-bit (00-ff) to 16-bit (0000-ffff) by repeating: 0xAB -> 0xABAB
    return string.format(
      "rgb:%02x%02x/%02x%02x/%02x%02x",
      tonumber(r, 16),
      tonumber(r, 16),
      tonumber(g, 16),
      tonumber(g, 16),
      tonumber(b, 16),
      tonumber(b, 16)
    )
  end

  -- Get the actual Normal highlight bg/fg colors from the colorscheme
  local function get_hl_hex(group, attr)
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    local val = hl[attr]
    if val then
      return string.format("#%06x", val)
    end
    return nil
  end

  vim.api.nvim_create_autocmd("TermRequest", {
    desc = "Handle OSC 4/10/11 color queries with actual colorscheme colors",
    callback = function(args)
      local channel = vim.bo[args.buf].channel
      if channel == 0 then
        return
      end

      local seq = args.data.sequence
      local term = args.data.terminator

      -- OSC 4;<index>;? — palette color query
      local idx = seq:match("^\027%]4;(%d+);%?$")
      if idx then
        idx = tonumber(idx)
        if idx and idx >= 0 and idx <= 15 then
          local color = vim.g["terminal_color_" .. idx]
          local rgb = hex_to_osc_rgb(color)
          if rgb then
            vim.api.nvim_chan_send(channel, string.format("\027]4;%d;%s%s", idx, rgb, term))
          end
        end
        return
      end

      -- OSC 10;? / OSC 11;? — fg/bg color query
      local fg_request = seq == "\027]10;?"
      local bg_request = seq == "\027]11;?"
      if fg_request or bg_request then
        local hex
        if fg_request then
          hex = get_hl_hex("Normal", "fg")
        else
          hex = get_hl_hex("Normal", "bg")
        end
        local rgb = hex_to_osc_rgb(hex)
        if rgb then
          local cmd = fg_request and 10 or 11
          vim.api.nvim_chan_send(channel, string.format("\027]%d;%s%s", cmd, rgb, term))
        end
        return
      end
    end,
  })
end

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

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    local parsers = require("nvim-treesitter.parsers")
    ---@diagnostic disable-next-line: missing-fields
    parsers.test = {
      ---@diagnostic disable-next-line: missing-fields
      install_info = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-test",
        revision = "76b419f178da018c29d3004fcbf14f755649eb58",
      },
    }
    ---@diagnostic disable-next-line: missing-fields
    parsers.fasm = {
      ---@diagnostic disable-next-line: missing-fields
      install_info = {
        path = "~/projects/treesitter/tree-sitter-fasm",
        queries = "queries",
      },
    }
  end,
})
