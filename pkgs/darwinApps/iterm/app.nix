{ pkgs, appName, mkDarwinApp, fetchurl, ... }:

mkDarwinApp rec {
  inherit appName; 
  version = "3.1.6";
  src = fetchurl {
    url = "https://iterm2.com/downloads/stable/iTerm2-${builtins.replaceStrings ["."] ["_"] version}.zip";
    sha256 = "11q0dg26nm9kx8v2lfn4wxlqzj4zjddf9fafpd4xp7pr90mh3ksa";
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