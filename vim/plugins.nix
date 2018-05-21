{ pkgs, fetchgit }:

let
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
in {

  "vim-javascript-libraries-syntax" = buildVimPlugin {
    name = "vim-javascript-libraries-syntax";
    src = fetchgit {
      url = "https://github.com/othree/javascript-libraries-syntax.vim";
      rev = "0ab5dcb733a32f3baa9ffffd5711446d0429ceb6";
      sha256 = "0k0zcdz9y1mchdvkn7hsavij658ji15qdamfr1709rp40lv4673c";
    };
    dependencies = [];
  };

  "vim-jsx" = buildVimPlugin {
    name = "vim-jsx";
    src = fetchgit {
      url = "https://github.com/mxw/vim-jsx";
      rev = "eb656ed96435ccf985668ebd7bb6ceb34b736213";
      sha256 = "1ydyifnfk5jfnyi4a1yc7g3b19aqi6ajddn12gjhi8v02z30vm65";
    };
    dependencies = [];
  };

  # more?
}
