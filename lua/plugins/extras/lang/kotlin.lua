-- Extract source from a sources JAR given class name patterns
local function extract_from_sources_jar(sources_jar, class_name)
  -- Try different source file patterns
  local search_patterns = {
    class_name .. ".kt",
    class_name .. ".java",
    class_name:gsub("Kt$", "") .. ".kt", -- Kotlin file facades
  }

  for _, pattern in ipairs(search_patterns) do
    -- Find matching files in sources jar
    local find_cmd = string.format("unzip -l %q 2>/dev/null | grep -E '/%s$' | awk '{print $4}'", sources_jar, pattern)
    local handle = io.popen(find_cmd)
    if handle then
      local matches = handle:read("*a")
      handle:close()
      for match in matches:gmatch("[^\n]+") do
        -- Extract the source file
        local extract_cmd = string.format("unzip -p %q %q 2>/dev/null", sources_jar, match)
        local extract_handle = io.popen(extract_cmd)
        if extract_handle then
          local content = extract_handle:read("*a")
          extract_handle:close()
          if content and #content > 0 then
            local ft = match:match("%.kt$") and "kotlin" or "java"
            return content, ft
          end
        end
      end
    end
  end
  return nil
end

-- Try lsp-temp format: build/.lsp-temp/artifact-version.jar -> build/.lsp-temp/artifact-version-sources.jar
local function try_lsp_temp_jar(jar_path, class_path)
  if not jar_path:match("/%.lsp%-temp/") then return nil end

  -- Construct sources JAR path by inserting -sources before .jar
  local sources_jar = jar_path:gsub("%.jar$", "-sources.jar")
  if vim.fn.filereadable(sources_jar) ~= 1 then return nil end

  local class_name = class_path:match("([^/]+)%.class$")
  if not class_name then return nil end

  return extract_from_sources_jar(sources_jar, class_name)
end

-- Try gradle cache format: .../files-2.1/group/artifact/version/hash/artifact-version.jar
local function try_gradle_cache_jar(jar_path, class_path)
  local version_dir, artifact, version = jar_path:match("(.+/files%-2%.1/.+)/([^/]+)/([^/]+)/[^/]+/[^/]+%.jar$")
  if not version_dir then return nil end

  local sources_jar_pattern = version_dir .. "/" .. artifact .. "/" .. version .. "/*/[^/]*-sources.jar"
  local sources_jars = vim.fn.glob(sources_jar_pattern, false, true)

  if #sources_jars == 0 then return nil end

  local class_name = class_path:match("([^/]+)%.class$")
  if not class_name then return nil end

  for _, sources_jar in ipairs(sources_jars) do
    local content, ft = extract_from_sources_jar(sources_jar, class_name)
    if content then return content, ft end
  end
  return nil
end

-- Try to extract source from sources JAR (fast path)
local function try_source_jar(jar_path, class_path)
  -- Try lsp-temp format first (new workspace.json style)
  local content, ft = try_lsp_temp_jar(jar_path, class_path)
  if content then return content, ft end

  -- Fall back to gradle cache format
  return try_gradle_cache_jar(jar_path, class_path)
end

-- Handler for BufReadCmd on jar/jrt URIs
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "jar://*", "jar:/*", "jrt://*", "jrt:/*" },
  callback = function(args)
    local bufnr = args.buf
    local uri = args.file

    vim.bo[bufnr].buftype = "nofile"

    -- Parse jar:///path/to.jar!/class/path.class
    local jar_path, class_path = uri:match("^jar://(.-)!/(.+)$")
    if not jar_path then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "-- Invalid jar URI --" })
      return
    end

    -- Fast path: try source JAR first
    local content, ft = try_source_jar(jar_path, class_path)
    if content then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(content, "\n"))
      vim.bo[bufnr].filetype = ft
      vim.bo[bufnr].modifiable = false
      vim.bo[bufnr].modified = false
      return
    end

    -- No sources found - show error (no decompile to avoid hanging)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
      "-- No sources available --",
      "-- JAR: " .. jar_path,
      "-- Class: " .. class_path,
      "",
      "-- Run download-sources.sh to fetch sources --",
    })
    vim.bo[bufnr].modifiable = false
  end,
  desc = "Handle jar/jrt URIs - sources first, decompile fallback",
})


return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_language_server = { enabled = false },
        kotlin_lsp = {},
      },
    },
  },
}
