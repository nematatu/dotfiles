return {
  "petertriho/nvim-scrollbar",
  event = {"BufRead","BufNewFile"},
  config = function()
    require("scrollbar").setup({
    })
  end
}
