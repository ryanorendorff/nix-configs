{ pkgs, mkDarwinApp, fetchurl, appName, appMeta, version, sha256, ... }:

mkDarwinApp rec {
  inherit appName;
  inherit appMeta;
  inherit version;

  src = fetchurl {
    inherit sha256;
    url  = "https://s3.ca-central-1.amazonaws.com/ergodox-ez-configurator/executables/teensy.dmg";
    # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
    name = "${ appName }.dmg";
  };
}