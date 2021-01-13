"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Pre load configurations @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"===============================================================================
"============================ Create undos director ============================
"===============================================================================
if !isdirectory("~/.config/nvim/undos")
    call mkdir("~/.config/nvim/undos", "p")
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
set listchars=tab:\▏\ ,trail:␣   " Show leading tabs and trailing whitspaces
set list                         " Show list chars
set nu                           " Set line numbers
set relativenumber               " Show relative line numbers
set noswapfile                   " Disable swapfiles (not needed with Undotree and undofile)
set t_ut=                        " Disable background color erase (to avoid artifacts in tmux)
set t_Co=256                     " Use 256 colors in terminal emulator
set fillchars+=vert:\▏           " Change vertical windwo split symbol
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
"Change marks char
noremap ' `
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
noremap <leader>bpp <ESC>O<ESC>0iimport pdb; pdb.set_trace();<ESC>j
nnoremap <CR> :noh<CR><CR>
"===============================================================================
"================================== Functions ==================================
"===============================================================================
"============================== Toggle side column
function! g:ToggleSideColumn()
  if &nu == 0
     set number         " Disable line numbers
     set relativenumber " Disable relative numbers
     set signcolumn=yes " Disable signcolumn
     set scl=yes        " Disable Signify column
  else
     set nonumber         " Enable line numbers
     set norelativenumber " Enable relative numbers
     set signcolumn=no    " Enable signcolumn
     set scl=no           " Enable Signify column
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
call plug#begin('~/.config/nvim/plugins') 
    Plug 'TovarishFin/vim-solidity'        " Solodity syntax
    Plug 'chrisbra/csv.vim'                " CSV visualization and functionality
    Plug 'iamcco/markdown-preview.vim'     " Markdown preview support
    Plug 'iamcco/mathjax-support-for-mkdp' " Markdown  mathjax preview
    Plug 'junegunn/fzf'                    " Fuzzy Finder
    Plug 'junegunn/fzf.vim'                " Fuzzy Finder vim integration
    Plug 'junegunn/vim-easy-align'         " Align objects more easily
    Plug 'kassio/neoterm'                  " Easy neovim terminal integration
    Plug 'luochen1990/rainbow'             " highlis parenthesis in different colors
    Plug 'mattn/emmet-vim'                 " HTML Tag completition
    Plug 'mbbill/undotree'                 " Visualize undo branches
    Plug 'mhartington/oceanic-next'        " Ported colorscheme from sublime
    Plug 'norcalli/nvim-colorizer.lua'     " Display color codes in color
    Plug 'ryanoasis/vim-devicons'          " Adds devicons to multiple plugins
    Plug 'scrooloose/nerdtree'             " File Explorer
    Plug 'szw/vim-maximizer'               " Maximize windows
    Plug 'tpope/vim-fugitive'              " Git integration
    Plug 'tpope/vim-surround'              " Surround objects more easyli
    Plug 'vim-airline/vim-airline'         " More Functional Status Bar
    " Coc (Completition/linting/Docs)
    if executable('node')|Plug 'neoclide/coc.nvim',{'branch': 'release'}|else|echom 'Skipping COC'| endif
    " Vim-Signify (Display Code versioning changes)
    if has('nvim') || has('patch-8.0.902')|Plug 'mhinz/vim-signify'|else|Plug 'mhinz/vim-signify',{ 'branch': 'legacy' }|endif
    " Easy ctags managment
    if executable('ctags')|Plug 'ludovicchabant/vim-gutentags'|else|echom 'Skipping vim-gutentags'|endif
    " Jupytext (to edit notebooks)
    if executable('jupytext')|Plug 'goerz/jupytext.vim'|else|echom 'Skipping goerz/jupytext'|endif
call plug#end()
if plug_install
    PlugInstall --sync
endif
unlet plug_install
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Plugins Configurations @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"===============================================================================
"================================ Vim Easy Align ===============================
"===============================================================================
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
"===============================================================================
"=================================== NeoTerm ===================================
"===============================================================================
let g:neoterm_default_mod='vertical'
noremap <leader>ntn :vertical Tnew<cr>
noremap <leader>tnt :Ttoggle<cr><c-w>jA<esc>
"===============================================================================
"================================== jupytext ===================================
"===============================================================================
let g:jupytext_command = 'jupytext' " Set jupytext command (can be path to executable)
let g:jupytext_fmt = 'py:percent'   " Set cell format to #%%
"===============================================================================
"=================================== Emmet =====================================
"===============================================================================
let g:user_emmet_leader_key='\'
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
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_colors = {'border':  ['fg', 'Comment'] }
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.8 } }
"================================ Remaps
noremap <C-P> :Files <CR>
noremap <leader>fh :Files ~<CR>
noremap <leader>fp :Files ~/Proyects<CR>
noremap <leader>fl :Lines <CR>
noremap <leader>fb :Buffers <CR>
noremap <leader>ft :Tags <CR>
"===============================================================================
"=================================== Signify ===================================
"===============================================================================
"
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
nmap <leader> rn <Plug>(coc-rename)
nmap <leader> dg :CocDiagnostics<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
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
"=========================== Configure JSON formating
" json.enable set to false to disable json language server.
call coc#config('json', {'.enable': 'true'})
call coc#config('json', {'.format.enable': 'true'})
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
\ ]
"========================= Configure python interpreter/lints
if $PYENV_VIRTUAL_ENV == ""
    let g:python3_host_prog=system('which python')
else
    let g:python3_host_prog=split(system('pyenv which python'), '\n')[-1] 
endif
call coc#config('python', {'pythonPath': g:python3_host_prog})
call coc#config('python', {'setInterpreter': g:python3_host_prog})
call coc#config('python', {'formatting.provider': 'autopep8'})
call coc#config('python', {'setLinter': 'autopep8'})
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
let NERDTreeMinimalUI = 0
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let NERDTreeIgnore = ['\.git$', '\node_modules']
"===============================================================================
"============================= Style (OceanicNext)  ============================
"===============================================================================
"Plug 'mhartington/oceanic-next'
colorscheme OceanicNext
" Keep background transparent for the colrscheme (must go after setting colorscheme)
highlight Normal guibg=none ctermbg=none
" ColorColumn Color
highlight ColorColumn ctermbg=none guibg=#2c2d27
highlight LineNr guibg=none ctermbg=none
highlight SignColumn guibg=none ctermbg=none

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
" Remove icons padding
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''
let g:webdevicons_enable_nerdtree=1
let g:DevIconsEnableFoldersOpenClose = 1
let g:webdevicons_conceal_nerdtree_brackets = 0
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ' '
let g:DevIconsDefaultFolderOpenSymbol = ' '
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
\}
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

