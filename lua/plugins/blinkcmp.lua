vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function() vim.b.copilot_suggestion_hidden = true end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function() vim.b.copilot_suggestion_hidden = false end,
})

---@type function?, function?
local icon_provider, hl_provider

local function get_kind_icon(CTX)
  -- Evaluate icon provider
  if not icon_provider then
    local _, mini_icons = pcall(require, "mini.icons")
    if _G.MiniIcons then
      icon_provider = function(ctx)
        local is_specific_color = ctx.kind_hl and ctx.kind_hl:match "^HexColor" ~= nil
        if ctx.item.source_name == "LSP" then
          local icon, hl = mini_icons.get("lsp", ctx.kind or "")
          if icon then
            ctx.kind_icon = icon
            if not is_specific_color then ctx.kind_hl = hl end
          end
        elseif ctx.item.source_name == "Path" then
          ctx.kind_icon, ctx.kind_hl = mini_icons.get(ctx.kind == "Folder" and "directory" or "file", ctx.label)
        elseif ctx.item.source_name == "Snippets" then
          ctx.kind_icon, ctx.kind_hl = mini_icons.get("lsp", "snippet")
        end
      end
    end
    if not icon_provider then
      local lspkind_avail, lspkind = pcall(require, "lspkind")
      if lspkind_avail then
        icon_provider = function(ctx)
          if ctx.item.source_name == "LSP" then
            local icon = lspkind.symbolic(ctx.kind, { mode = "symbol" })
            if icon then ctx.kind_icon = icon end
          elseif ctx.item.source_name == "Snippets" then
            local icon = lspkind.symbolic("snippet", { mode = "symbol" })
            if icon then ctx.kind_icon = icon end
          end
        end
      end
    end
    if not icon_provider then icon_provider = function() end end
  end
  -- Evaluate highlight provider
  if not hl_provider then
    local highlight_colors_avail, highlight_colors = pcall(require, "nvim-highlight-colors")
    if highlight_colors_avail then
      local kinds
      hl_provider = function(ctx)
        if not kinds then kinds = require("blink.cmp.types").CompletionItemKind end
        if ctx.item.kind == kinds.Color then
          local doc = vim.tbl_get(ctx, "item", "documentation")
          if doc then
            local color_item = highlight_colors_avail and highlight_colors.format(doc, { kind = kinds[kinds.Color] })
            if color_item and color_item.abbr_hl_group then
              if color_item.abbr then ctx.kind_icon = color_item.abbr end
              ctx.kind_hl = color_item.abbr_hl_group
            end
          end
        end
      end
    end
    if not hl_provider then hl_provider = function() end end
  end
  -- Call resolved providers
  icon_provider(CTX)
  hl_provider(CTX)
  -- Return text and highlight information
  return { text = CTX.kind_icon .. CTX.icon_gap, highlight = CTX.kind_hl }
end
return {
  "Saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "xzbdmw/colorful-menu.nvim",
    "kristijanhusak/vim-dadbod-completion",
    -- "fang2hou/blink-copilot",
  },
  opts = {
    enabled = function()
      local astro = require "astrocore"
      local dap_prompt = astro.is_available "cmp-dap" -- add interoperability with cmp-dap
        and vim.tbl_contains({ "dap-repl", "dapui_watches", "dapui_hover" }, vim.bo.filetype)
      if vim.bo.buftype == "prompt" and not dap_prompt then return false end
      return vim.F.if_nil(vim.b.completion, astro.config.features.cmp)
    end,
    -- remember to enable your providers here
    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
        "dadbod",
        -- "copilot",
      },
      providers = {
        dadbod = {
          name = "Dadbod",
          module = "vim_dadbod_completion.blink",
          score_offset = 85, -- the higher the number, the higher the priority
        },
        -- copilot = {
        --   name = "copilot",
        --   module = "blink-copilot",
        --   score_offset = 100,
        --   async = true,
        --   -- opts = {
        --   --   max_completions = 3,
        --   --   max_attempts = 4,
        --   --   kind_name = "CP",
        --   --   kind_icon = " ",
        --   --   -- debounce = 750, ---@type integer | false
        --   --   auto_refresh = {
        --   --     backward = true,
        --   --     forward = true,
        --   --   },
        --   --   -- Local options override global ones
        --   --   -- Final settings: max_completions = 3, max_attempts = 2, kind = "Copilot"
        --   -- },
        -- },
      },
    },

    completion = {
      menu = {
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
        end,
        border = "none",

        winblend = 25,
        draw = {
          align_to = "label", -- or 'none' to disable, or 'cursor' to align to the cursor
          -- columns = { { "kind_icon", gap = 1 }, { "label", "kind", gap = 1 } },
          columns = { { "kind_icon", gap = 1 }, { "label", "source_name", "kind", gap = 1 } },
          -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },

          treesitter = { "lsp" },
          components = {
            label = {
              text = function(ctx) return require("colorful-menu").blink_components_text(ctx) end,
              highlight = function(ctx) return require("colorful-menu").blink_components_highlight(ctx) end,
            },
            kind_icon = {
              text = function(ctx) return get_kind_icon(ctx).text end,
              highlight = function(ctx) return get_kind_icon(ctx).highlight end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        treesitter_highlighting = true,
        window = {
          border = "none",
          -- border = "rounded",
          winblend = 25,
        },
      },
    },
    signature = {
      enabled = true,
      trigger = {
        show_on_insert = true,
      },
      window = {
        -- border = (vim.o.background == "light") and "rounded" or "none",
        border = "none",
        show_documentation = true,
        winblend = 25,
      },
    },
  },
  specs = {
    { -- disable blink icons if icons are disabled
      "Saghen/blink.cmp",
      opts = function(_, opts)
        if vim.g.icons_enabled == false then
          if not opts.appearance then opts.appearance = {} end
          opts.appearance.kind_icons = {
            Text = "T",
            Method = "M",
            Function = "F",
            Constructor = "C",
            Field = "F",
            Variable = "V",
            Property = "P",
            Class = "C",
            Interface = "I",
            Struct = "S",
            Module = "M",
            Unit = "U",
            Value = "V",
            Enum = "E",
            EnumMember = "E",
            Keyword = "K",
            Constant = "C",
            Snippet = "S",
            Color = "C",
            File = "F",
            Reference = "R",
            Folder = "F",
            Event = "E",
            Operator = "O",
            TypeParameter = "T",
          }
        end
      end,
    },
    {
      "AstroNvim/astrolsp",
      optional = true,
      opts = function(_, opts)
        opts.capabilities = require("blink.cmp").get_lsp_capabilities(opts.capabilities)

        -- disable AstroLSP signature help if `blink.cmp` is providing it
        local blink_opts = require("astrocore").plugin_opts "blink.cmp"
        if vim.tbl_get(blink_opts, "signature", "enabled") == true then
          if not opts.features then opts.features = {} end
          opts.features.signature_help = false
        end
      end,
    },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>uc"] =
          { function() require("astrocore.toggles").buffer_cmp() end, desc = "Toggle autocompletion (buffer)" }
        maps.n["<Leader>uC"] =
          { function() require("astrocore.toggles").cmp() end, desc = "Toggle autocompletion (global)" }
      end,
    },
  },
}
