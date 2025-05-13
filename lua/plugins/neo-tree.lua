return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        commands = {
          avante_add_files = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local relative_path = require("avante.utils").relative_path(filepath)

            local sidebar = require("avante").get()

            local open = sidebar:is_open()
            -- ensure avante sidebar is open
            if not open then
              require("avante.api").ask()
              sidebar = require("avante").get()
            end

            sidebar.file_selector:add_selected_file(relative_path)

            -- remove neo tree buffer
            if not open then sidebar.file_selector:remove_selected_file "neo-tree filesystem [1]" end
          end,
        },
      },
      window = {
        position = "right",
        -- width = 30,
        mappings = {
          ["oa"] = "avante_add_files",
        },
      },
    },
    specs = {
      { "nvim-lua/plenary.nvim", lazy = true },
      { "MunifTanjim/nui.nvim", lazy = true },
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>e"] = { "<Cmd>Neotree toggle float<CR>", desc = "Toggle Explorer" }
          maps.n["<Leader>o"] = {
            function()
              if vim.bo.filetype == "neo-tree" then
                vim.cmd.wincmd "p"
              else
                vim.cmd.Neotree "focus"
              end
            end,
            desc = "Toggle Explorer Focus",
          }
        end,
      },
    },
  },
}
