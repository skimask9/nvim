return {
  "linux-cultist/venv-selector.nvim",
  enabled = vim.fn.executable "fd" == 1 or vim.fn.executable "fdfind" == 1 or vim.fn.executable "fd-find" == 1,
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>lv"] = { "<Cmd>VenvSelect<CR>", desc = "Select VirtualEnv" },
          },
        },
      },
    },
  },
  require("venv-selector").setup {
    settings = {
      options = {
        enable_cached_venvs = false, -- use cached venvs that are activated automatically when a python file is registered with the LSP.
        cached_venv_automatic_activation = false, -- if set to false, the VenvSelectCached command becomes available to manually activate them.
        activate_venv_in_terminal = false, -- activate the selected python interpreter in terminal windows opened from neovim
      },
    },
  },
  cmd = "VenvSelect",
}
