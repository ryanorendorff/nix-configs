{ pkgs, mkDarwinApp, fetchurl, appName, appMeta, version, sha256, ... }:

mkDarwinApp rec {
  inherit appName;
  inherit appMeta;
  inherit version;

  src = fetchurl {
    inherit sha256;
    url  = "https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v${version}/Google.Play.Music.Desktop.Player.OSX.zip";
    # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
    name = "${ builtins.replaceStrings [" "] ["_"]  appName }.zip";
  };

  buildPhase = false;
  installPhase = false;

  buildInputs = [ pkgs.undmg pkgs.unzip ];
}
