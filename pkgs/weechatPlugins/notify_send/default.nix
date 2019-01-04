{ pkgs, ... }:

with pkgs; stdenv.mkDerivation rec {
  version = "0.8";
  baseName = "weechat-notify-send";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "s3rvac";
    repo = baseName;
    sha256 = "05ny7518jy2h78syb6ip01jz25am809s2hmhlpdl3l3d74lgn7q3";
  };

  buildInputs = [ weechat (mine.weechatPythonPackageList python) ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -a $src/* $out/
  '';
}