local prefix = "<Leader>a"
return {
  "yetone/avante.nvim",
  -- event = "VeryLazy",
  event = "User AstroFile", -- load on file open because Avante manages it's own bindings
  -- enabled = false,
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  opts = {
    windows = { selector = { provider = "snacks" } },
    mappings = {
      ask = prefix .. "<CR>",
      edit = prefix .. "e",
      refresh = prefix .. "r",
      focus = prefix .. "f",
      stop = prefix .. "S",
      toggle = {
        default = prefix .. "t",
        debug = prefix .. "d",
        hint = prefix .. "H",
        suggestion = prefix .. "s",
        repomap = prefix .. "R",
      },
      files = {
        add_current = prefix .. "c", -- Add current buffer to selected files
        add_all_buffers = prefix .. "B",
      },
      select_model = prefix .. "?", -- Select model command
      select_history = prefix .. "h", -- Select history command
    },

    -- add any opts here
    -- for example
  },
  specs = { -- configure optional plugins
    { "AstroNvim/astroui", opts = { icons = { Avante = "" } } },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    { "AstroNvim/astrocore", opts = function(_, opts) opts.mappings.n[prefix] = { desc = " Avante" } end },
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
