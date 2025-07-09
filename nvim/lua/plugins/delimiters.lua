return{
  "HiPhish/rainbow-delimiters.nvim",
  event = {"BufReadPost","BufNewFile"},
  lazy = true,
  config = function()
    require('rainbow-delimiters.setup').setup {
      strategy = {
        -- ...
      },
      query = {
        -- ...
      },
      highlight = {
        'RainbowDelimiterYellow',
        'RainbowDelimiterViolet',
        'RainbowDelimiterBlue',
        'RainbowDelimiterGreen',
      },
    }
  end,
}
