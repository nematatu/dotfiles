return {
	"HiPhish/rainbow-delimiters.nvim",
	event = { "BufReadPost", "BufNewFile" },
	lazy = true,
	config = function()
		require("rainbow-delimiters.setup").setup({
			condition = function(bufnr)
				if vim.bo[bufnr].buftype ~= "" then
					return false
				end

				local ft = vim.bo[bufnr].filetype
				if ft == "" then
					return false
				end

				local ok_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
				if not ok_lang or not lang then
					return false
				end

				local ok_parser, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
				return ok_parser and parser ~= nil
			end,
			strategy = {
				-- ...
			},
			query = {
				-- ...
			},
			highlight = {
				"RainbowDelimiterYellow",
				"RainbowDelimiterViolet",
				"RainbowDelimiterBlue",
				"RainbowDelimiterGreen",
			},
		})
	end,
}
