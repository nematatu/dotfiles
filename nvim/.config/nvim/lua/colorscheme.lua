return {
    "gmr458/vscode_modern_theme.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("vscode_modern").setup({
            cursorline = true,
            nvim_tree_darker = true,
            transparent_background=true
        })
        vim.cmd.colorscheme("vscode_modern")
    end,
}
