"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Pre load configurations @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"===============================================================================
"============================ Create undos director ============================
"===============================================================================
if !isdirectory($HOME."/.config/nvim/undos")
    call mkdir($HOME."/.config/nvim/undos", "p")
endif
"===============================================================================
"==================== Create custom syntax files directories ===================
"===============================================================================
let custom_syntax_dir_path=$HOME."/.config/nvim/after/syntax/"
if !isdirectory(custom_syntax_dir_path)
    call mkdir(custom_syntax_dir_path, "p")
endif
"===============================================================================
"=========================== Auto-Install Vim-Plug =============================
"===============================================================================
let plug_install = 0
let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(autoload_plug_path)
    silent exe '!curl -fL --create-dirs -o ' . autoload_plug_path . 
        \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    execute 'source ' . fnameescape(autoload_plug_path)
    let plug_install = 1
endif
unlet autoload_plug_path
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Built-In Configurations @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"===============================================================================
"============================ General Configurations ===========================
"===============================================================================
" Dont hide any character
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" Change leader key to space (Default \)
let mapleader = " " 
" Set jupyter notebooks filetype
au VimEnter,BufRead,BufNewFile *.ipynb set filetype=python
"===============================================================================
"===================================== Sets ====================================
"===============================================================================
set undodir=~/.config/nvim/undos " set undofile
set undofile                     " Use undofile
set updatetime=100               " Faster update time for CursorHold/CursorHoldI (default 4000)
set termguicolors                " Enable 24-bit RGB colors in the Terminal Emulator
set listchars=tab:\│\ ,trail:␣   " Show leading tabs and trailing whitspaces
set list                         " Show list chars
set nu                           " Set line numbers
set relativenumber               " Show relative line numbers
set noswapfile                   " Disable swapfiles (not needed with Undotree and undofile)
set t_ut=                        " Disable background color erase (to avoid artifacts in tmux)
set t_Co=256                     " Use 256 colors in terminal emulator
set fillchars+=vert:\│           " Change vertical windwo split symbol
set colorcolumn=120              " Mark column number 120
set tabstop=4                    " The width of a TAB is set to 4.
set shiftwidth=4                 " Indents will have a width of 4
set softtabstop=4                " Sets the number of columns for a TAB
set expandtab                    " Expand TABs to spaces"
set ignorecase                   " Ignore case when searching
set smartcase                    " Ignore case unless uppercase is used
set hlsearch                     " Highlight search while typing
set incsearch                    " Highligts searches on the run
set encoding=UTF-8               " set encoding
set showmatch                    " Show matching brackets
set scrolloff=8                  " scroll before reaching end/top
set nowrap                       " Avoid textwrapping
syntax on                        " Turn on syntax highlight
syntax enable                    " Turn on syntax highlight
"===============================================================================
"==================================== Remaps ===================================
"===============================================================================
"Easy resize
noremap <leader>+ :res +15<CR>
noremap <leader>- :res -15<CR>
noremap <leader>< :vert :res -15<CR>
noremap <leader>> :vert :res +15<CR>
" Easy buffers managment
noremap <leader>bn :bn <CR>
noremap <leader>bp :bp <CR>
noremap <leader>bd :bp\|bd #<CR>
" Insert python breakpoint
noremap <leader>bpp <ESC>O<ESC>0iimport ipdb; ipdb.set_trace();<ESC>j
nnoremap <CR> :noh<CR><CR>
" Exit insert mode in terminal
tnoremap <Esc> <C-\><C-n>
"===============================================================================
"================================== Functions ==================================
"===============================================================================
"============================== Toggle conceallevel
function! g:ToggleConcealLevel()
  if &conceallevel == 0
    set conceallevel=2         " Enable conceal
  else
    set conceallevel=0         " Disable conceal
    execute ":IndentLinesDisable"
  endif
endfunction
nnoremap <silent> <leader>tc :call g:ToggleConcealLevel()<cr>
"============================== Toggle side column
function! g:ToggleSideColumn()
  if &nu == 0
    set number         " Disable line numbers
    set relativenumber " Disable relative numbers
    set signcolumn=yes " Disable signcolumn
    set scl=yes        " Disable Signify column
    execute ":IndentLinesEnable"
  else
    set nonumber         " Enable line numbers
    set norelativenumber " Enable relative numbers
    set signcolumn=no    " Enable signcolumn
    set scl=no           " Enable Signify column
    execute ":IndentLinesDisable"
  endif
endfunction
nnoremap <silent> <leader>lt :call g:ToggleSideColumn()<cr>
"============================== Paste mode autotoggle (avoid wrong indentation)
" function to handle pastes in tmux
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif
  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"
  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
  " ColorColumn Color
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
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Plugins @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"===============================================================================
"=================================== Vim Plug ==================================
"===============================================================================
call plug#begin('~/.config/nvim/plugins') 
    Plug 'TovarishFin/vim-solidity'                        " Solodity syntax
    Plug 'chrisbra/csv.vim'                                " CSV visualization and functionality
    Plug 'junegunn/vim-easy-align'                         " Align objects more easily
    Plug 'mattn/emmet-vim'                                 " HTML Tag completition
    Plug 'mbbill/undotree'                                 " Visualize undo branches
    Plug 'mhartington/oceanic-next'                       " Ported colorscheme from sublime
    "Plug 'ayu-theme/ayu-vim'                               " Ayu colorscheme
    Plug 'norcalli/nvim-colorizer.lua'                     " Display color codes in color
    Plug 'skywind3000/asyncrun.vim'
    Plug 'Yggdroot/indentLine'                             " Indent line
    Plug 'ryanoasis/vim-devicons'                          " Adds devicons to multiple plugins
    Plug 'scrooloose/nerdtree'                             " File Explorer
    Plug 'vwxyutarooo/nerdtree-devicons-syntax'
    Plug 'junegunn/fzf'                                    " Fuzzy Finder
    Plug 'junegunn/fzf.vim'                                " Fuzzy Finder vim integration
    Plug 'hkupty/iron.nvim', { 'branch': 'direct-invoke' } " REPL Manager
    Plug 'vim-airline/vim-airline'                         " More Functional Status Bar
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']} " Markdown preview
    Plug 'iamcco/mathjax-support-for-mkdp'                 " Markdown  mathjax preview
    Plug 'szw/vim-maximizer'                               " Maximize windows
    Plug 'tpope/vim-fugitive'                              " Git integration
    Plug 'tpope/vim-surround'                              " Surround objects more easyli
    Plug 'dag/vim-fish'                                    " Fish syntax
    " Vim-Signify (Display Code versioning changes)
    if has('nvim') || has('patch-8.0.902')|Plug 'mhinz/vim-signify'|else|Plug 'mhinz/vim-signify',{ 'branch': 'legacy' }|endif
    " Jupytext (to edit notebooks)
    if executable('jupytext')|Plug 'goerz/jupytext.vim'|else|echom 'Skipping goerz/jupytext'|endif
    " Coc (Completition/linting/Docs)
    if executable('node')|Plug 'neoclide/coc.nvim',{'branch': 'release'}|else|echom 'Skipping COC'| endif
    " Easy ctags managment
    if executable('ctags')|Plug 'ludovicchabant/vim-gutentags'|else|echom 'Skipping vim-gutentags'|endif
call plug#end()
if plug_install
    PlugInstall --sync
endif
unlet plug_install
"===============================================================================
"=================================== Scripts ===================================
"===============================================================================
"================================= Hive Syntax
if !filereadable(custom_syntax_dir_path.'hive.vim')
    echo 'Downloading hive syntax script'
    silent exe '!wget -O '. 
                \ custom_syntax_dir_path. 
                \ 'hive.vim https://raw.githubusercontent.com/autowitch/hive.vim/master/syntax/hive.vim'
endif
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Plugins Configurations @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"===============================================================================
"=========================== nerdtre syntax highlight ==========================
"===============================================================================
let g:webdevicons_conceal_nerdtree_brackets = 0
let g:WebDevIconsDisableDefaultFolderSymbolColorFromNERDTreeDir = 1
let g:WebDevIconsDisableDefaultFileSymbolColorFromNERDTreeFile = 1
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

"===============================================================================
"================================= indent line =================================
"===============================================================================
let g:indentLine_char_list = ['▏']
let g:indentLine_enabled = 1

"===============================================================================
"================================= Hive Syntax =================================
"===============================================================================
au BufNewFile,BufRead *.hql set filetype=hive expandtab
au BufNewFile,BufRead *.q set filetype=hive expandtab
"===============================================================================
"=================================== Iron-Vim ==================================
"===============================================================================

lua << EOF
local iron = require('iron')
iron.core.set_config{
    repl_open_cmd = 'rightbelow vertical split',
    preferred = {
      python = "ipython"
    }
}


EOF
"map <F5> <Cmd>lua require("iron").core.send(vim.api.nvim_buf_get_option(0,"ft"), vim.api.nvim_buf_get_lines(0, 0, -1, false))<Cr>
noremap <leader>rt :IronRepl<CR>
noremap <leader>rr :IronRestart<CR>
noremap <leader>rf :IronFocus<CR>

function SendCellIron()
    let l:first_line=search('#%%', 'b')
    let l:last_line=search('#%%')
    echo ''.l:first_line
    echo ''.l:last_line
    exec 'normal! :IronSend! "asdasd"'
endf
nnoremap <C-n> :call SendCellIron()<CR>

"===============================================================================
"================================ Vim Easy Align ===============================
"===============================================================================
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '#': { 'pattern': '#' },
\ }
"===============================================================================
"=================================== NeoTerm ===================================
"===============================================================================
"let g:neoterm_default_mod='vertical'
"noremap <leader>ntn :vertical Tnew<cr>
"noremap <leader>tnt :Ttoggle<cr><c-w>jA<esc>
"===============================================================================
"================================== jupytext ===================================
"===============================================================================
let g:jupytext_command = 'jupytext' " Set jupytext command (can be path to executable)
let g:jupytext_fmt = 'py:percent'   " Set cell format to #%%
"===============================================================================
"=================================== Emmet =====================================
"===============================================================================
let g:user_emmet_leader_key='?'
"===============================================================================
"================================== Rainbow ====================================
"===============================================================================
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
\	'separately': {
\		'markdown': {
\			'parentheses_options': 'containedin=markdownCode contained',
\		},
\		'vim': {
\			'parentheses_options': 'containedin=vimFuncBody',
\		},
\		'css': 0,
\	}
\}
"===============================================================================
"=============================== Vim Maximizer =================================
"===============================================================================
"Toggle maximizer
nnoremap mw :MaximizerToggle<cr>
"===============================================================================
"============================= Fuzzy Finder (fzf) ==============================
"===============================================================================
"================================ Popup Layout configuration
let $FZF_DEFAULT_COMMAND = "find -L"
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_colors = {'border':  ['fg', 'Comment'] }
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.8 } }
"================================ Remaps
noremap <C-P> :Files %:p:h<CR>
noremap <leader>fh :Files $HOME<CR>
noremap <leader>fp :Files $HOME/Proyects<CR>
noremap <leader>fl :Lines <CR>
noremap <leader>fb :Buffers <CR>
noremap <leader>ft :Tags <CR>
"===============================================================================
"=================================== Signify ===================================
"===============================================================================
" Disable signify bu default
let g:signify_disable_by_default = 1
"==================================== Remaps
"Show diff of whole file
nnoremap <leader>sd :SignifyDiff<cr>
"Show diff of hunk
nnoremap <leader>shd :SignifyHunkDiff<cr>
" Undo touched hunk under cursor
nnoremap <leader>shu :SignifyHunkUndo<cr>
" Toggle sideline and highlight
" Fold untouch lines
nnoremap <leader>sft <Plug>(signify-toggle-fold)
" hunk jumping
nmap <leader>sj <plug>(signify-next-hunk)
nmap <leader>sk <plug>(signify-prev-hunk)
"=================================== Toggle Signify
let g:signfy_enabled=0
function! g:SignifyToggleAll()
    if   g:signfy_enabled==0
        call sy#start_all() | call sy#highlight#line_toggle()
        let g:signfy_enabled=1
    else
        call sy#highlight#line_toggle() | call sy#stop_all()
        let g:signfy_enabled=0
    endif
endfunction
nnoremap <silent><leader>st : call g:SignifyToggleAll()<cr>
"===============================================================================
"=============================== Markdown Preview ==============================
"===============================================================================
nmap <silent> <F8> <Plug>MarkdownPreview
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
"===============================================================================
"======================= Colorizer (Display color codes) =======================
"===============================================================================
lua require'colorizer'.setup()
"===============================================================================
"===================================== COC =====================================
"===============================================================================
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>dg :CocDiagnostics<cr>
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gy <Plug>(coc-type-definition)
nmap <silent>gi <Plug>(coc-implementation)
nmap <silent>gr <Plug>(coc-references)
"================ Use K to show documentation in preview window.
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>
"============================= Forma selected lines
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
"============================= Configure Extensions
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
\ 'coc-toml',
\ 'coc-python',
\ 'coc-rls',
\ 'coc-fish',
\ 'coc-snippets',
\ ]
"========================= 
"Setup python path
" Wors case scenario, configure it manually every time :CocCommand python.setInterpreter
"!!!!!!!!!! pynvim must be installed python3 -m pip install pynvim
if $PYENV_VIRTUAL_ENV == ""
    let g:python3_host_prog=system('which python')
else
    let g:python3_host_prog=$PYENV_VIRTUAL_ENV.'/bin/python3'
endif
" Autinstall jedi
function Autoinstall_jedi()
  let l:python3_neovim_path = substitute(system("python3 -c 'import jedi; print(jedi.__path__)' 2>/dev/null"), '\n\+$', '', '')
  if empty(l:python3_neovim_path)
    execute ("!python3 -m pip install jedi")
  endif
endfunction
" Auto install pynvim
function Autoinstall_pynvim()
  let l:python3_neovim_path = substitute(system("python3 -c 'import pynvim; print(pynvim.__path__)' 2>/dev/null"), '\n\+$', '', '')
  if empty(l:python3_neovim_path)
    execute ("!python3 -m pip install pynvim")
  endif
endfunction
" Auto install flake8
function Autoinstall_flake8()
  let l:python3_neovim_path = substitute(system("python3 -c 'import flake8; print(flake8.__path__)' 2>/dev/null"), '\n\+$', '', '')
  if empty(l:python3_neovim_path)
    execute ("!python3 -m pip install flake8")
  endif
endfunction
" Auto install autopep8
function Autoinstall_autopep8()
  let l:python3_neovim_path = substitute(system("python3 -c 'import autopep8; print(autopep8.__path__)' 2>/dev/null"), '\n\+$', '', '')
  if empty(l:python3_neovim_path)
    execute ("!python3 -m pip install autopep8")
  endif
endfunction
" Must use VimEnter to make sure coc is loaded
autocmd VimEnter *
\    call Autoinstall_pynvim()
\|    call Autoinstall_flake8()
\|    if exists('g:did_coc_loaded')
\|      call coc#config('python', {'pythonPath': g:python3_host_prog})
\|      call coc#config('python', {'setInterpreter': g:python3_host_prog})
\|      call coc#config('python', {'setLinter': 'flake8'})
\|      call coc#config('python', {'formatting.provider': 'autopep8'})
\|      call coc#config('python', {'python.globalModuleInstallation': 'true'})
\|      call coc#config('json', {'.enable': 'true'})
\|      call coc#config('json', {'.format.enable': 'true'})
\|      call coc#config('suggestions', {'.floatEnable': 'true'})
\|   endif
"========================= Format Selected with :format
command! -nargs=0 Format :call CocAction('format')
"============================= Coc tab completition
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
"========================= Coc floating windows scroll
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif
"===============================================================================
"=================================== NerdTree ==================================
"===============================================================================
" Show hidden files
let NERDTreeShowHidden=1
" Open when no argument is given to vim
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close Vim when NERDTree is the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle NerdTree
map <leader>ntt :NERDTreeToggle<CR>
" Remove dir arrow
let NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let NERDTreeIgnore = ['\.git$', '\node_modules', '\.pyc$', '__pycache__']
let NERDTreeHighlightCursorline = 0
"===============================================================================
"================================= Style (Ayu) =================================
"===============================================================================
let ayucolor="dark"   " for dark version of theme (dark/mirage/light)
colorscheme OceanicNext "ayu
" Keep background transparent for the colrscheme (must go after setting colorscheme)
highlight Normal guibg=none ctermbg=none
" ColorColumn Color
"highlight ColorColumn ctermbg=none guibg=#2c2d27
highlight LineNr guibg=none ctermbg=none
highlight SignColumn guibg=none ctermbg=none
highlight EndOfBuffer guibg=NONE ctermbg=NONE
highlight VertSplit ctermbg=NONE ctermfg=NONE cterm=NONE guifg=none guibg=white
set notermguicolors     " Hack to allow transparent split window
"===============================================================================
"=================================== Airline ===================================
"===============================================================================
" Use powerline symbols
let g:airline_powerline_fonts = 1
" Show opened buffers when one tab is opened
let g:airline#extensions#tabline#enabled = 1
"===============================================================================
"===================================== CSV =====================================
"===============================================================================
" Show file separator instead of pipe
let g:csv_no_conceal = 1
" Use al rows to determin column width (by default only uses 10K)
"let b:csv_arrange_use_all_rows = 1
let g:csv_no_progress = 1
let g:csv_nomap_up=1
let g:csv_nomap_down=1
" Avoid analyzing all the file to determin delimiter
let g:csv_start = 1
let g:csv_end = 200
"===============================================================================
"=================================== DevIcons ==================================
"===============================================================================
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ' '
let g:webdevicons_enable_nerdtree = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
"let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ' '
"let g:DevIconsDefaultFolderOpenSymbol = ' '
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ' '
let g:DevIconsDefaultFolderOpenSymbol = ' '
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Custom Vim Scripts @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"===============================================================================
"======================= Function to format line as Title ======================
"===============================================================================
"========================== Coments symbol dictionary
let g:titlify_max_width=120
let g:titlify_min_width=80
let g:titlify_comments_config={
\'vim':'"',
\'ts':'//',
\'py':'#',
\'ipynb':'#',
\'js':'#',
\'html':'<!--',
\'sql':'--',
\'hql':'--',
\}

"========================= function to call cht.sh
command! -nargs=+ Help :call Help(<q-args>)
fun! Help(...)
    echo a:1
	let argsl = split(a:args, ' ')
	" execute 'AsyncRun -mode=terminal curl cht.sh/'.'EEE'.a:args[1]
endfun
"========================= function to format as title
function Titlify(...) range
    " To avoid issues with autoformatting
    set formatoptions-=cro
    " Get file extension
    let l:file_extension=expand('%:e')
    let l:comment_symbol_lang=get(g:titlify_comments_config, l:file_extension, '')
    " Get titlewidth
    let l:titlify_width=nr2char(getchar())
    " Set title length
    if (l:titlify_width == 'f')
        let l:max_width=g:titlify_max_width
    elseif (l:titlify_width == 's')
        let l:max_width=g:titlify_min_width
    else
        echom 'Titlify: Invalid Option'
        return 1
    endif
    "Set title type
    let l:title_type=get(a:,1,'title')
    " Get symbol
    let l:comment_symbol=nr2char(getchar())
    "  Strip trailing spaces
    let l:line=substitute(getline('.'), '^\s*', '\1', '')
    " Compute widths
    let l:line_width=strwidth(l:line)
    let l:has_odd_width=(l:line_width % 2) != 0
    let l:width_based_repeat=(l:max_width - 1 - l:has_odd_width - l:line_width) /2
    " Build text wrapper lines
    let l:comment_symbol_left=l:comment_symbol_lang.repeat(l:comment_symbol,  l:width_based_repeat)
    let l:comment_symbol_right=repeat(l:comment_symbol,  l:width_based_repeat + l:has_odd_width - 1)
    let l:titlified_line=l:comment_symbol_left.' '.l:line
    if (l:title_type != 'halfsubtitle')
        let l:titlified_line= l:titlified_line.' '.l:comment_symbol_right
    endif
    if (l:title_type == 'title')
        " Build top/bottom wrapper lines
        let l:wrapper_line=l:comment_symbol_lang.repeat(l:comment_symbol,  strwidth(l:titlified_line) - 1)
        let l:titlified_line=l:wrapper_line."\n".l:titlified_line."\n".l:wrapper_line
    endif
    exe "normal! ddO\<esc>0i".l:titlified_line
    set formatoptions+=cro
endf
"============================ Titlify mappings
noremap <leader>tt :call Titlify('title')<CR>
noremap <leader>ts :call Titlify('subtitle')<CR>
noremap <leader>th :call Titlify('halfsubtitle')<CR>
