local function shorten_path(path, opts)
  local incline = require "incline"
  local Path = require "plenary.path"

  opts = opts or {}
  local short_len = opts.short_len or 1
  local tail_count = opts.tail_count or 2
  local head_max = opts.head_max or 0
  local relative = opts.relative == nil or opts.relative
  local return_table = opts.return_table or false
  if relative then path = vim.fn.fnamemodify(path, ":.") end
  local components = vim.split(path, Path.path.sep)
  if #components == 1 then
    if return_table then return { nil, path } end
    return path
  end
  local tail = { unpack(components, #components - tail_count + 1) }
  local head = { unpack(components, 1, #components - tail_count) }
  if head_max > 0 and #head > head_max then head = { unpack(head, #head - head_max + 1) } end
  local result = {
    #head > 0 and Path.new(unpack(head)):shorten(short_len, {}) or nil,
    table.concat(tail, Path.path.sep),
  }
  if return_table then return result end
  return table.concat(result, Path.path.sep)
end

--- Given a path, return a shortened version of it, with additional styling.
--- @param path string an absolute or relative path
--- @param opts table see below
--- @return table
---
local function shorten_path_styled(path, opts)
  opts = opts or {}
  local head_style = opts.head_style or {}
  local tail_style = opts.tail_style or {}
  local result = shorten_path(
    path,
    vim.tbl_extend("force", opts, {
      return_table = true,
    })
  )
  return {
    result[1] and vim.list_extend(head_style, { result[1], "/" }) or "",
    vim.list_extend(tail_style, { result[2] }),
  }
end
return {
  "b0o/incline.nvim",
  event = "VeryLazy",
  enabled = true,
  keys = {
    { "<leader>uI", '<Cmd>lua require"incline".toggle()<Cr>', desc = "Incline: Toggle" },
  },
  config = function()
    extra_colors = {} -- Removed 'local'
    if vim.g.colors_name == "catppuccin-frappe" then
      extra_colors.bg = "#51576d"
    elseif vim.g.colors_name == "nightfly" then
      extra_colors.bg = "#1d3b53"
    elseif vim.g.colors_name == "catppuccin-mocha" then
      extra_colors.bg = "#45475a"
    elseif vim.g.colors_name == "flexoki" then
      extra_colors.bg = "#b7b5ac"
      extra_colors.NONE = "NONE"

      extra_colors.grapple = "#5e409d"
    elseif vim.g.colors_name == "jellybeans" then
      extra_colors.bg = "#384048"
      extra_colors.grapple = "#d7af87"
      extra_colors.NONE = "NONE"
    else
      extra_colors.bg = "#3b4261" --tokyonight
      extra_colors.grapple = "#d7af87"
    end

    require("incline").setup {
      debounce_threshold = { rising = 20, falling = 150 },
      window = {
        margin = { horizontal = 0, vertical = 0 },
        placement = { horizontal = "right", vertical = "top" },
        overlap = {
          tabline = false,
          winbar = true,
          borders = true,
          statusline = true,
        },
        padding = 0,
        zindex = 49,
        winhighlight = {
          active = { Normal = "Normal" },
          inactive = { Normal = "Normal" },
        },
      },
      hide = {
        cursorline = true,
        focused_win = false,
        only_win = false,
      },
      ignore = {
        buftypes = "special",
        filetypes = {},
        floating_wins = true,
        unlisted_buffers = true,
        wintypes = "special",
      },
      render = function(props)
        local helpers = require "incline.helpers"
        local filename = shorten_path_styled(vim.api.nvim_buf_get_name(props.buf), {

          short_len = 1,
          tail_count = 2,
          head_max = 4,
        })

        local devicons = require "nvim-web-devicons"
        -- local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":~")
        local filename_icon = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":.")
        if filename_icon == "" then filename_icon = "[No Name]" end
        local ft_icon, ft_color = devicons.get_icon_color(filename_icon)
        local modified = vim.bo[props.buf].modified
        local grapple_status = ""
        if props.focused then
          -- Check if grapple is loaded and exists (similar to Lualine example)
          if package.loaded["grapple"] and require("grapple").exists() then
            local name_or_index = require("grapple").name_or_index()
            if name_or_index ~= "" and name_or_index ~= nil then grapple_status = "󰛢 " .. name_or_index .. " " end
          end
        else
          grapple_status = ""
        end

        return {

          -- { "", guifg = ft_color },

          ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
          -- " ",

          {
            " ",
            grapple_status,
            gui = modified and "bold,italic" or "bold",
            guifg = extra_colors.grapple,
            guibg = vim.o.background == "light" and extra_colors.bg or extra_colors.bg,
          },
          {
            filename,
            " ",
            gui = modified and "bold,italic" or "bold",
            -- guifg = "#888888",
            -- guibg = vim.o.background == "light" and "#b7b5ac" or "#51576d",
            guibg = vim.o.background == "light" and extra_colors.bg or extra_colors.bg,
          },
          -- {
          --   "",
          --   -- guifg = vim.o.background == "light" and "#b7b5ac" or "#51576d",
          --   guifg = vim.o.background == "light" and extra_colors.bg or extra_colors.bg,
          --   guibg = vim.o.background == "light" and extra_colors.bg or extra_colors.bg,
          -- },
        }
      end,
    }
  end,
}
