return {
	{
		"mason-org/mason.nvim",
		opts = {},
		dependencies = {
			"VonHeikemen/lsp-zero.nvim",
			"mason-org/mason-lspconfig.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local mason = require("mason")
			mason.setup({})
			local lsp_zero = require("lsp-zero")
			require("mason-lspconfig").setup({
				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						local lua_opts = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
				},
			})
		end,
	},
}
