return {
    "tversteeg/registers.nvim",
    config = function()
        local registers = require("registers")
        registers.setup({
            keys = {
                { "\"",    mode = { "n", "v" } },
                { "<C-R>", mode = "i" }
            },
            show = "*+\"-/_=#%.0123456789abcdefghijklmnopqrstuvwxyz:",
            system_clipboard = true,
            bind_keys = {
                -- Show the window when pressing " in normal mode, applying the selected register as part of a motion, which is the default behavior of Neovim
                normal    = registers.show_window({ mode = "motion" }),
                -- Show the window when pressing " in visual mode, applying the selected register as part of a motion, which is the default behavior of Neovim
                visual    = registers.show_window({ mode = "motion" }),
                -- Show the window when pressing <C-R> in insert mode, inserting the selected register, which is the default behavior of Neovim
                insert    = registers.show_window({ mode = "insert" }),

                -- When pressing the key of a register, apply it with a very small delay, which will also highlight the selected register
                registers = registers.apply_register({ delay = 0.1 }),
                -- Immediately apply the selected register line when pressing the return key
                ["<CR>"]  = function()
                    -- まず、選択したレジスタを適用する
                    registers.apply_register()()
                    -- 次に、貼り付けコマンド「p」を実行する
                    vim.api.nvim_feedkeys('p', 'n', false)
                end,
                -- Close the registers window when pressing the Esc key
                ["<Esc>"] = registers.close_window(),

                -- Move the cursor in the registers window down when pressing <C-n>
                ["<C-n>"] = registers.move_cursor_down(),
                -- Move the cursor in the registers window up when pressing <C-p>
                ["<C-p>"] = registers.move_cursor_up(),
                -- Move the cursor in the registers window down when pressing <C-j>
                ["<C-j>"] = registers.move_cursor_down(),
                -- Move the cursor in the registers window up when pressing <C-k>
                ["<C-k>"] = registers.move_cursor_up(),
                -- Clear the register of the highlighted line when pressing <DeL>
                ["<Del>"] = registers.clear_highlighted_register(),
                -- Clear the register of the highlighted line when pressing <BS>
                ["<BS>"]  = registers.clear_highlighted_register(),
            },
        })
    end
}
