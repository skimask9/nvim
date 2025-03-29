--
-- lualine.lua
--
-- Custom status line
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
  dependencies = { "nvim-tree/nvim-web-devicons", "pnx/lualine-lsp-status" },
  event = "VeryLazy",
  config = function()
    -- Custom Lualine component to show attached language server

    require("lualine").setup {
      options = {
        theme = "auto",
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = { "Avante", "AvanteInput", "neo-tree" }, -- only ignores the ft for statusline.
        },
        component_separators = "",
        globalstatus = true,
        section_separators = { left = "", right = "" },
        -- section_separators = "",
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = " ", right = "" }, icon = { "", align = "left" }, padding = 0 },
        },
        lualine_b = {
          {
            "branch",
            icon = { " ", align = "left" },
            separator = { left = "", right = "" },
            padding = { left = 0, right = 0 },
            color = { gui = "italic,bold" },
            -- color = { fg = "#ffaa88", bg = "grey", gui = "italic,bold" },
          },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            separator = { right = "" },
            padding = { left = 1, right = 0 },
          },
          { GitBlameComponent, padding = { left = 1, right = 0 }, color = { fg = "#606060", gui = "italic" } },
        },
        lualine_c = { "searchcount", "grapple" },
        lualine_x = {
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            update_in_insert = true,
          },
        },
        lualine_y = {
          { "lsp-status", separator = { left = "" } },
          {
            PythonVenvComponent,
            separator = { left = "" },
            padding = { left = 0, right = 0 },
            color = { fg = "#99ad6a", gui = "italic,bold" },
          },
          {
            "fileformat",
            padding = { left = 1, right = 1 },
            separator = { left = "", right = " " },
            symbols = {
              unix = "", -- e712
              dos = "", -- e70f
              mac = "", -- e711
            },
          },
          { "filetype" },
        },
        lualine_z = {
          {
            "location",
            separator = { left = "", right = " " },
            padding = { left = 0, right = 1 },
          },
          { "progress", separator = { right = " " }, padding = 0 },
        },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      extensions = { "toggleterm", "trouble", "neo-tree", "mason" },
    }
  end,
}
