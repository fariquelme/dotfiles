return {
	"VonHeikemen/lsp-zero.nvim",
	opts = {},
	dependencies = {
		"hrsh7th/nvim-cmp",
		"neovim/nvim-lspconfig",
		"mason-org/mason.nvim",
	},
	config = function()
		local lsp = require("lsp-zero")
		lsp.on_attach(function(client, bufnr)
			local opts = { buffer = bufnr, remap = false }
			vim.keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
			end, opts)
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover()
			end, opts)
			vim.keymap.set("n", "<leader>fmt", "<cmd>LspZeroFormat<CR>", { buffer = bufnr })
			-- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
			-- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
			-- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
			-- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
			-- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
			vim.keymap.set("n", "<leader>vrr", function()
				vim.lsp.buf.references()
			end, opts)
			vim.keymap.set("n", "<leader>vrn", function()
				vim.lsp.buf.rename()
			end, opts)
			vim.keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, opts)
		end)
		lsp.set_sign_icons({
			error = "🔴",
			warn = "🟡",
			hint = "🟢",
			info = "🔵",
		})
		lsp.setup({})
		vim.diagnostic.config({
			virtual_text = true,
		})
	end,
}
