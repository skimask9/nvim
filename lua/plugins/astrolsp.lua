-- local function decode_json_file(filename)
--   local file = io.open(filename, "r")
--   if file then
--     local content = file:read "*all"
--     file:close()
--
--     local ok, data = pcall(vim.fn.json_decode, content)
--     if ok and type(data) == "table" then return data end
--   end
-- end
--
-- local function has_nested_key(json, ...) return vim.tbl_get(json, ...) ~= nil end
---@type LazySpec
return {

  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = true, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
          "htmldjango",
          "html",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              disableOrganizeImports = true,
              typeCheckingMode = "basic",
              -- typeCheckingMode = "strict",
              autoImpCortompletions = true,
              autoSearchPaths = true,
              -- diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,

              diagnosticSeverityOverrides = {
                reportUnusedImport = false,
                -- reportUnusedParameter = false,
                reportUnannotatedClassAttribute = "none",
                reportUnusedFunction = "information",
                reportUnusedVariable = "information",
                reportGeneralTypeIssues = "none",
                reportOptionalMemberAccess = "none",
                reportOptionalSubscript = "none",
                reportPrivateImportUsage = "none",
                reportAttributeAccessIssue = false, -- it stops all errors with django objects methods, need to be investigate
                -- reportUnknownArgumentType = false,
                -- reportUnknownVariableType = false,
              },
            },
          },
        },
      },
      -- tailwindcss = {
      --   root_dir = function(fname)
      --     local root_pattern = require("lspconfig").util.root_pattern
      --
      --     -- Check for Tailwind config files including your custom path
      --     local root = root_pattern(
      --       "tailwind.config.mjs",
      --       "tailwind.config.cjs",
      --       "tailwind.config.js",
      --       "tailwind.config.ts",
      --       "postcss.config.js",
      --       "config/tailwind.config.js",
      --       "assets/tailwind.config.js",
      --       "theme/static_src/tailwind.config.js" -- added custom path
      --     )(fname)
      --
      --     -- If not found, check for package.json with tailwindcss in dependencies
      --     if not root then
      --       local package_root = root_pattern "package.json"(fname)
      --       if package_root then
      --         local package_data = decode_json_file(package_root .. "/package.json")
      --         if
      --           package_data
      --           and (
      --             has_nested_key(package_data, "dependencies", "tailwindcss")
      --             or has_nested_key(package_data, "devDependencies", "tailwindcss")
      --           )
      --         then
      --           root = package_root
      --         end
      --       end
      --     end
      --
      --     return root
      --   end,
      -- },

      -- customize how language servers are attached
      handlers = {
        -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
        -- function(server, opts) require("lspconfig")[server].setup(opts) end

        -- the key is the server that is being setup with `lspconfig`
        -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
        -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
      },
      -- Configure buffer local auto commands to add when attaching a language server
      autocmds = {
        lualine_theme_refresh = {
          {
            event = "ColorScheme",
            desc = "Refresh lualine theme on colorscheme change",
            callback = function()
              local ok, lualine = pcall(require, "lualine")
              if ok then lualine.setup { options = { theme = "auto_theme_custom" } } end
            end,
          },
        }, -- first key is the `augroup` to add the auto commands to (:h augroup)
        lsp_codelens_refresh = {
          -- Optional condition to create/delete auto command group
          -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
          -- condition will be resolved for each client on each execution and if it ever fails for all clients,
          -- the auto commands will be deleted for that buffer
          cond = "textDocument/codeLens",
          -- cond = function(client, bufnr) return client.name == "lua_ls" end,
          -- list of auto commands to set
          {
            -- events to trigger
            event = { "InsertLeave", "BufEnter" },
            -- the rest of the autocmd options (:h nvim_create_autocmd)
            desc = "Refresh codelens (buffer)",
            callback = function(args)
              if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
            end,
          },
        },
      },
      -- mappings to be set up on attaching of a language server
      mappings = {
        n = {
          -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
          gD = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
          ["<Leader>uY"] = {
            function() require("astrolsp.toggles").buffer_semantic_tokens() end,
            desc = "Toggle LSP semantic highlight (buffer)",
            cond = function(client)
              return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
            end,
          },
        },
      },
      -- A custom `on_attach` function to be run after the default `on_attach` function
      -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
      on_attach = function(client, bufnr)
        -- this would disable semanticTokensProvider for all clients
        -- client.server_capabilities.semanticTokensProvider = nil
      end,
    },
  },
}
