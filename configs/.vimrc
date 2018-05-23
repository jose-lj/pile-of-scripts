set number
syntax on
filetype plugin indent on
set tabstop=4    " show existing tab as 4 spaces
set shiftwidth=4 " insert 4 spaces on tab press
set tabstop=4    " use 4 space width when indenting with '>'
set expandtab
set ruler
colorscheme desert
set background=dark
set visualbell
set mouse=a
set laststatus=2
set statusline=%F "tail of filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set directory=$HOME/.vim/swapfiles//
set backupdir=$HOME/.vim/backups//
set colorcolumn=80
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>
highlight ColorColumn ctermbg=DarkGray guibg=DarkGray
