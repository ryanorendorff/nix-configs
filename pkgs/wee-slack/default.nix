{ pkgs, ... }:

with pkgs; stdenv.mkDerivation rec {
  version = "2.0.0";
  baseName = "wee-slack";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = baseName;
    repo = baseName;
    sha256 = "0712zzscgylprnnpgy2vr35a5mdqhic8kag5v3skhd84awbvk1n5";
  };


  buildInputs = [ weechat (pkgs.mine.weechatPythonPackageList python) ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share
    cp $src/wee_slack.py $out/share/
  '';

  meta = with stdenv.lib; {
    description = "A rofi emoji picker";
    maintainers = with maintainers; [ nocoolnametom ];
    license = licenses.mit;
  };
}
