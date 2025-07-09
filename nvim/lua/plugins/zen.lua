return {
    "folke/zen-mode.nvim",
    opts = {
        vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { noremap = true, silent = true }),
        window = {
            backdrop = 0.85,
            width = 80,
            height = 1,
            options = {
                number = true,
                relativenumber = false,
                cursorline = true,
                cursorcolumn = false,
                list = false,
                spell = false,
                scrolloff = 0,
                sidescrolloff = 0,
                wrap = false,
            },
        }
    }
}
