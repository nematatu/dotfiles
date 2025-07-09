local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
    pattern = "*",
    command = ":%s/\\s\\+$//e",
})

autocmd("BufEnter", {
    pattern = "*",
    command = "set fo-=c fo-=r fo-=o",
})

autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
	vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})
