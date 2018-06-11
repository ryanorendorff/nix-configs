{ ... }:

{
  nixpkgs.overlays = [
    (import ../pkgs/overlays.nix)
    (import ../appConfigs/overlays.nix)
  ];
}