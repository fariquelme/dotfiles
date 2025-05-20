return {
	{
		"nvim-telescope/telescope.nvim",
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
		},
		config = function()
			telescope = require("telescope")
			telescope.setup({
				defaults = {
					layout_config = {
						horizontal = { width = 0.99, heigh = 0.99 },
						vertical = { width = 0.99, heigh = 0.99 },
						-- other layout configuration here
					},
					-- other defaults configuration here
				},
				-- other configuration values here
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
			vim.keymap.set("n", "<C-p>", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			-- Static grep
			vim.keymap.set("n", "<leader>gs", function()
				builtin.grep_string({ search = vim.fn.input("🔍: ") })
			end)
			-- live grep
			vim.keymap.set("n", "<leader>gl", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
		end,
	},
}
