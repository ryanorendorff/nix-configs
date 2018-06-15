{ pkgs, ... }:

with pkgs; stdenv.mkDerivation rec {
  version = "1.3.0";
  baseName = "weechat-notification-center";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    rev = "${version}";
    owner = "sindresorhus";
    repo = baseName;
    sha256 = "1zkh0g2qlks4r4m41n32wscbcxwy69myr480a731m8ss25v9l4jc";
  };

  buildInputs = [ weechat (mine.weechatPythonPackageList python) ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -a $src/* $out/
  '';
}