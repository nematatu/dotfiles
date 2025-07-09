return {
    'vyfor/cord.nvim',
    build = ':Cord update',
    config = function()
        require('cord').setup({
            editor = {
                tooltip = 'nvim is the BEST!!'
            },
            display = {
                theme = "catppuccin",
                swap_icons = true
            },
            text = {
                editing = 'Editing a file',
                viewing = 'Viewing a file',
                workspace = ''
            },
            assets = {
                ['.rs'] = {
                    icon = 'rust',           -- Asset name or URL
                    tooltip = 'Rust',        -- Hover text
                    text = 'Writing in Rust' -- Override entire text
                },
                netrw = {
                    name = 'Netrw',       -- Override asset name only
                    type = 'file_browser' -- Set asset type
                },
                ['.tsx'] = {
                    tooptip = 'TypeScript',
                    text = 'Coding in TypeScript',
                }
            },
        })
    end

}
