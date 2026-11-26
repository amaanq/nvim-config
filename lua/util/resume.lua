-- Reports nvim to the terminal over Program Resume (OSC 7577), so beer can
-- start it again with its persistence session after a server restart.
local M = {}

local RESUME_ARGV = { "nvim", '+lua require("persistence").load()' }
-- persistence only saves on VimLeavePre, which a hangup skips, so keep the
-- session fresh while editing.
local SAVE_DELAY_MS = 2000

local token ---@type string?

local function send(pairs)
  local body = ("pid=%d:time=%d:%s"):format(vim.fn.getpid(), os.time(), pairs)
  local mac = vim.fn.sha256(body .. ":" .. token)
  vim.api.nvim_ui_send(("\27]7577;%s:mac=%s\27\\"):format(body, mac))
end

local function report()
  local argv = vim.tbl_map(vim.base64.encode, RESUME_ARGV)
  send(("argv=%s:cwd=%s"):format(table.concat(argv, ","), vim.base64.encode(vim.fn.getcwd())))
end

function M.setup()
  token = vim.env.OSC7577_TOKEN
  if not token or token == "" then
    return
  end
  -- Children such as :terminal shells must not report as this nvim.
  vim.env.OSC7577_TOKEN = nil

  local group = vim.api.nvim_create_augroup("program_resume", { clear = true })
  local timer = assert(vim.uv.new_timer())
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "DirChanged" }, {
    group = group,
    callback = function()
      timer:stop()
      timer:start(
        SAVE_DELAY_MS,
        0,
        vim.schedule_wrap(function()
          require("persistence").save()
        end)
      )
    end,
  })
  vim.api.nvim_create_autocmd("DirChanged", { group = group, callback = report })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      send("clear=1")
    end,
  })
  report()
end

return M
