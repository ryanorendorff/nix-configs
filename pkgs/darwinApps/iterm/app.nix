{ pkgs, appName, mkDarwinApp, fetchurl, ... }:

mkDarwinApp rec {
  inherit appName; 
  version = "3.1.5";
  src = fetchurl {
    url = "https://iterm2.com/downloads/stable/iTerm2-${builtins.replaceStrings ["."] ["_"] version}.zip";
    sha256 = "0sfpkzw71z8y6qz0dyjvzymskr6gz92rlskd79jn2p7yjrncwnbi";
    name = "${ appName }.zip";
  };

  buildInputs = [ pkgs.undmg pkgs.unzip ];

  appMeta = with pkgs.stdenv.lib; {
    description = "iTerm2 is a replacement for Terminal and the successor to iTerm";
    homepage = https://www.iterm2.com/;
    license = {
      free = true;
      url = https://www.iterm2.com/license.txt;
    };
  };
}