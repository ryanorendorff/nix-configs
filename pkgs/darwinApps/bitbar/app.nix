{ pkgs, mkDarwinApp, fetchurl, appName, version, sha256, appMeta, ... }:

mkDarwinApp rec {
  inherit appName;
  inherit appMeta;
  inherit version;

  src = fetchurl {
    inherit sha256;
    url  = "https://github.com/matryer/bitbar/releases/download/v${version}/BitBar-v${version}.zip";
    # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
    name = "${ builtins.replaceStrings [" "] ["_"]  appName }.zip";
  };

  buildPhase = false;
  installPhase = false;

  buildInputs = [ pkgs.undmg pkgs.unzip ];
}
