{ pkgs, lib ? pkgs.lib, debug ? false, ... }:

with lib;

let
  mkBitbarPluginFromMainGithub = {
      category,
      baseName,
      fileExtension,
      inputs ? [],
      propagatedInputs ? [],
      rev ? "330a45002b444b2a3c1c6b4fc52422500dee7567",
      sha256 ? "1an9rjf1r2326wvk5i5bp7ibgnji4f3m5mq8k8bmwkz0hn2cpg1j"
    }: with pkgs; stdenv.mkDerivation rec {
    inherit baseName;
    version = rev;
    name = "${baseName}-${version}";

    src = fetchFromGitHub {
      inherit rev;
      inherit sha256;
      owner = "matryer";
      repo = "bitbar-plugins";
    };

    unpackPhase = "true";

    buildInputs = [ makeWrapper ] ++ inputs;
    propagatedBuildInputs = [ ] ++ propagatedInputs;

    installPhase = ''
      mkdir -p $out/bin
      cp $src/${category}/${baseName}.${fileExtension} $out/bin/${baseName}
      wrapProgram $out/bin/${baseName} --prefix PYTHONPATH : "$PYTHONPATH"
    '';
  };
in mapAttrs' (name: type: {
  name = removeSuffix ".nix" name;
  value = let file = ./. + "/${name}"; in
  lib.callPackageWith (pkgs // {
    inherit mkBitbarPluginFromMainGithub ;
    inherit debug;
    # passwords = import ../../../external/private/passwords/gen.nix;
  }) file {};
}) (filterAttrs (name: type:
  (type == "directory" && builtins.pathExists "${toString ./.}/${name}/default.nix") ||
  (type == "regular" && hasSuffix ".nix" name && ! (name == "default.nix"))
) (builtins.readDir ./.))