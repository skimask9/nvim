return {
  "sphamba/smear-cursor.nvim",
  enabled = true,
  dependencies = {
    "karb94/neoscroll.nvim",
    -- event = "VeryLazy",
    opts = {
      mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        "<C-u>",
        "<C-d>",
        "<C-b>",
        "<C-y>",
        "zt",
        "zz",
        "zb",
      },
    },
  },

  opts = {
    -- cursor_color = "#d3cdc3",
    transparent_bg_fallback_color = "#24273a",
    stiffness = 0.8,
    trailing_stiffness = 0.5,
    distance_stop_animating = 0.5,
    hide_target_hack = false,
    smear_insert_mode = false,
  },
}
