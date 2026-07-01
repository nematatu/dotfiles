return {
    'goolord/alpha-nvim',
    config = function()
        local alpha = require 'alpha'
        local dashboard = require 'alpha.themes.dashboard'

        -- アスキーアートのロゴをここに設定
        dashboard.config.header = {
            [[
███████╗███████╗██╗████████╗███████╗███████╗
██╔════╝██╔════╝██║╚══██╔══╝██╔════╝██╔════╝
█████╗  █████╗  ██║   ██║   █████╗  █████╗
██╔══╝  ██╔══╝  ██║   ██║   ██╔══╝  ██╔══╝
███████╗███████╗██║   ██║   ███████╗███████╗
╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝╚══════╝
            ]],
        }

        -- 中央のボタン設定（最近開いたファイル、プロジェクト、設定）
        dashboard.config.center = {
            { icon = "  ", desc = "最近開いたファイル", action = "Telescope oldfiles" },
            { icon = "  ", desc = "最近のプロジェクト", action = "Telescope projects" },
            { icon = "⚙️  ", desc = "設定", action = "e ~/.config/nvim/init.lua" },
            { icon = "  ", desc = "ウェブブラウザを開く", action = "silent !xdg-open https://www.google.com" },
        }

        -- フッターにカスタムメッセージを設定
        dashboard.config.footer = { "Welcome to Neovim!" }

        -- ダッシュボードをセットアップ
        alpha.setup(dashboard.config)
    end
}
