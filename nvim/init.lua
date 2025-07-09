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

-- Neovimの基本設定
require('base')
require('autocmds')
require('options')
require('keymaps')
-- プラグイン読み込み（lazy.nvim の setup を呼ぶ）
require('config.lazy')

require('colorscheme')

vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        vim.wo.winhighlight = "Normal:Normal,NormalNC:NormalNC"
    end,
})

vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        vim.wo.winhighlight = "Normal:NormalNC"
    end,
})

vim.o.shell = "/bin/zsh"
vim.opt.termguicolors = true

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    pattern = "*",
    callback = function()
        if vim.bo.modified and vim.bo.modifiable and vim.bo.buftype == '' then
            vim.cmd("silent write")
        end
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(args)
        vim.lsp.buf.format({ bufnr = args.buf })
    end,
})

-- カーソル停止後すぐに反応させる
vim.o.updatetime = 300

-- カーソルが止まったら diagnostic をフロート表示
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, {
            focus = false,      -- フォーカスを奪わない
            scope = "cursor",   -- カーソル下の診断だけ表示
            border = "rounded", -- 見た目を丸く（任意）
        })
    end,
})
-- 16進カラーコードをRGBに変換
local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
end

-- RGBを16進カラーコードに変換
local function rgb_to_hex(r, g, b)
    return string.format("#%02X%02X%02X", r, g, b)
end

-- 透過的にブレンドする関数
local function alpha_blend(fg, bg, alpha)
    local r1, g1, b1 = hex_to_rgb(fg)
    local r2, g2, b2 = hex_to_rgb(bg)

    local blend = function(a, b)
        return math.floor((alpha * a) + ((1 - alpha) * b) + 0.5)
    end

    return rgb_to_hex(blend(r1, r2), blend(g1, g2), blend(b1, b2))
end
local bg = "#1E1E2E"

vim.api.nvim_set_hl(0, "DiagnosticErrorLine", { bg = alpha_blend("#FF5F5F", bg, 0.2) })
vim.api.nvim_set_hl(0, "DiagnosticWarnLine", { bg = alpha_blend("#FFFF5F", bg, 0.2) })
vim.api.nvim_set_hl(0, "DiagnosticHintLine", { bg = alpha_blend("#5FFFFF", bg, 0.2) })
vim.api.nvim_set_hl(0, "DiagnosticInfoLine", { bg = alpha_blend("#AFFF87", bg, 0.2) })
vim.diagnostic.config({
    virtual_text = true, -- 任意：行末にエラーメッセージを出す
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "󰌵",
        },
        linehl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticErrorLine",
            [vim.diagnostic.severity.WARN]  = "DiagnosticWarnLine",
            [vim.diagnostic.severity.INFO]  = "DiagnosticInfoLine",
            [vim.diagnostic.severity.HINT]  = "DiagnosticHintLine",
        },
    },
    update_in_insert = false,
    underline = true,
})
