return {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy", -- 遅延読み込みで高速化
    config = function()
        require("hlslens").setup({
            calm_down = true,
            nearest_only = true,
            nearest_float_when = 'auto', -- or 'always' if you prefer
        })

        local kopts = { noremap = true, silent = true }

        -- キーマップの設定
        vim.api.nvim_set_keymap('n', 'n',
            [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
            kopts)
        vim.api.nvim_set_keymap('n', 'N',
            [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
            kopts)
        vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
        vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
        vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
        vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

        -- 検索ハイライト解除のショートカット
        vim.api.nvim_set_keymap('n', '<leader>l', '<Cmd>noh<CR>', kopts)
    end,
}
