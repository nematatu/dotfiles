return {
    'smoka7/hop.nvim',
    version = "*",
    config = function()
        require('hop').setup({
            opts = { keys = 'etovxqpdygfblzhckisuran' },
        })
        -- place this in one of your configuration file(s)
        local hop = require('hop')
        local directions = require('hop.hint').HintDirection
        vim.keymap.set('', '<leader>h', function()
            hop.hint_words({})
        end, { remap = true })
        vim.keymap.set('', 'f', function()
            hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
        end, { remap = true })
        vim.keymap.set('', 'F', function()
            hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
        end, { remap = true })
        vim.keymap.set('', 't', function()
            hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
        end, { remap = true })
        vim.keymap.set('', 'T', function()
            hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
        end, { remap = true })
    end,
}
