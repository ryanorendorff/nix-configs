{ pkgs, lib ? pkgs.lib, debug ? false, ... }:

with lib;

let
  pluginLangs = {
    guile = "guile";
    javascript = "javascript";
    lua = "lua";
    perl = "perl";
    python = "ruby";
    tcl = "tcl";
  };
  mkWeechatPluginFromMainGithub = {
      lang,
      baseName,
      inputs ? [],
      rev ? "d7e3c1baccc96b99ab63c3e99a52c047f0ab996e",
      sha256 ? "11ldizf2lmfnihrg9vxb66q1v74j461harg4y1wsx4qs0d94jpgr"
    }: with pkgs; stdenv.mkDerivation rec {
    inherit baseName;
    version = rev;
    name = "${baseName}-${version}";

    src = fetchFromGitHub {
      inherit rev;
      inherit sha256;
      owner = "weechat";
      repo = "scripts";
    };

    buildInputs = [ weechat ] ++ inputs ++ (lib.optionals (lang == "python") [(pkgs.mine.weechatPythonPackageList pkgs.python)]);
    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out
      cp $src/${lang}/${baseName}* $out/
    '';
  };
in mapAttrs' (name: type: {
  name = removeSuffix ".nix" name;
  value = let file = ./. + "/${name}"; in
  lib.callPackageWith (pkgs // {
    inherit mkWeechatPluginFromMainGithub ;
    inherit debug;
    # passwords = import ../../../external/private/passwords/gen.nix;
  }) file {};
}) (filterAttrs (name: type:
  (type == "directory" && builtins.pathExists "${toString ./.}/${name}/default.nix") ||
  (type == "regular" && hasSuffix ".nix" name && ! (name == "default.nix"))
) (builtins.readDir ./.))