return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua",
        "tsx",
        "typescript",
        "javascript",
      },
      highlight = {
        enable = true,
        disable = { "markdown", "markdown_inline" },
      },
      indent = {
        enable = true,
        disable = { "markdown", "markdown_inline" },
      },
    })
  end,
}
