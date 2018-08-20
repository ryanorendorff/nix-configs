{ pkgs, mkDarwinApp, fetchurl, appName, ... }:

mkDarwinApp rec {
  inherit appName;
  version = "4.6.1";
  src = fetchurl {
    url = "https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v${version}/Google.Play.Music.Desktop.Player.OSX.zip";
    sha256 = "0bpsl61r498gznsyi1yr7nvxr4598kf0y7bcnf3vf0n3h57szfql";
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
