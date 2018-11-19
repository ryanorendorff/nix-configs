{ pkgs, lib, stdenv, ...}:

pkgs.stdenv.mkDerivation (rec {
  version = "1.0.0";
  name = "doggett_publicsite-${version}";
  src = pkgs.fetchFromGitHub {
    owner = "nocoolnametom";
    repo = "publicsite";
    rev = "${version}";
    sha256 = "1zc8lgac4r3qal3xzmfxf5kc201zj0s942wwxr0klljr63f0fka7";
  };
  meta = {
    description = "Tom Doggett's Professional Pages";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
  buildCommand = "";
  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';
})
