{ pkgs, ... }:

with pkgs; stdenv.mkDerivation rec {
  version = "0.6.6";
  baseName = "powerlevel9k";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "bhilburn";
    repo = baseName;
    sha256 = "14ybfshpddmqs2b4blwyq3vhdbywqrgpav1flc5lr3z15sjj3vs6";
  };

  installPhase = ''
    mkdir -p $out
    cp -a * $out/
  '';
}