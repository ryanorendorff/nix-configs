{ pkgs, ...}:

pkgs.stdenv.mkDerivation rec{
  version = "1.3.0";
  name = "lds-beacon-pages-${version}";
  src = pkgs.fetchFromGitHub {
    owner = "nocoolnametom";
    repo = "lds-beacon-pages";
    rev = "v${version}";
    sha256 = "0dd8hf8g1scdaz18hkh0a8w6i4gr5mk70qm7bhaks6y30vm2fxl6";
  };
  meta = {
    description = "Pages for Beacons to display";
    license = pkgs.stdenv.lib.licenses.gpl3;
    platforms = pkgs.stdenv.lib.platforms.all;
  };
  buildCommand = "";
  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';
}
