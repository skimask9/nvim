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
    "xzbdmw/colorful-menu.nvim",
    -- enabled = false,
    opts = {},
  },
  {
    "vague2k/vague.nvim",
    enabled = false,
    config = function()
      -- NOTE: you do not need to call setup if you don't want to.
      require("vague").setup {
        vim.cmd "colorscheme vague",
      }
    end,
  },
  -- {
  --   "rmagatti/goto-preview",
  --   event = "BufEnter",
  --   config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
  --   opts = {
  --     default_mappings = true,
  --   },
  -- },

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
      message_when_not_committed = " Not Committed Yet",
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
  {
    "Abstract-IDE/abstract-autocmds",
    enabled = true,
    lazy = false,
    config = function()
      require("abstract-autocmds").setup {
        auto_resize_splited_window = true,
        remove_whitespace_on_save = true,
        no_autocomment_newline = true,
        clear_last_used_search = true,
        open_file_last_position = true,
        -- highlight_on_yank = {
        -- 	enable = true,
        -- 	opts = {
        -- 		timeout = 150,
        -- 	},
        -- },
        -- give_border = {
        --   enable = true,
        --   opts = {
        --     pattern = { "null-ls-info", "lspinfo" },
        --   },
        -- },
        smart_dd = true,
        -- visually_codeblock_shift = true,
        -- move_selected_upndown = true,
        smart_visual_paste = true,
        dont_suspend_with_cz = true,
        smart_save_in_insert_mode = true,
        scroll_from_center = true,
      }
    end,
  },
  {
    "razak17/tailwind-fold.nvim",
    -- enabled = false,
    opts = {},
    ft = { "html,htmldjango,django, templ" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function() require("tailwind-fold").setup { ft = { "html", "htmldjango", "django", "templ" } } end,
  },

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
