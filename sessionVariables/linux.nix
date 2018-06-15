{ pkgs, vim ? pkgs.vim, ... }:

rec {
  EDITOR = "${vim}/bin/vim";
  BROWSER = "${pkgs.w3m}/bin/w3m";
}
