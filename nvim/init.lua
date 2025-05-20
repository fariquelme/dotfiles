-- Mappings
-- Remap leader key
vim.g.mapleader = ' '
-- vim.cmd [[
-- let g:python3_host_prog=substitute(system('echo $PYENV_VIRTUAL_ENV'),'\v^\s*(.{-})\n*\s*\n*$','\1','')
-- let g:python_host_prog=substitute(system('echo $PYENV_VIRTUAL_ENV'),'\v^\s*(.{-})\n*\s*\n*$','\1','')
-- ]]


-- Load plugins
-- require("user.plugins")
require("config.lazy")
require("sets")
require("remaps")


vim.cmd([[
  autocmd BufNewFile,BufRead *.csv   set filetype=csv
  autocmd BufNewFile,BufRead *.dat   set filetype=csv_pipe
]])
-- sudo apt-get install fd-find
