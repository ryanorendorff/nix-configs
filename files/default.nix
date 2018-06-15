{ pkgs, config ? {}, lib ? pkgs.lib, debug ? false, ... }:

with lib;

filterAttrs (n: v: n != "override") (
  mapAttrs' (name: type: {
    name = removeSuffix ".nix" name;
    value = let file = ./. + "/${name}"; in
    lib.callPackageWith (pkgs // {
      inherit debug;
      inherit config;
      # passwords = import ../../external/private/passwords/gen.nix;
    }) file {};
  }) (filterAttrs (name: type:
    (type == "directory" && builtins.pathExists "${toString ./.}/${name}/default.nix") ||
    (type == "regular" && hasSuffix ".nix" name && ! (name == "default.nix") && ! (name == "overlays.nix"))
  ) (builtins.readDir ./.))
)