{ ... }:

''
  filetype plugin indent on
  syntax enable
  set hidden
  set number
  set relativenumber
  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber
  set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab
  colorscheme molokai
  let g:rehash256 = 1
  :imap jj <Esc>
''