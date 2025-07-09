return {
    'sidebar-nvim/sidebar.nvim',
    config = function()
        -- 1. まず、git log を表示するためのカスタムセクションを定義します
        local git_log_section = {
            -- セクションのタイトル
            title = "Git Log",
            -- 表示するアイコン
            icon = "",
            -- この draw 関数で、表示する内容を生成します
            draw = function()
                -- vim.fn.system() でシェルコマンドを実行し、結果を取得
                local log_str = vim.fn.system("git log --graph --oneline --decorate --abbrev-commit -n 20")

                -- 結果の文字列を改行で分割して、行のテーブルに変換
                local lines = {}
                for line in string.gmatch(log_str, "[^\r\n]+") do
                    table.insert(lines, line)
                end

                -- 行のテーブルを返す
                return lines
            end,
        }

        -- 2. sidebar-nvim の setup を呼び出します
        require("sidebar-nvim").setup({
            side = "right",
            initial_width = 40,

            -- 3. sections のリストに、定義したカスタムセクションのテーブルを直接入れます
            sections = { "git", "diagnostics", git_log_section },

            section_separator = { "", "-----", "" },
        })
    end
}
