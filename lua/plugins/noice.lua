return {
  "folke/noice.nvim",
  opts = {
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      -- inc_rename = utils.is_available "inc-rename.nvim", -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    lsp = {
      signature = {
        enabled = false,
        opts = {
          -- border = "rounded",
          border = "none",
          winblend = 25,
          size = {
            max_height = 7,
            -- max_width = 75,
          },
          -- -- Add highlight groups
          -- hl_group = {
          --   signature = "NoiceSignature",
          --   parameter = "NoiceSignatureParameter",
          --   parameter_active = "@parameter",
          -- },
        },
      },
      documentation = {
        enabled = true,
        opts = {
          -- border = "none",
          border = "rounded",
          winblend = 25,
        },
      },
      hover = {
        enabled = true,
        view = "hover", -- Change to your preferred view
        opts = {
          border = {
            style = "rounded",
            winblend = 25,
          },
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
  specs = {

    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      local noice_opts = require("astrocore").plugin_opts "noice.nvim"
      -- disable the necessary handlers in AstroLSP
      if not opts.defaults then opts.defaults = {} end
      -- TODO: remove lsp_handlers when dropping support for AstroNvim v4
      if not opts.lsp_handlers then opts.lsp_handlers = {} end
      if vim.tbl_get(noice_opts, "lsp", "hover", "enabled") ~= false then
        opts.defaults.hover = false
        opts.lsp_handlers["textDocument/hover"] = false
      end
      if vim.tbl_get(noice_opts, "lsp", "signature", "enabled") ~= false then
        opts.defaults.signature_help = false
        opts.lsp_handlers["textDocument/signatureHelp"] = false
        if not opts.features then opts.features = {} end
        opts.features.signature_help = false
      end
    end,
  },
}
