return {
  -- Your other plugins...
  {
    "vpoltora/cursor-light.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cursor-light").setup()
      vim.cmd.colorscheme "cursor-light"
    end,
  },

  {
    "ydkulks/cursor-dark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme("cursor-dark-midnight")
      require("cursor-dark").setup {
        -- For theme
        -- style = "dark-midnight",
        style = "dark",
        -- For a transparent background
        transparent = true,
        -- If you have dashboard-nvim plugin installed
        dashboard = true,
      }
    end,
  },
}
