{ pkgs, mkDarwinApp, fetchurl, appName, appMeta, version, sha256, ... }:

mkDarwinApp rec {
  inherit appName;
  inherit appMeta;
  inherit version;

  src = fetchurl {
    inherit sha256;
    url  = "https://dl.pstmn.io/download/latest/osx";
    # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
    name = "${ builtins.replaceStrings [" "] ["_"]  appName }-osx-${version}.zip";
  };

  buildPhase = false;
  installPhase = false;

  buildInputs = [ pkgs.undmg pkgs.unzip ];
}
