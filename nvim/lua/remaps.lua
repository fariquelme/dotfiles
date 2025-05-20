vim.keymap.set("x", "<leader>p", [["_dP]])
-- Insert python breakpoint
vim.keymap.set( 'n', '<leader>pdb', 'oimport ipdb; ipdb.set_trace()<ESC>:wo', {noremap=true, silent=true})
-- Clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"*y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"*p')
