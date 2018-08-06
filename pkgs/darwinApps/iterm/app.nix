{ pkgs, appName, mkDarwinApp, fetchurl, ... }:

mkDarwinApp rec {
  inherit appName;
  version = "3.1.7";
  src = fetchurl {
    url = "https://iterm2.com/downloads/stable/iTerm2-${builtins.replaceStrings ["."] ["_"] version}.zip";
    sha256 = "1phy5dcfh8gq8crzchphs663xpicd3bddxzyprjsybpy88y6njfm";
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
