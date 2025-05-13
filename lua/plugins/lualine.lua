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

--  PYTHON VENV COMPONENT
local function PythonVenvComponent()
  -- Only show for Python files
  if vim.bo.filetype ~= "python" then return "" end

  -- Function to extract the virtual environment name
  local function get_venv_name()
    -- Check for Conda environment first
    local conda_env = os.getenv "CONDA_DEFAULT_ENV"
    if conda_env then return conda_env end

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
    local branch_bg = vim.api.nvim_get_hl(0, { name = "Folded" }).bg
    local diff_blame_bg = vim.api.nvim_get_hl(0, { name = "Visual" }).bg
    local non_text = vim.api.nvim_get_hl(0, { name = "NonText" }).fg
    local string_txt = vim.api.nvim_get_hl(0, { name = "String" }).fg
    local auto_theme_custom = require "lualine.themes.auto"
    auto_theme_custom.normal.c.bg = "None"
    auto_theme_custom.insert.c.bg = "None"
    auto_theme_custom.command.c.bg = "None"
    auto_theme_custom.visual.c.bg = "None"
    auto_theme_custom.replace.c.bg = "None"

    -- Get the colors based on the current background setting
    require("lualine").setup {
      options = {
        theme = auto_theme_custom,
        always_divide_middle = true,
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = { "snacks_dashboard" }, -- only ignores the ft for statusline.
        },
        -- component_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true,
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = "", right = "" }, icon = { "", align = "left" }, padding = 0 },
        },
        lualine_b = {
          {
            "branch",
            draw_empty = false,
            icon = { " ", align = "left" },
            padding = { left = 0, right = 0 },
            color = { bg = string.format("#%06x", branch_bg), gui = "italic,bold" },
            -- color = {
            --     fg = "#99ad6a",
            --     bg = "#384048",
            --     gui = "italic,bold",
            -- },

            separator = { left = "", right = "" },
          },
          {
            "diff",
            draw_empty = false,

            symbols = { added = " ", modified = " ", removed = " " },
            padding = { left = 1, right = 0 },
            -- color = { bg = "#404040" },
            color = { bg = string.format("#%06x", diff_blame_bg) },
          },
          {
            GitBlameComponent,
            draw_empty = false,

            padding = { left = 0, right = 0 },
            -- color = { fg = "#606060", bg = "#404040", gui = "italic" },
            color = {
              bg = string.format("#%06x", diff_blame_bg),
              fg = string.format("#%06x", non_text),
              gui = "italic,bold",
            },

            separator = { right = "" },
          },
        },
        lualine_c = {
          -- { "grapple", color = "Function" },
          { "%=" },

          {
            doing_status,
            color = {
              fg = string.format("#%06x", non_text),
              gui = "italic",
            },
          },
        },
        lualine_x = {

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
          },

          -- { "lsp-status", separator = { left = "" } },
        },
        lualine_y = {
          {
            "lsp-status",
            separator = { left = "" },
            padding = { left = 0, right = 1 },
            color = { bg = string.format("#%06x", diff_blame_bg) },
          },
          -- {
          --   "fileformat",
          --   padding = { left = 0, right = 1 },
          --   color = { bg = string.format("#%06x", diff_blame_bg) },
          -- },
          {
            PythonVenvComponent,
            separator = { left = "" },

            padding = { left = 0, right = 1 },
            color = {
              fg = string.format("#%06x", string_txt),
              bg = string.format("#%06x", diff_blame_bg),
            },
          },
          {
            "filetype",
            padding = { left = 0, right = 1 },
            separator = { left = "" },

            color = { bg = string.format("#%06x", branch_bg) },
          },
        },
        lualine_z = {
          {
            "location",
            separator = { left = "", right = "" },
            padding = { left = 0, right = 1 },
          },
          { "progress", separator = { right = "" }, padding = 0 },
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
      extensions = { "toggleterm", "trouble", "mason", "lazy" },
    }
  end,
}
