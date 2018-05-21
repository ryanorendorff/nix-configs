{ stdenv, lib, fetchurl, undmg, unzip, ... }:

assert stdenv.isDarwin;

let
  appName = "iTerm";
in
stdenv.mkDerivation rec {
  name = "${lib.toLower appName}-darwin-${version}";
  version = "3.1.5";
  dlName = name;

  src = fetchurl {
    url = "https://iterm2.com/downloads/stable/iTerm2-${builtins.replaceStrings ["."] ["_"] version}.zip";
    sha256 = "0sfpkzw71z8y6qz0dyjvzymskr6gz92rlskd79jn2p7yjrncwnbi";
    name = "${ appName }.zip";
  };

  buildInputs = [ undmg unzip ];
  installPhase = ''
    mkdir -p "$out/Applications/${appName}.app"
    cp -R . "$out/Applications/${appName}.app"
  '';

  postInstall = ''
    ln -f $out/Applications/${appName}.app ~/Applications/${appName}.app
  '';

  meta = with stdenv.lib; {
    description = "iTerm2 is a replacement for Terminal and the successor to iTerm";
    homepage = https://www.iterm2.com/;
    license = {
      free = true;
      url = https://www.iterm2.com/license.txt;
    };
    platforms = platforms.darwin;
  };
}
