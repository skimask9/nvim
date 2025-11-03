return {
  "folke/noice.nvim",
  opts = {
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    lsp = {
      signature = {
        enabled = false,
        opts = {
          border = "rounded",
          -- border = "none",
          -- winblend = 25,
          size = {
            max_height = 7,
            -- max_width = 75,
          },
        },
      },
      hover = {
        enabled = true,
        silent = true, -- set to true to not show a message if hover is not available
        view = nil, -- when nil, use defaults from documentation
        ---@type NoiceViewOptions
        opts = {
          -- border = "rounded",
          -- border = "none",
          -- winblend = 25,
          size = {
            max_height = 15,
            -- max_width = 75,
          },
        }, -- merged with defaults from documentation
      },
      documentation = {
        enabled = false,
        opts = {
          win_options = {
            winblend = vim.g.winblend_default,
          },
          -- border = "none",
          border = "rounded",
          -- winblend = 25,
        },
      },
    },
    routes = {
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "notify",
          find = "Toggling hidden files",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
  },
}
