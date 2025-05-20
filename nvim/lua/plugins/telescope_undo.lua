return {
	{
		"debugloop/telescope-undo.nvim",
		opts = {},
		config = function()
			vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
			require("telescope").load_extension("undo")
		end,
	},
}
