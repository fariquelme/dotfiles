" Author: Felipe Riquelme <fariquelme@uc.cl>
" File: ~/.config/nvim/init.vim

"############################
"######### VIM-PLUG #########
"############################

"======== Auto-Install Vim-Plug 
let plug_install = 0
let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(autoload_plug_path)
    silent exe '!curl -fL --create-dirs -o ' . autoload_plug_path . 
        \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    execute 'source ' . fnameescape(autoload_plug_path)
    let plug_install = 1
endif
unlet autoload_plug_path

"======== Install Plugins
call plug#begin('~/.config/nvim/plugins')
    " NerdTree Navigator (File Explorer)
    Plug 'scrooloose/nerdtree'
    " Gruvbox theme (Better colors)
    Plug 'morhetz/gruvbox'
    " Airline status bar (More Functional Status Bar)
    Plug 'vim-airline/vim-airline'
    " CSV (CSV visualization and functionality)
    Plug 'chrisbra/csv.vim'
    " Coc.NVIM (Autocompletition)
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Colorizer (Display code colors)
    Plug 'norcalli/nvim-colorizer.lua'
    " CtrlP (fuzzy file search)
    Plug 'ctrlpvim/ctrlp.vim'
    " Vim-Signify (Git Differences)
    if has('nvim') || has('patch-8.0.902')
        Plug 'mhinz/vim-signify'
    else
        Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
    endif
    " vim-gutentags (Autogenerate/Mantain ctags)
    if executable('ctags')
        Plug 'ludovicchabant/vim-gutentags' "Manage tags (auto)
    else
        echo 'Skipping vim-gutentags, ctags is not installed'
    endif
    ""Markdown Preview for VIM with Mathjax Support
    Plug 'iamcco/mathjax-support-for-mkdp'
    Plug 'iamcco/markdown-preview.vim'
    " Window Maximizer (to break/restore window from tabs)
    Plug 'szw/vim-maximizer'
    "HTML Tag Completition"
    Plug 'mattn/emmet-vim'
    " Vim Surround
    Plug  'tpope/vim-surround'
    "Align code
    Plug 'junegunn/vim-easy-align'
    ""Solidity Syntax"
    "Plug 'TovarishFin/vim-solidity'
call plug#end()

if plug_install
    PlugInstall --sync
endif
unlet plug_install

"##########################################
"######### Plugins Configurations #########
"##########################################


"============ Vim Maximizer
"Toggle maximizer
nnoremap mw :MaximizerToggle<cr>

"============ CtrlP
"Ignore some files and dirs
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist|__pycache__)|(\.(swp|swo|ico|git|svn))$'

"============ Signify
" Faster sign updates on CursorHold/CursorHoldI
set updatetime=100
" Git Blame
nnoremap <leader>gb :exe "!git blame -L" . line("."). ",+8 %"<cr>
nnoremap <leader>gl :exe "!git log -n 8"<cr>

"Show diff of whole file
nnoremap <leader>sd :SignifyDiff<cr>
"Show diff of hunk
nnoremap <leader>shd :SignifyHunkDiff<cr>
" Undo touched hunk under cursor
nnoremap <leader>shu :SignifyHunkUndo<cr>
" Toggle sideline and highlight
nnoremap <leader>st :SignifyToggle<cr>:SignifyToggleHighlight<cr>
" Fold untouch lines
nnoremap <leader>st <Plug>(signify-toggle-fold)
" hunk jumping
nmap <leader>sj <plug>(signify-next-hunk)
nmap <leader>sk <plug>(signify-prev-hunk)

"============ Markdown Preview
let g:mkdp_auto_close = 1
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ }

"============ Colorizer
set termguicolors
lua require'colorizer'.setup()

"============ COC
" Configure Extensions
let g:coc_global_extensions = [
\ 'coc-ultisnips',
\ 'coc-json',
\ 'coc-tsserver',
\ 'coc-html',
\ 'coc-css',
\ 'coc-yaml',
\ 'coc-highlight',
\ 'coc-emoji',
\ 'coc-vimlsp',
\ 'coc-prettier',
\ ]

" Configure python interpreter
if $PYENV_VIRTUAL_ENV == ""
    let g:python3_host_prog=system('which python')
else
    let g:python3_host_prog=split(system('pyenv which python'), '\n')[-1] 
endif
call coc#config('python', {'pythonPath': g:python3_host_prog})
" Configure python formatter
call coc#config('python', {'formatting.provider': 'autopep8'})

" Format Selected with :format
command! -nargs=0 Format :call CocAction('format')

" Coc tab completition
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_next = '<tab>'
"Forma selected lines
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)






"============ NERDTREE
" Show hidden files
let NERDTreeShowHidden=1
" Open when no argument is given to vim
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close Vim when NERDTree is the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle NerdTree
map <C-n> :NERDTreeToggle<CR>

"============ Gruvbox
let g:gruvbox_italic = 0
" Higher contrast (light/dark)
let g:gruvbox_contrast_dark = 'hard'
" Highlight column
let g:gruvbox_color_column='bg2'
" Margin numbers column colot
let g:gruvbox_number_column='bg1'
" Vertical split color
let g:gruvbox_vert_split='bg1'
" Terminal Colors
let g:gruvbox_termcolors=256


"============ Airline
" Use powerline symbols
let g:airline_powerline_fonts = 1
" Show opened buffers when one tab is opened
let g:airline#extensions#tabline#enabled = 1
" Status bar on top
"let g:airline_statusline_ontop=1

"============ CSV
" Show file separator instead of pipe
let g:csv_no_conceal = 1
let b:csv_arrange_use_all_rows = 1
let g:csv_no_progress = 1

"#########################################
"########## NVIM Configurations ##########
"#########################################


"============ Persist undo history
"Persist undo history between buffers/restarts"
" Persistent undo
if has('persistent_undo')
  " Just make sure you don't run 'sudo vim' right out of the gate and make
  " ~/.config/nvim/undos owned by root.root (should probably use sudoedit anyhow)
  let undo_base = expand("~/.config/nvim/undos")
  if !isdirectory(undo_base)
    call mkdir(undo_base)
  endif
  let undodir = expand("~/.config/nvim/undos/$USER")
  if !isdirectory(undodir)
    call mkdir(undodir)
  endif
  set undodir=~/.config/nvim/undos/$USER/
  set undofile
endif


"============ Paste mode autotoggle
" function to handle pastes in tmux
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif
  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"
  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

" function to handle pastes without tmux
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()


"============ Visible Characters
"Set visible characters list
            set listchars=tab:\▏\ ,trail:␣
set list"

"============ Line Numbers
" Show line numbers
set nu
" Set relative line numbers
set relativenumber

" use Ctrl+L to toggle the line number counting method
function! g:ToggleLineNumbers()
  if &nu == 0
     set nu   " turn off nu
     set rnu
  else
     set nornu   " turn off rnu
     set nonu
  endif
endfunction
nnoremap <silent><C-L> :call g:ToggleLineNumbers()<cr>

"============ Status Bar
" Always show bottom statusbar
set laststatus=2

"============ Syntax
"" Enable syntax Highlight
syntax on

"============ Style
"Set Color Scheme
colorscheme gruvbox
" Change Vertical split symbol
set fillchars+=vert:\▏
" Mark column number 120
set colorcolumn=120
" Keep background transparent for the colrscheme
hi Normal guibg=NONE ctermbg=NONE
" To avoid background issues with tmux
set t_ut=


"============ Indentation
"Spaces instead of tabs
set tabstop=4       " The width of a TAB is set to 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces"

"============ Search
" use Ctrl+S to toggle the line number counting method
function! g:ToggleCaseSensitiveSearch()
    if &ignorecase == 0
        "Ignore Case when
        set ignorecase
    else
        set noignorecase
    endif
endfunction
nnoremap <silent><C-S> :call g:ToggleCaseSensitiveSearch()<cr>

"Highlight search while typing
set hlsearch
"Highligts searches on the run
set incsearch
"This unsets the 'last search pattern' register by hitting return
nnoremap <CR> :noh<CR><CR>

"============ Code Blocks Delimiters
"Show matching brackets
set showmatch

"============ Yank Behaviour
" map paste, yank, delete and cut to named register so the content
" will not be overwritten
nnoremap d "xd
vnoremap d "xd
nnoremap y "xy
vnoremap y "xy
nnoremap p "xp
vnoremap p "xp
nnoremap x "xx
vnoremap x "xx

"============ Marks
"Mark always to last position
noremap ' `

"============ Windows managment

"Easy resize
"noremap + :res +5<CR>
"noremap - :res -5<CR>
"noremap <C-W>< :vert :res -5<CR>
"noremap <C-W>> :vert :res +5<CR>

"============ Buffers managment
noremap bn :bn <CR>
noremap bp :bp <CR>
noremap bd :bp\|bd #<CR>

"============ Python functions
" Run visual block of python code
fu PyRun() range
    echo system('python -c ' . shellescape(join(getline(a:startinline, a:endinglastline), "\n")))
endf
vmap <C-Y> :call PyRun()<CR>

" Insert pdb trace
noremap <leader>pdb <ESC>Oimport pdb; pdb.set_trace();<ESC>j

"============ Emmet HTML
let g:user_emmet_leader_key=','
