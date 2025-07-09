local function last_two_dirs()
    local path = vim.fn.getcwd()
    local parts = vim.split(path, '/')

    local len = #parts
    local last_two = table.concat({ parts[len - 1], parts[len] }, "/")

    return last_two
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            icons_enabled = true,
            theme = "material",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
                statusline = {
                    'packer',
                    'sidebar',
                },
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = false,
            refresh = {
                statusline = 100,
                tabline = 100,
                winbar = 100,
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                "branch",
                "diff",
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    sections = { "error", "warn" }, -- 必要なら info, hint も追加
                    symbols = {
                        error = "🚨 E:",
                        warn  = "⚠️ W:",
                        info  = "ℹ️ I:",
                        hint  = "💡 H:",
                    },
                    colored = true,
                    update_in_insert = false,
                    always_visible = true, -- 常に表示（エラーがなくても0と表示）
                }
            },
            lualine_c = {
                {
                    function()
                        return vim.fn.getcwd()
                    end,
                    icon = "",
                },
                "filename"
            },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {
            lualine_a = {
                {
                    'buffers',
                    -- buffers_color = switch_color,
                    symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 ", modified = '_󰷥', directory = ' ' },
                },
            },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {
                'diff'
            },
            lualine_y = {
                'branch'
            },
            lualine_z = {
                { 'tabs', tabs_color = switch_color },
            },
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {},
    },
}
