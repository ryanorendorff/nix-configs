{ stdenv, lib, fetchurl, undmg, unzip, ... }:

assert stdenv.isDarwin;

let
  appName = "Google Play Music Desktop Player";
in
stdenv.mkDerivation rec {
  name = "${builtins.replaceStrings [" "] ["_"] (lib.toLower appName)}-darwin-${version}";
  version = "4.5.0";
  dlName = name;

  src = fetchurl {
    url = "https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v${version}/Google.Play.Music.Desktop.Player.OSX.zip";
    sha256 = "09nv4xd5xznpqnjyisdcscjyb6ybaawvq4dpdji913d3kz3b0hrd";
    name = "${ builtins.replaceStrings [" "] ["_"]  appName }.zip";
  };

  buildInputs = [ undmg unzip ];
  installPhase = ''
    mkdir -p "$out/Applications/${appName}.app"
    cp -R . "$out/Applications/${appName}.app"
  '';

  postInstall = ''
    ln -f "$out/Applications/${appName}.app" "~/Applications/${appName}.app"
  '';

  meta = with stdenv.lib; {
    description = "A beautiful cross platform Desktop Player for Google Play Music";
    homepage = https://www.googleplaymusicdesktopplayer.com/;
    license = "mit";
    platforms = platforms.darwin;
  };
}
