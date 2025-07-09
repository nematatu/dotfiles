return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "RRethy/nvim-treesitter-textsubjects",
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "tsx", "typescript", "javascript" },
      highlight = { enable = true },
      indent = { enable = true },

      textsubjects = {
        enable = true,
        prev_selection = ",",
        keymaps = {
          ["."] = "textsubjects-smart",
          ["a"] = "textsubjects-container-outer",
          ["ia"] = "textsubjects-container-inner",
        },
      },
    })
  end
}
