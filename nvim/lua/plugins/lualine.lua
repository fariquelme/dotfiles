return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {},
		dependencies = {
			"nvim-tree/nvim-tree.lua",
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			local colors = {
				blue = "#80a0ff",
				cyan = "#79dac8",
				black = "#080808",
				white = "#c6c6c6",
				red = "#ff5189",
				violet = "#d337e8",
				grey = "#303030",
				green = "#C1E0A6",
				yellow = "#FCA311",
				background = "#1E1E2E",
			}

			local bubbles_theme = {
				normal = {
					a = { fg = colors.black, bg = colors.green },
					b = { fg = colors.white, bg = colors.grey },
					c = { fg = colors.yellow, bg = colors.background },
				},

				insert = { a = { fg = colors.background, bg = colors.blue } },
				visual = { a = { fg = colors.background, bg = colors.cyan } },
				replace = { a = { fg = colors.background, bg = colors.red } },

				inactive = {
					a = { fg = colors.white, bg = colors.background },
					b = { fg = colors.white, bg = colors.background },
					c = { fg = colors.white, bg = colors.background },
				},
			}

			require("lualine").setup({
				options = {
					theme = bubbles_theme,
					component_separators = "•",
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
					lualine_b = {
						{
							"filename",
							"branch",
							file_status = true, -- Displays file status (readonly status, modified status)
							path = 1, -- 0: Just the filename
							shorting_target = 40, -- Shortens path to leave 40 spaces in the window
							symbols = {
								modified = "🟡", -- Text to show when the file is modified.
								readonly = "🔒", -- Text to show when the file is non-modifiable or readonly.
								unnamed = "⛔", -- Text to show for unnamed buffers.
								newfile = "✨", -- Text to show for newly created file before first write
							},
						},
					},
					lualine_c = { "branch" },
					lualine_x = { "aerial" },
					lualine_y = {
						"filetype",
						"encoding",
						{
							"fileformat",
							fg = colors.yellow,
							symbols = {
								unix = "", -- e712
								dos = "", -- e70f
								mac = "", -- e711
							},
						},
						"progress",
					},
					lualine_z = {
						{ "location", separator = { right = "" }, left_padding = 2 },
					},
				},

				inactive_sections = {
					lualine_a = { "filename" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = { "nvim-tree" },
			})
		end,
	},
}
