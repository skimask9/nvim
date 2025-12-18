return { -- Using Lazy
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Default options:
      -- Get the colors for the current theme
      local colors = require("kanso.colors").setup()
      local palette_colors = colors.palette
      local theme_colors = colors.theme
      -- Get the colors for a specific theme
      local zen_color = require("kanso.colors").setup { theme = "zen" }
      local pearl_color = require("kanso.colors").setup { theme = "pearl" }
      require("kanso").setup {
        bold = true, -- enable bold fonts
        italics = true, -- enable italics
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        -- functionStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { bold = true },
        statementStyle = {},
        typeStyle = {},
        transparent = true, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = { zen = {}, pearl = {}, ink = {}, all = {} },
        },
        overrides = function(colors)
          local is_light = vim.o.background == "light"

          return {
            -- Use different colors based on background
            NeoTreeFloatBorder = {
              bg = is_light and pearl_color.palette.pearlGray or zen_color.palette.zenBg0,
              fg = is_light and zen_color.palette.pearlGray or zen_color.palette.zenBg0,
            },
            NeoTreeFloatTitle = {
              bg = is_light and zen_color.palette.zenBg1 or zen_color.palette.zenBg0,
              fg = is_light and zen_color.palette.zenBg1 or zen_color.palette.zenBg0,
            },
            NeoTreeNormal = {
              bg = is_light and zen_color.palette.pearlGray or zen_color.palette.zenBg0,
              fg = is_light and zen_color.palette.zenBg0 or zen_color.palette.gray,
            },
            NeoTreeTitleBar = {
              bg = is_light and zen_color.palette.pearlGray or zen_color.palette.zenBg0,
            },
          }
        end,
        background = { -- map the value of 'background' option to a theme
          dark = "ink", -- try "zen", "mist" or "pearl" !
          light = "pearl", -- try "ink" "zen", "mist" or "pearl" !
        },
        -- foreground = "default", -- "default" or "saturated" (can also be a table like background)
        foreground = {
          dark = "default", -- Use default colors in dark mode
          -- light = "saturated", -- Use higher saturation in light mode
          light = "default", -- Use higher saturation in light mode
        },
      }

      -- setup must be called before loading
      vim.cmd "colorscheme kanso"
    end,
  },
}
