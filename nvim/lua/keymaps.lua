local opts = { noremap = true, silent = true }

--local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- <C-t>でターミナルが開いてしまう問題の対策
keymap("n", "<C-t>", "<Nop>", opts)

-- New tab
keymap("n", "te", ":tabedit", opts)
-- 新しいタブを一番右に作る
keymap("n", "gn", ":tabnew<Return>", opts)
-- move tab
keymap("n", "gh", "gT", opts)
keymap("n", "gl", "gt", opts)

-- Split window
keymap("n", "ss", ":split<Return><C-w>w", opts)
keymap("n", "sv", ":vsplit<Return><C-w>w", opts)

-- 全選択
keymap("n", "<leader>a", "gg<S-v>G", opts)

-- NormalとVisualでヤンクせずに削除
keymap("n", "x", '"_x', opts)
keymap("v", "x", '"_x', opts)

-- Yで行末までコピー
keymap("n", "Y", "y$", opts)

-- <Space>q で強制終了
keymap("n", "<Space>q", ":<C-u>q!<Return>", opts)

-- ESC*2 でハイライトやめる
keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jj", "<ESC>", opts)

-- コンマ, : の後に自動的にスペースを挿入
keymap("i", ",", ",<Space>", opts)
keymap("i", ":", ":<Space>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- ビジュアルモード時vで行末まで選択
keymap("v", "v", "$h", opts)

-- 0番レジスタを使いやすくした
keymap("v", "<C-p>", '"0p', opts)

-- フォーマッタ
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ctx)
        vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end,
            { noremap = true, silent = true })
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
        vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
        --
        -- vim.keymap.set('n', '<leader>gd', function()
        --     -- LSPに定義場所を問い合わせる
        --     local params = vim.lsp.util.make_position_params()
        --     vim.lsp.buf_request(ctx.buf, 'textDocument/definition', params, function(err, result)
        --         -- エラーが発生したり、定義が見つからなかった場合は何もしない
        --         if err or not result or vim.tbl_isempty(result) then
        --             print("Definition not found.")
        --             return
        --         end
        --
        --         -- 定義が見つかった場合のみ、ウィンドウを垂直分割してジャンプする
        --         vim.cmd('vsplit')
        --         vim.lsp.util.jump_to_location(result[1])
        --     end)
        -- end, { noremap = true, silent = true, buffer = ctx.bufnr, desc = "Go to definition in vsplit" })
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
        vim.keymap.set('n', 'gb', '<C-t>')
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
        vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
        vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
        vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
        vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    end,
}
)

-- ファイル切り替え
vim.keymap.set("n", "<C-s>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<C-f>", "<cmd>bnext<CR>")

-- init.lua に記述
vim.api.nvim_set_keymap('', '<ScrollWheelUp>', '1<C-Y>', opts)
vim.api.nvim_set_keymap('', '<ScrollWheelDown>', '1<C-E>', opts)
vim.api.nvim_set_keymap('i', '<ScrollWheelUp>', '<Esc>1<C-Y>i', opts)
vim.api.nvim_set_keymap('i', '<ScrollWheelDown>', '<Esc>1<C-E>i', opts)

vim.keymap.set("n", "<leader>si", function() require("sidebar-nvim").toggle() end, { desc = "Toggle sidebar" })

-- 次のエラーにジャンプ（下方向）
vim.keymap.set("n", "<leader>ne", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- 前のエラーにジャンプ（上方向）
vim.keymap.set("n", "<leader>pe", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>dy", function()
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
    local col = vim.fn.col('.') - 1

    for _, diag in ipairs(diagnostics) do
        if col >= diag.col and col <= diag.end_col then
            vim.fn.setreg("+", diag.message)
            print("Copied: " .. diag.message)
            return
        end
    end

    print("No diagnostic under cursor.")
end, { desc = "Yank diagnostic under cursor" })

-- 直前の文字を大文字にする
vim.keymap.set("i", "<C-i>",
    function()
        local line = vim.fn.getline(".")
        local col = vim.fn.getpos(".")[3]
        local substring = line:sub(1, col - 1)
        local result = vim.fn.matchstr(substring, [[\v<(\k(<)@!)*$]])
        return "<C-w>" .. result:upper()
    end,
    { expr = true }
)

-- ciwでヤンクしない
vim.keymap.set('n', 'c', '"_c', opts)
-- vim.cmd('noremap <buffer> c "_c')

-- , ""をもう一個となりに作る
--
-- vim.keymap.set("i", "<C-g>", function()
--     -- デバッグメッセージ
--     local esc_key = vim.api.nvim_replace_termcodes("<Esc>", false, false, true)
--     local left_key = vim.api.nvim_replace_termcodes("<Left>", false, false, true)
--     local sequence = esc_key .. "f\"a, \"\"" .. left_key
--
--     vim.fn.feedkeys(sequence, 'nt')
--
--     return ''
-- end, opts)

local copy_file_path = require('myscript.copy-relative-path')
vim.keymap.set(
    'n',
    '<leader>cf',
    copy_file_path.copy_relative_file_path,
    { silent = true, noremap = true }
)

vim.keymap.set("n", "dd", function()
    local line = vim.api.nvim_get_current_line()
    if string.match(line, '^%s*$') then
        vim.cmd('normal! "_dd')
    else
        vim.cmd('normal! dd')
    end
end, { noremap = true, silent = true })

-- カーソル行の上に空行を挿入するユーザーコマンド
vim.api.nvim_create_user_command(
    'BlankAbove',
    function()
        local count = vim.v.count1 -- Luaで v:count1 の値を取得
        -- repeat関数に渡す改行コードはnr2char(10)でVimscriptの関数として呼び出し、
        -- countはLuaで取得した値を直接埋め込む。
        -- あるいは、repeatもVimscriptの関数として呼び出す。
        vim.cmd(string.format("put! =repeat(nr2char(10), %d)", count))
        vim.cmd("normal! '[")
    end,
    { nargs = 0 }
)

-- カーソル行の下に空行を挿入するユーザーコマンド
vim.api.nvim_create_user_command(
    'BlankBelow',
    function()
        local count = vim.v.count1 -- Luaで v:count1 の値を取得
        vim.cmd(string.format("put =repeat(nr2char(10), %d)", count))
    end,
    { nargs = 0 }
)

-- キーマッピングの設定 (この部分は変更不要)
vim.api.nvim_set_keymap(
    'n',
    '<Space>o',
    '<cmd>BlankBelow<CR>',
    { noremap = true, silent = true, desc = "Insert blank lines below" }
)

vim.api.nvim_set_keymap(
    'n',
    '<Space>O',
    '<cmd>BlankAbove<CR>',
    { noremap = true, silent = true, desc = "Insert blank lines above" }
)
vim.api.nvim_set_keymap('n', 'w', '<Plug>CamelCaseMotion_w', opts)
vim.api.nvim_set_keymap('n', 'b', '<Plug>CamelCaseMotion_b', opts)
vim.api.nvim_set_keymap('n', 'e', '<Plug>CamelCaseMotion_e', opts)
vim.api.nvim_set_keymap('n', 'ge', '<Plug>CamelCaseMotion_ge', opts)
