{ pkgs, config ? {}, lib ? pkgs.lib, debug ? false, isVmware ? false, ... }:

with lib;

mapAttrs' (name: type: {
  name = removeSuffix ".nix" name;
  value = let file = ./. + "/${name}"; in
  lib.callPackageWith (pkgs // {
    inherit debug;
    inherit config;
    inherit isVmware;
    # passwords = import ../../external/private/passwords/gen.nix;
  }) file {};
}) (filterAttrs (name: type:
  (type == "directory" && builtins.pathExists "${toString ./.}/${name}/default.nix") ||
  (type == "regular" && hasSuffix ".nix" name && ! (name == "default.nix") && ! (name == "overlays.nix"))
) (builtins.readDir ./.))