{ pkgs, lib ? pkgs.lib, debug ? false, ... }:

with lib; with {
  pythonPackages = pkgs.python36Packages;
  myPythonPackages = pkgs.mine.python36Packages;
};
( pkgs.callPackage ../python-modules/python-packages.nix { inherit pkgs; inherit pythonPackages; inherit myPythonPackages; }) //
mapAttrs' (name: type: {
  name = removeSuffix ".nix" name;
  value = let file = ./. + "/${name}"; in
  lib.callPackageWith (pkgs // {
    inherit debug;
    inherit pythonPackages;
    inherit myPythonPackages;
    # passwords = import ../../../external/private/passwords/gen.nix;
  }) file {};
}) (filterAttrs (name: type:
  (type == "directory" && builtins.pathExists "${toString ./.}/${name}/default.nix") ||
  (type == "regular" && hasSuffix ".nix" name && ! (name == "default.nix"))
) (builtins.readDir ./.))