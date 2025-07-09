return {
    'machakann/vim-sandwich',
    lazy = false,
    config = function()
        vim.g.sandwich_no_default_key_mappings = 1
        vim.g['sandwich#recipes'] = vim.deepcopy(vim.g['sandwich#default_recipes'])
    end,
}
