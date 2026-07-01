vim.cmd("autocmd!")

vim.scriptencoding = "utf-8"

vim.wo.number = true

vim.api.nvim_create_user_command("Memo", function(opts)
    vim.cmd("e " .. "~/_/memo/memo.md")
end, {})

local options = {
    tabstop = 4,
    shiftwidth = 4,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

