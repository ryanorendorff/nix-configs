{ pkgs, mkDarwinApp, fetchurl, appName, appMeta, version, sha256, ... }:

mkDarwinApp rec {
  inherit appName;
  inherit appMeta;
  inherit version;

  src = fetchurl {
    inherit sha256;
    url  = "https://iterm2.com/downloads/stable/iTerm2-${builtins.replaceStrings ["."] ["_"] version}.zip";
    # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
    name = "${ builtins.replaceStrings [" "] ["_"]  appName }.zip";
  };

  buildInputs = [ pkgs.undmg pkgs.unzip ];
}
