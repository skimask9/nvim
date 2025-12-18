return {
  "nendix/zen.nvim",
  lazy = false,
  enabled = false,
  priority = 1000,

  config = function()
    require("zen").setup {
      -- variant = "light", -- "dark" or "light"
      undercurl = true,
      transparent = true,
      dimInactive = false,
      terminalColors = true,

      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = {},
      typeStyle = {},

      compile = false,

      colors = {
        palette = {}, -- override palette colors
        theme = {}, -- override theme colors
      },

      overrides = function(colors) return {} end,
    }

    vim.cmd.colorscheme "zen"
  end,
}
