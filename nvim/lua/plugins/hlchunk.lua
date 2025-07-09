return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("hlchunk").setup({
            chunk = {
                enable = true,
                use_treesitter = true,
                style = {
                    { fg = "#806d9c" },
                },
                disable_ft = { "markdown", "md" }
            },
            indent = {
                enable = true,
                use_treesitter = false,
                style = {
                    { fg = "#c21f30" },
                },
                disable_ft = { "markdown", "md" }
            },
            line_num = {
                enable = false,
            },
            blank = {
                enable = false,
            },
        })
    end
}
