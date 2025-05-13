-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",

        -- install formatters
        "stylua",

        -- install debuggers
        "debugpy",

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.handlers = {
        python = function(config)
          config.adapters = {
            type = "executable",
            command = vim.fn.exepath "debugpy-adapter",
          }
          config.configurations = {
            {
              type = "python",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              pythonPath = "python",
            },
            {
              type = "python",
              request = "launch",
              name = "Django",
              program = vim.fn.getcwd() .. "/manage.py", -- NOTE: Adapt path to manage.py as needed
              args = { "runserver" },
              pythonPath = "python",
              django = true,
              console = "integratedTerminal",
            },
            {
              type = "python",
              request = "launch",
              name = "Django SSH",
              program = vim.fn.getcwd() .. "/manage.py", -- NOTE: Adapt path to manage.py as needed
              args = { "runserver", "0.0.0.0:3000" },
              pythonPath = "python",
              django = true,
              console = "integratedTerminal",
            },
            {
              type = "python",
              request = "launch",
              name = "FastAPI",
              module = "fastapi",
              pythonPath = "python",
              args = {
                "dev",
                "main.py",
              },
              console = "integratedTerminal",
            },
            {
              type = "python",
              request = "launch",
              name = "FastAPI module",
              module = "uvicorn",
              args = {
                "main:app",
                "--use-colors",
                -- "--reload", -- doesn't work
              },
              pythonPath = "python",
              console = "integratedTerminal",
            },
          }
          require("mason-nvim-dap").default_setup(config) -- don't forget this!
        end,
      }
    end,
  },
}
