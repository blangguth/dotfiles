"      _  _  __  _  _  ____   ___ 
"     / )( \(  )( \/ )(  _ \ / __)
"    _\ \/ / )( / \/ \ )   /( (__ 
"   (_)\__/ (__)\_)(_/(__\_) \___)
"
"##########
"# about  # My .vimrc config
"# author # blangguth <ben.langguth@gmail.com>
"# code   # https://github.com/blangguth/dotfiles
"##########
"
" Colors {{{
syntax enable               " enable syntax processing
"let g:base16_shell_path=/home/blangguth/code/base16/base16-builder/output/shell/
"let base16colorspace="256"  " Access colors present in 256 colorspace
set t_Co=256
set background=dark
"colorscheme base16-eighties
colorscheme base16-eighties-dark " https://github.com/chriskempson/base16-vim -- fits my style
" }}}

" Spaces and Tabs {{{
set tabstop=4               " number of visual spaces per TAB
set softtabstop=4           " number of spaces in tab when editing
set expandtab               " tabs are spaces
" }}}

" UI config {{{
set number                  " show line numbers
set showcmd                 " show command in bottom bar
filetype indent on          " load filetype-specific indent files
set wildmenu                " visual autocomplete for command menu
set lazyredraw              " redraw only when we need to
set showmatch               " highlight matching [{()}]
set incsearch               " search as characters are entered
set hlsearch                " highlight matches
" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
" }}}

" Folding {{{
set foldenable              " enable folding
set foldlevelstart=10       " open most folds by default
set foldnestmax=10          " 10 nested fold max
" space open/closes folds
nnoremap <space> za
set foldmethod=indent       " fold based on indent level
" }}}

" Movement {{{
" move vertically by visual line
nnoremap j gj
nnoremap k gk
" highlight last inserted text
nnoremap gV `[v`]

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Toggle paste mode on and off
map <leader>ü :setlocal paste!<cr>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
" Remember info about open buffers on close
set viminfo^=%
 
" }}}

" Leader Shortcuts{{{
let mapleader=","           " leader is comma
" jk is escape
inoremap jk <esc>
" toggle gundo
" nnoremap <leader>u :GundoToggle<CR>
" Gundo requires Vim compiled with Python support - and for now I have no
" idea how to achieve that.

" save session
nnoremap <leader>s :mksession<CR>

" open ag.vim
nnoremap <leader>a :Ag

" open Unite
nnoremap <leader>p :Unite file buffer<CR>

nnoremap <leader>n :NERDTreeToggle<CR>

" }}}

" Statusline {{{
" Always show the status line
set laststatus=2
" Format the status line
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
let g:airline_powerline_fonts = 1
let g:airline_theme = 'murmur'
" }}}

" Autogroup {{{
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
                \:call <SID>StripTrailingWhitespaces()
    autocmd FileType java setlocal noexpandtab
    autocmd FileType java setlocal list
    autocmd FileType java setlocal listchars=tab:+\ ,eol:-
    autocmd FileType java setlocal formatprg=par\ -w80\ -T4
    autocmd FileType php setlocal expandtab
    autocmd FileType php setlocal list
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType php setlocal formatprg=par\ -w80\ -T4
    autocmd FileType ruby setlocal tabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal commentstring=#\ %s
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
augroup END
" }}}

" Backups {{{
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup
" }}}

" Custom Functions {{{
" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction
" }}}

" Bundles {{{
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if has('vim_starting')
    if &compatible
        set nocompatible    " Be iMproved
    endif
    " Required:
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
" bundles:
NeoBundle 'Shougo/unite.vim'
NeoBundle 'morhetz/gruvbox'
" NeoBundle 'Gundo'
NeoBundle 'rking/ag.vim'
" NeoBundle 'kien/ctrlp.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'chriskempson/base16-vim'
NeoBundle 'bling/vim-airline'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()

" Required:
filetype plugin indent on
" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

"}}}
