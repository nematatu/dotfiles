return {
    "Bekaboo/dropbar.nvim",
    enabled = false,
    dependencies = {
        "nvim-telescope/telescope-fzf-native.nvim", -- fuzzy finder のサポート用
        build = "make"
    },
    config = function()
        local dropbar = require('dropbar')
        local dropbar_configs = require('dropbar.configs')
        local default_enable = dropbar_configs.opts.bar.enable

        dropbar.setup({
            bar = {
                enable = function(buf, win, info)
                    local resolved = vim._resolve_bufnr(buf)
                    if resolved == 0 and win and vim.api.nvim_win_is_valid(win) then
                        resolved = vim.api.nvim_win_get_buf(win)
                    end
                    if resolved and resolved > 0 and vim.api.nvim_buf_is_valid(resolved) then
                        if vim.api.nvim_buf_get_option(resolved, 'buftype') == 'terminal' then
                            return false
                        end
                    end
                    return default_enable(buf, win, info)
                end,
            },
        })

        local dropbar_api = require('dropbar.api')

        -- キーバインディング設定
        vim.keymap.set('n', '<Leader>kj', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
        vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
        vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end
}
