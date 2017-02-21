set number
syntax on
filetype indent on
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set ruler
colorscheme desert
set background=dark
set visualbell
set mouse=a
set laststatus=2
set statusline=%t "tail of filename
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
