-- lazy.nvim を runtimepath に追加（最優先で）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- プラグインのセットアップ
require("lazy").setup({
    spec = {
        { import = "plugins.lualine" },
        { import = "plugins.autopairs" },
        { import = "plugins.cmp" },
        { import = "plugins.lspconfig" },
        { import = "plugins.none-ls" },
        -- { import = "plugins.smoothcursor" },
        { import = "plugins.bufferline" },
        { import = "plugins.telescope" },
        { import = "plugins.fidget" },
        { import = "plugins.gitblame" },
        { import = "plugins.gitsigns" },
        { import = "plugins.toggleterm" },
        { import = "plugins.webicons" },
        { import = "plugins.comment" },
        { import = "plugins.snacks" },
        { import = "plugins.scrollbar" },
        { import = "plugins.delimiters" },
        { import = "plugins.neocodeium" },
        { import = "plugins.dashboard" },
        { import = "plugins.hlchunk" },
        { import = "plugins.treesitter-context" },
        { import = "plugins.dropbar" },
        { import = "plugins.zen" },
        { import = "plugins.markview" },
        { import = "plugins.namu" },
        { import = "plugins.hlslens" },
        { import = "plugins.close-buffers" },
        { import = "plugins.which-key" },
        { import = "plugins.vim-sandwich" },
        { import = "plugins.treesitter-textsubjects" },
        { import = "plugins.nvim-treesitter" },
        { import = "plugins.treesj" },
        { import = "plugins.noice" },
        -- { import = "plugins.sidebar" },
        { import = "plugins.transparent" },
        { import = "plugins.accelerated-jk" },
        { import = "plugins.octo" },
        { import = "plugins.discord" },
        { import = "plugins.hop" },
        { import = "plugins.registers" },
        { import = "plugins.auto-session" },
        { import = "plugins.capture" },
        { import = "plugins.linediff" },
        { import = "plugins.diffview" },
        { import = "plugins.nvim-ts-autotag" },
        { import = "plugins.octo" },
        { import = "plugins.luaship" },
        { import = "plugins.CamelCaseMotion" },
        { "nvim-lua/plenary.nvim" }, -- Common utilities
        { "windwp/nvim-ts-autotag" },
        {
            "gmr458/vscode_modern_theme.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                require("vscode_modern").setup({
                    cursorline = true,
                    transparent_background = false,
                    nvim_tree_darker = true,
                })
                vim.cmd.colorscheme("vscode_modern")
            end,
        },
        { "rebelot/kanagawa.nvim" }
    },
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "tutor",
                "tohtml",
                -- "filetypes",
                -- "ftplugin",
                -- "matchit",
                -- "matchparen",
                -- "netrw",
                -- "netrwPlugin",
                "gzip",
                "tar",
                "tarPlugin",
                "zip",
                "zipPlugin",
                "vimball",
                "vimballPlugin",
                "install_default_menus",
                "install_syntax_menu",
                "loading_mswin",
            },
        },
    }
})
