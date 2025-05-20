return {
	{
		"iamcco/markdown-preview.nvim",
		opts = {},
		dependencies = { "iamcco/mathjax-support-for-mkdp" },
		config = true,
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}
