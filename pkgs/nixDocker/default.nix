{ pkgs, ... }:

{
  hostname = "nix-docker";
  pkg = pkgs.stdenv.mkDerivation rec {
    version = "2018-11-26";
    baseName = "nix-docker";
    name = "${baseName}-${version}";

    src = pkgs.fetchFromGitHub {
      rev = "2f499c710f7f39b2db416826cc48bdc873c7d74c";
      owner = "LnL7";
      repo = baseName;
      sha256 = "17syh27jzi1ns2l0fh81jyp1nnid54l31a42swfr1l3q7iv02sfh";
    };

    installPhase = ''
      mkdir -p $out
      cp -a * $out/
      chmod 0600 $out/ssh/insecure_rsa
    '';
  };
}