return {
  "f-person/auto-dark-mode.nvim",
  enabled = true,
  opts = {
    -- update_interval = 1000,
    set_dark_mode = function()
      vim.api.nvim_set_option_value("background", "dark", {})
      -- vim.cmd "colorscheme jellybeans"
      -- vim.cmd "colorscheme astrodark"
      -- vim.cmd "colorscheme vague"
      vim.cmd "colorscheme kanso"
      -- vim.cmd "colorscheme nightfly"
    end,
    set_light_mode = function()
      vim.api.nvim_set_option_value("background", "light", {})
      -- vim.cmd "colorscheme tokyonight-day"
      -- vim.cmd "colorscheme flexoki"
      vim.cmd "colorscheme kanso"
    end,
    update_interval = 3000,
    fallback = "dark",
  },
}
