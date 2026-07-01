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
            shade_terminals = false,
            highlights = {
                NormalFloat = {
                    guibg = "#252526",
                },
                FloatBorder = {
                    guifg = "#666666",
                    guibg = "#252526",
                },
            },
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            persist_size = true,
            persist_mode = false,
            direction = 'float', -- 通常の開き方を水平分割に変更
            close_on_exit = false,
            clear_env = false,
            shell = '/bin/zsh',
            auto_scroll = false,
            float_opts = {
                border = 'curved',
                winblend = 0,
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
        local codex_cmd = vim.g.codex_terminal_cmd or "codex"

        vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>",
            { noremap = true, silent = true, desc = "Toggle terminal" })
        -- Lazygit terminal
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
        function _lazygit_toggle()
            lazygit:toggle()
        end

        vim.keymap.set("n", "<leader>lg", _lazygit_toggle, { noremap = true, silent = true })

        local codex_width = function()
            return math.floor(vim.o.columns * 0.45)
        end

        -- Codex専用ターミナル（右側の縦分割）
        local codex_term = Terminal:new({
            cmd = codex_cmd,
            hidden = true,
            direction = "vertical",
            close_on_exit = false,
            on_open = function(term)
                on_open(term)

                vim.schedule(function()
                    if not term.window or not vim.api.nvim_win_is_valid(term.window) then
                        return
                    end
                    vim.cmd("vertical resize " .. codex_width())
                    vim.cmd("redraw")
                end)
            end,
        })

        vim.keymap.set("n", "<leader>co", function() codex_term:toggle() end,
            { noremap = true, silent = true, desc = "Toggle Codex terminal" })

        local function get_visual_selection()
            local start_pos = vim.fn.getpos("'<")
            local end_pos = vim.fn.getpos("'>")

            local start_line = start_pos[2]
            local start_col = start_pos[3]
            local end_line = end_pos[2]
            local end_col = end_pos[3]

            if start_line == 0 or end_line == 0 then
                return nil
            end

            if start_line > end_line or (start_line == end_line and start_col > end_col) then
                start_line, end_line = end_line, start_line
                start_col, end_col = end_col, start_col
            end

            local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
            if vim.tbl_isempty(lines) then
                return nil
            end

            start_col = math.max(start_col, 1)
            end_col = math.max(end_col, 1)

            if #lines == 1 then
                lines[1] = lines[1]:sub(start_col, end_col)
            else
                lines[1] = lines[1]:sub(start_col)
                lines[#lines] = lines[#lines]:sub(1, end_col)
            end

            return table.concat(lines, "\n")
        end

        local function shell_quote(str)
            return "'" .. str:gsub("'", "'\\''") .. "'"
        end

        local function explain_selection_with_codex()
            local selection = get_visual_selection()
            if not selection or selection:match("^%s*$") then
                vim.notify("選択範囲が空です。", vim.log.levels.WARN, { title = "Codex" })
                return
            end

            vim.cmd("normal! \\<Esc>")

            local prompt = "以下の内容を日本語で分かりやすく解説してください:\n\n" .. selection
            local command = codex_cmd .. " " .. shell_quote(prompt)

            codex_term:open()

            vim.schedule(function()
                codex_term:send(command .. "\n", false)
            end)
        end

        vim.keymap.set("v", "<leader>ce", explain_selection_with_codex,
            { silent = true, desc = "Explain selection via Codex" })

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

        -- DiffviewFileHistory
        local function _diffview_history_toggle()
            local ok, lib = pcall(require, "diffview.lib")
            if not ok then
                return
            end

            local current_view = lib.get_current_view()

            if current_view then
                -- Diffviewタブ上ならそのビューを閉じる
                current_view:close()
                return
            end

            if #lib.views > 0 then
                -- 別タブで開いている場合は先頭のビューを閉じる
                lib.views[1]:close()
                return
            end

            -- まだ開いていなければヒストリービューを開く
            vim.cmd("DiffviewFileHistory")
        end

        vim.keymap.set("n", "<leader>dvh", _diffview_history_toggle,
            { noremap = true, silent = true, desc = "Toggle Diffview File History" })

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
