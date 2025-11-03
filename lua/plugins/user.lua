-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require("lsp_signature").setup() end,
  -- },

  {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    event = "BufEnter",
    config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
    opts = {
      default_mappings = true,
      references = { -- Configure the telescope UI for slowing the references cycling window.
        provider = "snacks", -- telescope|fzf_lua|snacks|mini_pick|default
      },
    },
  },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      hide_cursor = true, -- Hide the cursor while scrolling
      duratuion_multiplier = 0.55, -- Multiplier for the duration of the scrolling animation
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

  {
    "f-person/git-blame.nvim",
    event = "User AstroGitFile",
    cmd = {
      "GitBlameToggle",
      "GitBlameEnable",
      "GitBlameOpenCommitURL",
      "GitBlameCopyCommitURL",
      "GitBlameOpenFileURL",
      "GitBlameCopyFileURL",
      "GitBlameCopySHA",
    },
    opts = {
      enabled = true,
      display_virtual_text = false,
      -- date_format = "%c",
      date_format = "%r",
      -- message_template = "  <author> 󰔠 <date> 󰈚 <summary>  <sha>",
      message_template = " <author> 󰈚 <summary>",
      -- message_when_not_committed = " Not Committed Yet",
      message_when_not_committed = "",
      max_commit_summary_length = 25,
      -- highlight_group = "Question",
      -- virtual_text_column = 80,
    },
  },
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    cmd = { "NoNeckPain" },
  },
  -- {
  --   "razak17/tailwind-fold.nvim",
  --   enabled = false,
  --   opts = {},
  --   ft = { "html,htmldjango,django, templ" },
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   event = "VeryLazy",
  --   config = function() require("tailwind-fold").setup { ft = { "html", "htmldjango", "django", "templ" } } end,
  -- },

  {
    "theHamsta/nvim-dap-virtual-text",
    cmd = { "DapContinue", "DapToggleBreakpoint" },
    opts = {
      virt_text_pos = "eol",
      highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = true, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true,
    },
  },
  { "Vimjas/vim-python-pep8-indent", ft = "python" },

  -- == Examples of Overriding Plugins ==

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      luasnip.filetype_extend("html", { "htmldjango" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
