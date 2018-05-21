{ pkgs }:

pkgs.neovim.override {
  vimAlias = true;
  configure = (import ../vim { pkgs = pkgs; });
}
