return {
  "folke/noice.nvim",
  opts = function(_, opts)
    local focused = true
    vim.api.nvim_create_autocmd("FocusGained", {
      callback = function()
        focused = true
      end,
    })
    vim.api.nvim_create_autocmd("FocusLost", {
      callback = function()
        focused = false
      end,
    })
    table.insert(opts.routes, 1, {
      filter = {
        event = "msg_show",
        find = "%d+L, %d+B",
        cond = function()
          return not focused
        end,
      },
      view = "mini",
      opts = { stop = false },
    })

    opts.commands = {
      all = {
        -- options for the message history that you get with `:Noice`
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {},
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(event)
        vim.schedule(function()
          require("noice.text.markdown").keys(event.buf)
        end)
      end,
    })
  end,
}
