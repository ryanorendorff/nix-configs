{ pkgs, lib ? pkgs.lib, debug ? false, ... }:

with lib;

let
  mkBitbarPluginFromMainGithub = {
      category,
      baseName,
      fileExtension,
      inputs ? [],
      propagatedInputs ? [],
      rev ? "60befeebb91bc1c743e062090c67b16b62eaed77",
      sha256 ? "0014h5rkw5j20ww5gzk4banidkfmkg2r8v620dzlngjf411pk8r8"
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