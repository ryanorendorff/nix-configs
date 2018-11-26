{ pkgs, stdenv, themeName, sha256, version ? "" }:

stdenv.mkDerivation {
  inherit themeName version;
  name = "${themeName}-theme${if version != "" then "-${version}" else ""}";
  # Download the theme from the wordpress site
  src = pkgs.fetchurl {
    inherit sha256;
    url = "https://downloads.wordpress.org/theme/${themeName}${if version != "" then ".${version}" else ""}.zip";
  };
  # We need unzip to build this package
  buildInputs = [ pkgs.unzip ];
  # Installing simply means copying all files to the output directory
  installPhase = "mkdir -p $out; cp -R * $out/";
}