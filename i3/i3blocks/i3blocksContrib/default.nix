{ pkgs, ... }:

with pkgs; 
let
  version = "2018-01-17";
  baseName = "i3blocks-contrib";
  src = fetchFromGitHub {
    rev = "72e7afea8e35f63cee5956c84206d5c7b70ddae5";
    sha256 = "1pkqj3kqalnlqisvblqmbq56zqh43afqvnamxfhqy5grq0jc0rl2";
    owner = "vivien";
    repo = baseName;
  };
  mkI3blockContribScript = scriptName: buildDeps: stdenv.mkDerivation rec {
    inherit version;
    inherit src;
    name = "${baseName}-${scriptName}-${version}";

    loc = "./${scriptName}";

    unpackPhase = ''
      cp -a $src/${scriptName} $loc
    '';

    buildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      patchShebangs $loc/*
    '';

    checkPhase = ''
      ${shellcheck}/bin/shellcheck -x $loc/${scriptName}
    '';

    installPhase = ''
      mkdir -p $out
      cp -a $loc/* $out/
      wrapProgram $out/${scriptName} --prefix PATH : ${lib.makeBinPath buildDeps}
    '';
  };
in {
  bandwidth = mkI3blockContribScript "bandwidth" [];
  mediaplayer = mkI3blockContribScript "mediaplayer" [ perl ];
  batterybar = mkI3blockContribScript "batterybar" [ acpi ];
}