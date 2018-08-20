{ pkgs, lib ? pkgs.lib, debug ? false, ... }:

with lib;

mapAttrs' (name: type: {
  name = removeSuffix ".nix" name;
  value = let file = ./. + "/${name}"; in
  import file {
    inherit pkgs;
    inherit lib;
    inherit debug;
    prefix = if pkgs.stdenv.isDarwin then "Documents/BitBar/" else ".config/bitbar/";
  };
}) (filterAttrs (name: type:
  (type == "directory" && builtins.pathExists "${toString ./.}/${name}/default.nix") ||
  (type == "regular" && hasSuffix ".nix" name && ! (name == "default.nix"))
) (builtins.readDir ./.))