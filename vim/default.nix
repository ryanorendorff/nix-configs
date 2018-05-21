{ pkgs }:

let
  plugins = pkgs.callPackage ./plugins.nix {};
in
{
  customRC = ''
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

    " Use 'jj' to exit Insert Mode
    :imap jj <Esc>

  " NERDTree
    let g:NERDTreeIndicatorMapCustom = {
        \ "Modified"  : "✹",
        \ "Staged"    : "✚",
        \ "Untracked" : "✭",
        \ "Renamed"   : "➜",
        \ "Unmerged"  : "═",
        \ "Deleted"   : "✖",
        \ "Dirty"     : "✗",
        \ "Clean"     : "✔︎",
        \ 'Ignored'   : '☒',
        \ "Unknown"   : "?"
        \ }
    " NERDTress File highlighting
    function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
      exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
      exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
    endfunction
    call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
    call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
    call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
    call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
    call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
    call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
    call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
    call NERDTreeHighlightFile('nix', 'brown', 'none', 'brown', '#151515')
    let g:NERDTreeShowIgnoredStatus = 1
    map <C-b> :NERDTreeToggle<CR>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Ctrl-P
    let g:ctrlp_z_nerdtree = 1
    let g:ctrlp_extensions = ['Z', 'F']

    " GitGutter
    set signcolumn=yes

    " Mouse
    set mouse=a

    " Tsuquyomi
    let g:tsuquyomi_disable_quickfix = 1
    let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.
  '';

  vam = {
    knownPlugins = pkgs.vimPlugins // plugins;

    pluginDictionaries = [
      # from pkgs.vimPlugins
      { name = "vim-addon-nix"; }
      { name = "vim-nix"; }

      # Plugins in order on VimAwesome
      { name = "fugitive"; }
      { name = "nerdtree"; }
      { name = "nerdtree-git-plugin"; }
      { name = "syntastic"; }
      { name = "ctrlp"; }
      { name = "ctrlp-z"; }
      { name = "airline"; }
      { name = "gitgutter"; }
      { name = "vim-airline-themes"; }
      { name = "molokai"; }
      { name = "vim-markdown"; }
      { name = "vim-misc"; }
      { name = "typescript-vim"; }
      { name = "tsuquyomi"; }
      { name = "vim-trailing-whitespace"; }

      # from our own plugin package set
      { name = "vim-javascript-libraries-syntax"; }
      { name = "vim-jsx"; }
    ];
  };
}
