--
-- lualine.lua
--
-- Custom status line

-- DOING COMPONENT
local function doing_status()
  local status_doing = require("doing").status()
  if not status_doing or status_doing == "" then return "" end

  local win_width = vim.api.nvim_win_get_width(0)
  local max_len = math.floor(win_width * 0.3)

  if #status_doing > max_len then status_doing = status_doing:sub(1, max_len) .. "..." end

  return " " .. status_doing
end

local hide_in_width = function() return vim.fn.winwidth(0) > 130 end

local sidekick_cli = {
  function()
    local status = require("sidekick.status").cli()
    return " " .. (#status > 1 and #status or "")
  end,
  cond = function() return #require("sidekick.status").cli() > 0 end,
  color = function() return "Special" end,
}

local NESStatus = {
  function()
    local Nes = require "sidekick.nes"
    if next(Nes._requests) then
      return "󰗮" -- loading (waiting on API)
    end
    if Nes.have() then return " " end
    return " "
  end,
  color = function()
    local Nes = require "sidekick.nes"
    if next(Nes._requests) then return "DiagnosticWarn" end
  end,
  cond = function()
    if not require("sidekick.nes").enabled then return false end
    return true
  end,
}

-- GIT BLAME COMMIT COMPONENT
local function GitBlameComponent()
  -- Ensure the gitblame plugin is loaded
  local git_blame_ok, git_blame = pcall(require, "gitblame")

  -- If the plugin is not available, return an empty string
  if not git_blame_ok then return "" end

  -- Check if blame text is available
  if git_blame.is_blame_text_available() then
    local blame_text = git_blame.get_current_blame_text()
    return " " .. blame_text
  else
    return " "
  end
end

local mode = {
  "mode",
  padding = { left = 0, right = 0 },

  fmt = function(str)
    return " " .. str:sub(1, 1) -- displays only the first character of the mode
    -- return " " .. str
  end,
}

--  PYTHON VENV COMPONENT
local function PythonVenvComponent()
  -- Only show for Python files
  if vim.bo.filetype ~= "python" then return "" end

  -- Function to extract the virtual environment name
  local function get_venv_name()
    -- Check for regular virtual environment
    local venv_path = os.getenv "VIRTUAL_ENV"
    if venv_path then
      -- Extract just the environment name from the path
      return venv_path:match "([^/\\]+)$" or venv_path
    end

    return "✗"
  end

  local venv = get_venv_name()
  return " " .. venv
end
return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  specs = {
    {
      "rebelot/heirline.nvim",
      optional = true,
      opts = function(_, opts)
        opts.statusline = nil
        opts.winbar = nil
      end,
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons", "pnx/lualine-lsp-status", "AndreM222/copilot-lualine" },
  event = "VeryLazy",
  config = function()
    -- local branch_bg = vim.api.nvim_get_hl(0, { name = "Folded" }).bg
    -- local diff_blame_bg = vim.api.nvim_get_hl(0, { name = "Visual" }).bg
    -- local non_text = vim.api.nvim_get_hl(0, { name = "NonText" }).fg
    local string_txt = vim.api.nvim_get_hl(0, { name = "String" }).fg
    -- local auto_theme_custom = require "lualine.themes.auto"
    -- auto_theme_custom.normal.c.bg = "None"
    -- auto_theme_custom.insert.c.bg = "None"
    -- auto_theme_custom.command.c.bg = "None"
    -- auto_theme_custom.visual.c.bg = "None"
    -- auto_theme_custom.replace.c.bg = "None"

    --
    -- Get the colors based on the current background setting
    require("lualine").setup {
      options = {
        -- theme = auto_theme_custom,
        theme = "auto",
        always_divide_middle = true,
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = { "snacks_dashboard" }, -- only ignores the ft for statusline.
        },
        component_separators = { left = "", right = "" },
        globalstatus = true,
        section_separators = { right = "", left = "" },
      },
      sections = {
        lualine_a = {
          -- { "mode", icon = { "", align = "left" }, padding = 1 },
          -- { "mode", separator = { right = "" }, padding = { left = 1, right = 0 } },

          -- { "mode", padding = { left = 1, right = 0 } },
          mode,
        },
        lualine_b = {
          {
            "branch",
            draw_empty = false,
            icon = { " ", align = "left" },
            padding = { left = 0, right = 0 },
            color = {
              gui = "italic,bold",
            },

            -- separator = { left = "", right = "" },
          },
          {
            "diff",
            draw_empty = false,

            symbols = { added = " ", modified = " ", removed = " " },
            padding = { left = 1, right = 0 },
            cond = hide_in_width,
          },
          {
            GitBlameComponent,
            draw_empty = true,

            padding = { left = 0, right = 0 },
            -- color = { fg = "#606060", gui = "italic" },
            color = { fg = "#606060" },
            cond = hide_in_width,
          },
        },
        lualine_c = {
          { "grapple", cond = hide_in_width },
          { "%=" },

          {
            doing_status,
            color = { fg = "#606060", gui = "italic" },
            cond = hide_in_width,
          },
        },
        lualine_x = {
          sidekick_cli,
          NESStatus,
          {
            "copilot",
            show_colors = true,
            -- separator = { left = "" },
            padding = { left = 0, right = 1 },
            -- color = { bg = string.format("#%06x", diff_blame_bg) },
          },
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = " " },

            update_in_insert = true,
            padding = { left = 0, right = 1 },
            cond = hide_in_width,
          },

          -- { "lsp-status", separator = { left = "" } },
        },
        lualine_y = {
          {
            -- {
            --   "lsp_status",
            --   padding = { left = 1, right = 1 },
            --   -- color = { bg = "none" },
            -- },
            PythonVenvComponent,
            cond = hide_in_width,

            padding = { left = 0, right = 1 },
            -- color = {
            --   fg = string.format("#%06x", string_txt),
            -- },
          },
          {
            "lsp_status",
            icon = "", -- f013
            symbols = {
              -- Standard unicode symbols to cycle through for LSP progress:
              spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
              -- Standard unicode symbol for when LSP is done:
              done = "",
              -- Delimiter inserted between LSP names:
              separator = " ",
            },
            -- List of LSP names to ignore (e.g., `null-ls`):
            ignore_lsp = { "null-ls", "copilot", "ruff", "copilot_ls" },
            padding = { left = 0, right = 1 },
            cond = hide_in_width,
          },
          -- {
          --   "fileformat",
          --   padding = { left = 0, right = 1 },
          --   color = { bg = string.format("#%06x", diff_blame_bg) },
          -- },
          {
            "filetype",
            padding = { left = 0, right = 1 },
          },
        },
        lualine_z = {
          {
            "location",
            -- padding = { left = 1, right = 1 },
            -- separator = { left = "" },
            padding = { left = 0, right = 0 },
          },
          { "progress", padding = { left = 1, right = 0 } },
        },
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
      extensions = { "toggleterm", "trouble", "mason", "lazy", "avante", "neo-tree" },
    }
  end,
}
