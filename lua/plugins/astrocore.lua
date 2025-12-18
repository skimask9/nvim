-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local Terminal = require("toggleterm.terminal").Terminal
---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      auto_html_django = {
        name = "auto_html_django",
        group = "auto_html_django",
        event = "BufWritePre",
        pattern = { "*.html", "*.htmldjango" },
        desc = "Auto set filetype to html.django for .html and .htmldjango files",
        callback = function() vim.lsp.buf.format { async = false } end,
      },
      -- autoread = {
      --
      --   -- unique name for this autocmd
      --   name = "autoread_checktime",
      --   -- also create an augroup called "autoread"
      --   group = "autoread",
      --   -- trigger on focus, buffer enter, or idle
      --   event = { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
      --   -- apply to all files
      --   pattern = "*",
      --   -- description (shows in :autocmd)
      --   desc = "Check for external file changes automatically",
      --   -- main logic
      --   callback = function()
      --     if vim.fn.mode() ~= "c" then vim.cmd.checktime() end
      --   end,
      -- },

      -- autocommands are organized into augroups for easy management
      -- autoread = {
      --   -- auto-reload files when they change externally
      --   {
      --     -- trigger on focus gained and buffer enter events
      --     event = { "FocusGained", "BufEnter" },
      --     -- apply to all files
      --     pattern = "*",
      --     -- nice description
      --     desc = "Auto-reload files when changed externally",
      --     -- add the autocmd to the newly created augroup
      --     group = "autoread",
      --     callback = function()
      --       -- check if any buffers have been modified externally
      --       vim.cmd "checktime"
      --     end,
      --   },
      --   {
      --     -- also check when cursor stops moving
      --     event = "CursorHold",
      --     -- apply to all files
      --     pattern = "*",
      --     -- nice description
      --     desc = "Check for external file changes on cursor hold",
      --     -- add the autocmd to the same augroup
      --     group = "autoread",
      --     callback = function()
      --       -- check if any buffers have been modified externally
      --       vim.cmd "checktime"
      --     end,
      --   },
      -- },
    },
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = false, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        number = true, -- Show line numbers
        relativenumber = false, -- Use absolute numbers (not relative)
        showtabline = 0, -- disable tabline
        spell = true, -- sets vim.opt.spell
        path = vim.opt.path + "**",
        -- signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        mousemoveevent = true,
        linebreak = true, -- linebreak soft wrap at words
        breakindent = true,
        list = true, -- show whitespace characters
        listchars = {
          tab = "|→",
          extends = "⟩",
          precedes = "⟨",
          trail = "·",
          nbsp = "␣",
          -- eol = "↵",
        },
        showbreak = "↪ ",
        wrap = true, -- sets vim.opt.wrap
        -- colorcolumn = "89",
        cmdheight = 0,
        -- pumblend = 5, -- for cmp menu
        -- winblend = 5, -- for documentation popup
        scrolloff = 10,
        laststatus = 3,
        -- clipboard = "unnamedplus",
        sidescrolloff = 8,
        --guicursor = "n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100, i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100,r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100",

        -- guicursor = "n-v-c-sm-ve:block,i-ci:ver20,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        --
        -- -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- second key is the lefthand side of the map

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command
        -- ["<F1>"] = { ":w|!python3 %<CR>", desc = "Run python file" },
        ["<F1>"] = {
          function()
            local term = Terminal:new { cmd = "python3 " .. vim.fn.expand "%:p", hidden = true, close_on_exit = false }
            term:toggle()
          end,
        },
        ["<F3>"] = { ":w|!go run %<cr>", desc = "Run go file" },
        ["<C-x>"] = { function() require("snacks").picker.buffers() end, desc = "Find buffers" },
        ["<F2>"] = { ":ToggleTerm direction=horizontal<cr>", desc = "ToggleTerm" },
        [",m"] = { "<cmd>lua vim.cmd('%s/\\r//g')<cr>", desc = "Remove carriage return" },
        -- ["<leader>Go"] = { "<cmd>:GitBlameOpenFileURL<cr>", desc = "Open File in Github.com" },
        -- ["<leader>Gy"] = { "<cmd>:GitBlameCopyFileURL<cr>", desc = "To copy url link github" },
        -- ["<leader>Gt"] = { "<cmd>:GitBlameToggle<cr>", desc = "To toggle git blame" },
        -- ["<C-x>"] = { "<cmd>:Telescope buffers<cr>" },
        -- tables with the `name` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<leader>b"] = { name = "Buffers" },
        ["<leader>D"] = { name = " Tasks" },
        ["<c-c>"] = { '"+y', desc = "" },
        ["<c-v>"] = { '"+p', desc = "" },
        -- ["<M-J>"] = { "<cmd>t.<cr>", desc = "" },
        -- ["<M-K>"] = { "<cmd>t -1<cr>", desc = "" },
        ["<M-Down>"] = { "<cmd>m+<cr>", desc = "" },
        ["<M-Up>"] = { "<cmd>m-2<cr>", desc = "" },
        -- ["<M-j>"] = { "<cmd>m+<cr>", desc = "" },
        -- ["<M-k>"] = { "<cmd>m-2<cr>", desc = "" },
        ["q"] = { "<cmd>q!<cr>", desc = "" },
      },
      i = {
        ["<c-c>"] = { '"+y', desc = "" },
        ["<c-v>"] = { "<c-r>+", desc = "" },
        -- ["<S-Up>"] = { "<cmd>t -1<cr>", desc = "" },
        -- ["<M-Up>"] = { "<cmd>m-2<cr>", desc = "" },
        ["<C-s>"] = { "<cmd>w<cr>", desc = "" },
        ["<F1>"] = {
          function()
            local term = Terminal:new { cmd = "python3 " .. vim.fn.expand "%:p", hidden = true, close_on_exit = false }
            term:toggle()
          end,
        },
      },
      v = {
        ["p"] = { '"_dP', desc = "" },
        ["<c-c>"] = { '"+y', desc = "" },
        ["<c-v>"] = { '"+p', desc = "" },
        ["<A-Down>"] = { ":move '>+1<CR>gv-gv", desc = "" },
        ["<A-Up>"] = { ":move '<-2<CR>gv-gv", desc = "" },
      },

      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
        --       -- extra mappings for terminal navigaton
        -- ["<Leader><esc>"] = "<c-\\><c-n>",
        ["<Esc><esc>"] = "<c-\\><c-n>:ToggleTerm<CR>",
      },
    },
  },
}
