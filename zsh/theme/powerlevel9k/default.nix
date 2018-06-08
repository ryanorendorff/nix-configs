{ pkgs, ... }:

with pkgs; stdenv.mkDerivation rec {
  version = "2018-03-23";
  baseName = "powerlevel9k";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    rev = "0e3c1924fe40835dfe189227b8a165de147e65a1";
    owner = "bhilburn";
    repo = baseName;
    sha256 = "1b8ifsmk1z43gfpz15ld4a49gyclljwvf34flj6q8yd1rrgn2djq";
  };

  installPhase = ''
    mkdir -p $out
    cp -a * $out/
  '';
}