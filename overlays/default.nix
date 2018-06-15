{ ... }:

{
  nixpkgs.overlays = [
    (import ../appConfigs/overlays.nix)
    (import ../files/overlays.nix)
    (import ../pkgs/overlays.nix)
  ];
}