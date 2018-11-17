{ pkgs, ...}:

pkgs.stdenv.mkDerivation rec{
  name = "cesletterbox-1.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "nocoolnametom";
    repo = "cesletterbox";
    rev = "78c67fdfcde371290fdd20c03fecafc65fefdbab";
    sha256 = "0dmviwhgqqcc3gg5icy3jhnrl4j7sa5w8vgsc8vzb22xl0f10g1q";
  };
  meta = {
    description = "Pages for the CES LetterBox project";
    license = pkgs.stdenv.lib.licenses.gpl3;
    platforms = pkgs.stdenv.lib.platforms.all;
  };
  buildCommand = "";
  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';
}
