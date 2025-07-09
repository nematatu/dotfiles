local options = {
    encoding = "utf-8",
    fileencoding = "utf-8",
    title = true,
    backup = false,
    clipboard = "unnamedplus",
    cmdheight = 2,
    completeopt = { "menuone", "noselect" },
    conceallevel = 0,
    hlsearch = true,
    ignorecase = true,
    mouse = "a",
    pumheight = 10,
    showmode = false,
    showtabline = 2,
    smartcase = true,
    smartindent = true,
    swapfile = false,
    timeoutlen = 300,
    undofile = true,
    updatetime = 500,
    writebackup = false,
    shell = "fish",
    backupskip = { "/tmp/*", "/private/tmp/*" },
    expandtab = true,
    shiftwidth = 4,
    tabstop = 2,
    cursorline = true,
    number = true,
    relativenumber = false,
    numberwidth = 4,
    signcolumn = "yes",
    winblend = 10,
    wildoptions = "pum",
    pumblend = 10,
    scrolloff = 8,
    sidescrolloff = 8,
    guifont = "Hack Nerd Font Mono:h40",
    splitbelow = false, -- オンのとき、ウィンドウを横分割すると新しいウィンドウはカレントウィンドウの下に開かれる
    splitright = false, -- オンのとき、ウィンドウを縦分割すると新しいウィンドウはカレントウィンドウの右に開かれる
    wrap = true,
    linebreak = true,
    breakindent = true,
    termguicolors = true
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#282C34", fg = "NONE" })
