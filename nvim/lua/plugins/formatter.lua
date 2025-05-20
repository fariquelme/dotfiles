return {
	{
		"mhartington/formatter.nvim",
		opts = {},
		config = function()
			-- Utilities for creating configurations
			local util = require("formatter.util")

			-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
			--local ruff_check = { exe = "ruff", args = {
			--  "check",
			--  "--fix",
			--  vim.api.nvim_buf_get_name(0)
			--}, stdin = true }
			local ruff_format = {
				exe = "ruff",
				args = {
					"format",
					"--line-length=120",
					"--quiet",
					"-",
					vim.api.nvim_buf_get_name(0),
				},
				stdin = true,
			}

			local prettier = {
				exe = "npx prettier",
				args = {
					"--config-precedence",
					"prefer-file",
					"--stdin-filepath",
					vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
					vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
				},
				stdin = true,
			}

			local autopep = {
				exe = "autopep8",
				args = {
					"--max-line-length=120",
					"--ignore=E402,E121,E70",
					"-",
				},
				stdin = true,
			}

			--in-place --remove-unused-variables src/

			require("formatter").setup({
				-- Enable or disable logging
				logging = true,
				-- Set the log level
				log_level = vim.log.levels.WARN,
				-- All formatter configurations are opt-in
				filetype = {
					-- Use the special "*" filetype for defining formatter configurations on
					-- any filetype
					-- Formatter configurations for filetype "lua" go here
					-- and will be executed in order
					lua = {
						-- "formatter.filetypes.lua" defines default configurations for the
						-- "lua" filetype
						require("formatter.filetypes.lua").stylua,

						-- You can also define your own configuration
						function()
							-- Supports conditional formatting
							if util.get_current_buffer_file_name() == "special.lua" then
								return nil
							end

							-- Full specification of configurations is down below and in Vim help
							-- files
							return {
								exe = "stylua",
								args = {
									"--indent-width",
									"2",
									"--search-parent-directories",
									"--stdin-filepath",
									util.escape_path(util.get_current_buffer_file_path()),
									"--",
									"-",
								},
								stdin = true,
							}
						end,
					},
					javascript = { prettier },
					typescript = { prettier },
					javascriptreact = { prettier },
					typescriptreact = { prettier },
					vue = { prettier },
					["javascript.jsx"] = { prettier },
					["typescript.tsx"] = { prettier },
					markdown = { prettier },
					css = { prettier },
					json = { prettier },
					jsonc = { prettier },
					scss = { prettier },
					less = { prettier },
					yaml = { prettier },
					graphql = { prettier },
					html = { prettier },
					python = { ruff_format },
				},
			})

			vim.cmd([[
        augroup FormatAutogroup
          autocmd!
          autocmd User FormatterPre lua print "formatting..."
          autocmd User FormatterPost lua print "formatted!"
        augroup END
      ]])

			vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>Format<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<leader>F", "<cmd>FormatWrite<CR>", { noremap = true, silent = true })
		end,
	},
}
