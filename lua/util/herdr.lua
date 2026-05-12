-- Reports embedded-terminal tails to herdr.
local M = {}

local uv = vim.uv or vim.loop

local INTERVAL_MS = 1000
local TAIL_LINES = 40

local terminals = {} ---@type table<number, {pid: number, last_text?: string, last_title?: string}>
local timer ---@type uv.uv_timer_t?
local seq = 0

local function enabled()
  return vim.env.HERDR_ENV == "1" and vim.env.HERDR_PANE_ID ~= nil and vim.env.HERDR_SOCKET_PATH ~= nil
end

-- herdr's API socket serves one request per connection
local function send(line)
  local pipe = uv.new_pipe(false)
  if not pipe then
    return
  end
  pipe:connect(vim.env.HERDR_SOCKET_PATH, function(err)
    if err then
      pipe:close()
      return
    end
    pipe:write(line .. "\n", function()
      pipe:read_start(function()
        if not pipe:is_closing() then
          pipe:close()
        end
      end)
    end)
  end)
end

local function report(params)
  seq = seq + 1
  local ok, line = pcall(vim.json.encode, {
    id = ("nvim-herdr:%d:%d"):format(vim.fn.getpid(), seq),
    method = "pane.report_nested_terminal",
    params = params,
  })
  if ok then
    send(line)
  end
end

local function report_closed(pid)
  report({ pane_id = vim.env.HERDR_PANE_ID, pid = pid, closed = true })
end

local function tick()
  for buf, entry in pairs(terminals) do
    if not vim.api.nvim_buf_is_valid(buf) then
      terminals[buf] = nil
      report_closed(entry.pid)
    else
      local lines = vim.api.nvim_buf_get_lines(buf, -(TAIL_LINES + 1), -1, false)
      local text = table.concat(lines, "\n")
      local title = vim.b[buf].term_title or ""
      local params = { pane_id = vim.env.HERDR_PANE_ID, pid = entry.pid }
      if text == entry.last_text and title == entry.last_title then
        -- heartbeat
        params.changed = false
      else
        entry.last_text = text
        entry.last_title = title
        params.text = text
        params.title = title
      end
      report(params)
    end
  end
  if next(terminals) == nil and timer then
    timer:stop()
  end
end

local function track(buf)
  local pid = vim.b[buf].terminal_job_pid
  if type(pid) ~= "number" or pid <= 0 then
    return
  end
  terminals[buf] = { pid = pid }
  if not timer then
    timer = uv.new_timer()
  end
  if timer and not timer:is_active() then
    timer:start(INTERVAL_MS, INTERVAL_MS, vim.schedule_wrap(tick))
  end
end

function M.setup()
  if not enabled() then
    return
  end

  local group = vim.api.nvim_create_augroup("herdr_nested_agents", { clear = true })

  vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    callback = function(args)
      track(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("TermClose", {
    group = group,
    callback = function(args)
      local entry = terminals[args.buf]
      if entry then
        terminals[args.buf] = nil
        report_closed(entry.pid)
      end
    end,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      for _, entry in pairs(terminals) do
        report_closed(entry.pid)
      end
      terminals = {}
    end,
  })

  -- adopt terminals opened before setup ran
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
      track(buf)
    end
  end
end

return M
