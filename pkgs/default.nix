{ ... }:

{
  nixpkgs.overlays = [
    (import ./overlays.nix)
  ];
}