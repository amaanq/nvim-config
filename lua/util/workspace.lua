local M = {}

--- Detect the nearest workspace directory from the current buffer.
--- Walks up looking for a .git gitlink file (indicates a git worktree root).
--- Falls back to vim.fn.getcwd() if not inside a workspace.
---@param path? string file path to start from (default: current buffer)
---@return string workspace directory
function M.detect(path)
  path = path or vim.api.nvim_buf_get_name(0)
  if path == "" then
    return vim.fn.getcwd()
  end
  local dir = vim.fs.dirname(vim.fn.fnamemodify(path, ":p"))
  -- Look for a .git FILE (gitlink = worktree root), not a .git directory
  local found = vim.fs.find(".git", { path = dir, upward = true, type = "file" })
  if found[1] then
    return vim.fs.dirname(found[1])
  end
  -- Fall back to .git directory (normal non-worktree repo)
  found = vim.fs.find(".git", { path = dir, upward = true, type = "directory" })
  if found[1] then
    return vim.fs.dirname(found[1])
  end
  return vim.fn.getcwd()
end

--- Find the root directory containing all workspaces.
--- From a worktree, reads the gitlink to find the common git dir,
--- then returns its parent. From the root itself, returns cwd.
---@return string root directory
function M.root()
  local cwd = vim.fn.getcwd()
  -- Check if cwd itself is the root (has .git directory with worktrees/)
  local git_dir = cwd .. "/.git"
  local stat = vim.uv.fs_stat(git_dir)
  if stat and stat.type == "directory" then
    local wt = vim.uv.fs_stat(git_dir .. "/worktrees")
    if wt and wt.type == "directory" then
      return cwd
    end
  end
  -- Try detecting from current buffer's workspace
  local ws = M.detect()
  local gitlink = ws .. "/.git"
  stat = vim.uv.fs_stat(gitlink)
  if stat and stat.type == "file" then
    -- Read gitlink: "gitdir: /path/to/.git/worktrees/<name>"
    local line = vim.fn.readfile(gitlink, "", 1)[1] or ""
    local gitdir = line:match("^gitdir: (.+)$")
    if gitdir then
      -- .git/worktrees/<name> → go up 3 levels to get repo root
      return vim.fn.fnamemodify(gitdir, ":h:h:h")
    end
  end
  return cwd
end

--- List all workspace directories under the given root.
--- Finds subdirectories that contain a .git gitlink file (git worktrees).
---@param root_dir? string root directory (default: auto-detected)
---@return {text: string, file: string}[]
function M.list(root_dir)
  root_dir = root_dir or M.root()
  local items = {}
  local handle = vim.uv.fs_scandir(root_dir)
  if not handle then
    return items
  end
  while true do
    local name, ftype = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if ftype == "directory" and name:sub(1, 1) ~= "." then
      local git = root_dir .. "/" .. name .. "/.git"
      local s = vim.uv.fs_stat(git)
      if s and s.type == "file" then
        items[#items + 1] = { text = name, file = root_dir .. "/" .. name }
      end
    end
  end
  table.sort(items, function(a, b)
    return a.text < b.text
  end)
  return items
end

return M
