return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      exclude = {
        "^%.git[/\\]",
        "[/\\]%.git[/\\]",
        "^node_modules/*",
        "^.vscode/*",
        "%.pyc",
        "^.gitworkflows/*",
        ".gitignore",
      },
    },
  },
}
