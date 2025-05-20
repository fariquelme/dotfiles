return {
	{
		"0x00-ketsu/maximizer.nvim",
		config = function()
			require("maximizer").setup({})
			vim.api.nvim_set_keymap(
				"n",
				"mt",
				'<cmd>lua require("maximizer").toggle()<CR>',
				{ silent = true, noremap = true }
			)
		end,
	},
}
