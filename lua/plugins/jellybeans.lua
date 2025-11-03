return {
  "wtfox/jellybeans.nvim",
  lazy = false,
  priority = 1000,
  opts = {

    background = {
      dark = "jellybeans_muted", -- default dark palette
      light = "jellybeans_muted_light", -- default light palette
    },
    transparent = true,
    italics = true,
    flat_ui = true,
    bold = true,

    plugins = {
      all = true,
      auto = true, -- will read lazy.nvim and apply the colors for plugins that are installed
    },
    on_higlights = function(hl, c)
      -- Customize Telescope colors
      hl.NeoTreeFloatBorder = { bg = c.background, fg = c.grey_three }
      hl.WinBar = { bg = c.none, fg = c.foreground }
      hl.WinBarNC = { bg = c.none, fg = c.foreground }
      hl.TelescopeBorder = { fg = c.grey_three, bg = c.grey_three }
      hl.NoiceCmdlinePopupTitleCmdline = { bg = c.biloba_flower, fg = c.background }
      hl.NoiceCmdlinePopupBorderCmdLine = { bg = c.none, fg = c.biloba_flower }
      hl.TreesitterContext = { bg = c.none }

      -- FzfLua
      hl.FzfLuaBorder = { fg = c.background, bg = c.background }

      -- MiniStarter
      hl.MiniStarterHeader = { fg = c.error, bold = true }

      -- Unused variables
      hl.DiagnosticUnnecessary = {
        fg = hl.Comment.fg,
        italic = false,
        underline = false,
        undercurl = false,
      }

      hl.DiffViewDiffAdd = {
        fg = c.git.add.fg,
        bg = c.grey_three,
      }
      hl.DiffViewDiffDelete = {
        fg = c.git.delete.fg,
        bg = c.grey_three,
      }
      hl.DiffViewDiffChange = {
        fg = c.git.change.fg,
        bg = c.grey_three,
      }
      hl.DiffviewDiffText = {
        -- fg = c.info,
        bg = c.shuttle_grey,
      }

      hl.DiagnosticLineNumError = {
        fg = c.background,
        bg = c.diag.error,
      }

      hl.DiagnosticLineNumWarn = {
        fg = c.background,
        bg = c.diag.warning,
      }

      hl.Folded = {
        fg = c.ship_cove,
        bg = c.grey_three,
        italic = false,
        bold = false,
      }
    end,
    -- config = function()
    --   require("jellybeans").setup {
    --     on_highlights = function(hl, c)
    --       -- Customize Telescope colors
    --       hl.NeoTreeFloatBorder = { bg = c.background, fg = c.grey_three }
    --       hl.WinBar = { bg = c.none, fg = c.foreground }
    --       hl.WinBarNC = { bg = c.none, fg = c.foreground }
    --       hl.TelescopeBorder = { fg = c.grey_three, bg = c.grey_three }
    --       hl.NoiceCmdlinePopupTitleCmdline = { bg = c.biloba_flower, fg = c.background }
    --       hl.NoiceCmdlinePopupBorderCmdLine = { bg = c.none, fg = c.biloba_flower }
    --       -- hl.InclineNormal = { bg = c.none, fg = c.grey }
    --       -- hl.InclineNormalNC = { bg = c.none, fg = c.grey }
    --       -- hl.InclineNormal = {
    --       --   bg = c.none,
    --       -- }
    --       -- hl.InclineNormalNC = {
    --       --   bg = c.none,
    --       -- }
    --
    --       hl.CopilotSuggestion = { fg = "#888888" }
    --       hl.CopilotAnnotation = { fg = "#888888" }
    --     end,
    --   }
    -- end,
  }, -- Optional
}
