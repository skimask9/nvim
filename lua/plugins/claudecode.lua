local prefix = "<Leader>O"
return {
  {
    "coder/claudecode.nvim",
    enabled = false,
    dependencies = {
      "folke/snacks.nvim",
      { "AstroNvim/astrocore", opts = function(_, opts) opts.mappings.n[prefix] = { desc = " Claude" } end },
    },
    config = true,
    event = "User AstroFile", -- load on file open because it manages it's own bindings

    keys = {
      { "<leader>O", nil, desc = "AI/Claude Code" },
      { "<leader>Oc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>Of", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>Or", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>OC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>Om", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>Ob", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>Os", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>Os",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",

        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
      -- Diff management
      { "<leader>Oa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>Od", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
