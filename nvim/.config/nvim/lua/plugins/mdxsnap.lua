return {
    'HidemaruOwO/mdxsnap.nvim',
    config = function()
        require('mdxsnap').setup({
              DefaultPastePath = "public", -- デフォルト: "snaps/images/posts"
        })
    end
}
