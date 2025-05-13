---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    -- colorscheme = "solarized-osaka-night",
    -- colorscheme = "astrodark",
    -- colorscheme = "tokyonight",
    -- colorscheme = "flexoki",
    colorscheme = "jellybeans",
    -- colorscheme = "vague",
    -- colorscheme = "catppuccin",
    -- colorscheme = "nightfly",
    -- colorscheme = "tokyonight-day",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    -- highlights = {
    --   init = function()
    --     local get_hlgroup = require("astronvim").get_hlgroup
    --     local comment = get_hlgroup "Comment"
    --     return {
    --       StatusLine = { bg = "none" },
    --       StatusLineNC = { bg = "none" },
    --       -- CopilotSuggestion = { fg = comment },
    --     }
    --   end,
    -- },
    highlights = {
      init = { -- this table overrides highlights in all themes
        -- Normal = { bg = "#000000" },
        StatusLine = { bg = "none" },
        StatusLineNC = { bg = "none" },
      },
      astrodark = { -- a table of overrides/changes when applying the astrotheme theme
        -- Normal = { bg = "#000000" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
