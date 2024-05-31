-- selene: allow(global_usage)

-- selene: allow(global_usage)
_G.profile = function(cmd, times, flush)
  times = times or 100
  local start = vim.uv.hrtime()
  for _ = 1, times, 1 do
    if flush then
      jit.flush(cmd, true)
    end
    cmd()
  end
  print(((vim.uv.hrtime() - start) / 1e6 / times) .. "ms")
end

local M = {}

---@param cmd string command to execute
---@param warn? string|boolean if vim.fn.executable <= 0 then warn with warn
function M.executable(cmd, warn)
  if vim.fn.executable(cmd) > 0 then
    return true
  end
  if warn then
    local message = type(warn) == "string" and warn or ("Command `%s` was not executable"):format(cmd)
    vim.notify(message, vim.log.levels.WARN, { title = "Executable not found" })
  end
  return false
end

---@class CommandArgs
---@field args string
---@field fargs table
---@field bang boolean

---Create an nvim command
---@param name any
---@param rhs string|fun(args: CommandArgs)
---@param opts table?
function M.command(name, rhs, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, rhs, opts)
end

---@param fname string
---@return string|boolean
function M.exists(fname)
  local stat = vim.uv.fs_stat(fname)
  return (stat and stat.type) or false
end

---@param is_file? boolean
function M.test(is_file)
  local file = is_file and vim.fn.expand("%:p") or "./tests"
  local init = vim.fn.glob("tests/*init*")
  require("plenary.test_harness").test_directory(file, { minimal_init = init, sequential = true })
end

function M.version()
  local v = vim.version() ---@type table
  if v and not v.prerelease then
    vim.notify(
      ("Neovim v%d.%d.%d"):format(v.major, v.minor, v.patch),
      vim.log.levels.WARN,
      { title = "Neovim: not running nightly!" }
    )
  end
end

function M.cowboy()
  ---@type table?
  local id
  local ok = true
  for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
    local count = 0
    local timer = assert(vim.uv.new_timer())
    local map = key
    vim.keymap.set("n", key, function()
      if vim.v.count > 0 then
        count = 0
      end
      if count >= 10 and vim.bo.buftype ~= "nofile" and vim.bo.buftype ~= "terminal" then
        ok, id = pcall(vim.notify, "Hold it Cowboy!", vim.log.levels.WARN, {
          icon = "🤠",
          replace = id,
          keep = function()
            return count >= 10
          end,
        })
        if not ok then
          id = nil
          return map
        end
      else
        count = count + 1
        timer:start(2000, 0, function()
          count = 0
        end)
        return map
      end
    end, { expr = true, silent = true })
  end
end

function M.colorize()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.statuscolumn = ""
  vim.wo.signcolumn = "no"
  vim.opt.listchars = { space = " " }

  local buf = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  while #lines > 0 and vim.trim(lines[#lines]) == "" do
    lines[#lines] = nil
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  vim.b[buf].minianimate_disable = true

  vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))
  vim.keymap.set("n", "q", "<cmd>qa!<cr>", { silent = true, buffer = buf })
  vim.api.nvim_create_autocmd("TextChanged", { buffer = buf, command = "normal! G$" })
  vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })

  vim.defer_fn(function()
    vim.b[buf].minianimate_disable = false
  end, 2000)
end

return M
