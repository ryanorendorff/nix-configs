{ pkgs, mkDarwinApp, fetchurl, ... }:

mkDarwinApp rec {
  appName = "Google Play Music Desktop Player";
  version = "4.5.0";
  src = fetchurl {
    url = "https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v${version}/Google.Play.Music.Desktop.Player.OSX.zip";
    sha256 = "09nv4xd5xznpqnjyisdcscjyb6ybaawvq4dpdji913d3kz3b0hrd";
    name = "${ builtins.replaceStrings [" "] ["_"]  appName }.zip";
  };

  buildPhase = false;
  installPhase = false;

  buildInputs = [ pkgs.undmg pkgs.unzip ];

  appMeta = with pkgs.stdenv.lib; {
    description = "A beautiful cross platform Desktop Player for Google Play Music";
    homepage = https://www.googleplaymusicdesktopplayer.com/;
    license = "mit";
  };
}
