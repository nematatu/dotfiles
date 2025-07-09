return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        local on_open = function(term)
            -- 要望①: ターミナル内で <C-t> を押すと、そのターミナルを閉じる
            vim.keymap.set({ 'n', 't' }, '<C-t>', function()
                require('toggleterm').toggle(term.id)
            end, { buffer = term.bfr, silent = true, desc = "Close current terminal" })

            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { buffer = term.bfr, silent = true, desc = "Enter normal mode" })
        end

        require("toggleterm").setup {
            size = 21,
            hide_numbers = true,
            shade_filetypes = {},
            autochdir = false,
            shade_terminals = true,
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            persist_size = true,
            persist_mode = true,
            direction = 'float', -- 通常の開き方はfloat
            close_on_exit = false,
            clear_env = false,
            shell = '/bin/zsh',
            auto_scroll = true,
            float_opts = {
                border = 'curved',
                winblend = 4,
                title_pos = 'center',
            },
            winbar = {
                enabled = false,
                name_formatter = function(term)
                    return term.name
                end
            },
            on_open = on_open

        }

        local Terminal = require('toggleterm.terminal').Terminal

        vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", { noremap = true, silent = true })
        -- Lazygit terminal
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
        function _lazygit_toggle()
            lazygit:toggle()
        end

        vim.keymap.set("n", "<leader>lg", _lazygit_toggle, { noremap = true, silent = true })

        -- Diffview
        local function _diffview_toggle()
            -- 'filetype'が'DiffviewFiles'のウィンドウが存在するか確認
            local diffview_open = false
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'DiffviewFiles' then
                    diffview_open = true
                    break
                end
            end

            if diffview_open then
                -- Diffviewが開いていれば閉じる
                vim.cmd("DiffviewClose")
            else
                -- Diffviewが閉じていれば開く
                vim.cmd("DiffviewOpen")
            end
        end

        vim.keymap.set("n", "<leader>dv", _diffview_toggle, { noremap = true, silent = true, desc = "Toggle Diffview" })


        -- Bottom terminal（水平分割で開く）
        local bottom_term = Terminal:new({
            direction = "horizontal",
            hidden = true,
            size = 6, -- ★ここで高さ指定
        })

        function _bottom_term_toggle()
            bottom_term:toggle()
        end

        -- Insert と Normal 両モードで <leader>tb を有効化
        vim.keymap.set({ "n" }, "<leader>tb", function() _bottom_term_toggle() end,
            { noremap = true, silent = true })

        -- Terminalモードから <ESC> でノーマルに戻る
        vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], { silent = true })

        -- 新しいターミナルを連番で開くためのカウンター
        local term_count = 2
        vim.keymap.set("n", "<leader>tn", function()
            term_count = term_count + 2
            require("toggleterm").toggle(term_count, nil, nil, 'float')
        end, { noremap = true, silent = true, desc = "Open new sequential terminal" })
    end
}
