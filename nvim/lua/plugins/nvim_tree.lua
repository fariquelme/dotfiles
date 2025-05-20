return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			-- disable netrw at the very start of your init.lua (strongly advised)
			local api = require("nvim-tree.api")
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			-- Autoclose nvim tree
			vim.api.nvim_create_autocmd("QuitPre", {
				callback = function()
					local tree_wins = {}
					local floating_wins = {}
					local wins = vim.api.nvim_list_wins()
					for _, w in ipairs(wins) do
						local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
						if bufname:match("NvimTree_") ~= nil then
							table.insert(tree_wins, w)
						end
						if vim.api.nvim_win_get_config(w).relative ~= "" then
							table.insert(floating_wins, w)
						end
					end
					if 1 == #wins - #floating_wins - #tree_wins then
						-- Should quit, so we close all invalid windows.
						for _, w in ipairs(tree_wins) do
							vim.api.nvim_win_close(w, true)
						end
					end
				end,
			})

			-- Solution dangling explorer on empty tabs
			local function tab_win_closed(winnr)
				local tabnr = vim.api.nvim_win_get_tabpage(winnr)
				local bufnr = vim.api.nvim_win_get_buf(winnr)
				local buf_info = vim.fn.getbufinfo(bufnr)[1]
				local tab_wins = vim.tbl_filter(function(w)
					return w ~= winnr
				end, vim.api.nvim_tabpage_list_wins(tabnr))
				local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
				if buf_info.name:match(".*NvimTree_%d*$") then -- close buffer was nvim tree
					-- Close all nvim tree on :q
					if not vim.tbl_isempty(tab_bufs) then -- and was not the last window (not closed automatically by code below)
						api.tree.close()
					end
				else -- else closed buffer was normal buffer
					if #tab_bufs == 1 then -- if there is only 1 buffer left in the tab
						local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
						if last_buf_info.name:match(".*NvimTree_%d*$") then -- and that buffer is nvim tree
							vim.schedule(function()
								if #vim.api.nvim_list_wins() == 1 then -- if its the last buffer in vim
									vim.cmd("quit") -- then close all of vim
								else -- else there are more tabs open
									vim.api.nvim_win_close(tab_wins[1], true) -- then close only the tab
								end
							end)
						end
					end
				end
			end

			vim.api.nvim_create_autocmd("WinClosed", {
				callback = function()
					local winnr = tonumber(vim.fn.expand("<amatch>"))
					vim.schedule_wrap(tab_win_closed(winnr))
				end,
				nested = true,
			})

			-- set termguicolors to enable highlight groups
			vim.opt.termguicolors = true

			-- OR setup with some options
			require("nvim-tree").setup({
				sort_by = "case_sensitive",
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = false,
				},
				tab = {
					sync = {
						open = true,
						close = true,
						ignore = {},
					},
				},
			})

			local function open_nvim_tree()
				api.tree.open()
			end
			-- Avoid leaving NvimTree_1 when opening a new tab using <C-w>t, or gt and gT
			local swap_then_open_tab = function()
				local node = api.tree.get_node_under_cursor()
				vim.cmd("wincmd l")
				api.node.open.tab(node)
			end
			vim.keymap.set("n", "t", swap_then_open_tab, { noremap = true, silent = true })
			-- Map 'gt' and 'gT' for the nvim-tree buffer
			vim.keymap.set("n", "gt", function()
				if vim.bo.filetype == "NvimTree" then
					swap_then_open_tab()
				else
					vim.cmd("tabnext") -- Default behavior for 'gt'
				end
			end, { noremap = true, silent = true })

			vim.keymap.set("n", "gT", function()
				if vim.bo.filetype == "NvimTree" then
					swap_then_open_tab()
				else
					vim.cmd("tabprevious") -- Default behavior for 'gT'
				end
			end, { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<leader>nt", ":NvimTreeToggle<cr>", { silent = true, noremap = true })
			vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
		end,
	},
}
