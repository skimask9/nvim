return {
  "f-person/auto-dark-mode.nvim",

  config = function()
    require("auto-dark-mode").setup {
      set_dark_mode = function()
        vim.o.background = "dark"
        -- vim.cmd "colorscheme jellybeans"
        vim.cmd "colorscheme kanso"
        -- vim.cmd "colorscheme zen"
        -- vim.cmd "colorscheme cursor-dark"
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd "colorscheme kanso"
        -- vim.cmd "colorscheme zen"
        -- vim.cmd "colorscheme cursor-light"
      end,
    }
  end,
  update_interval = 3000,
  fallback = "dark",
}
