{ ... }:

{
  nixpkgs.overlays = [
    (import ../appConfigs/overlays.nix)
    (import ../cronJobs/overlays.nix)
    (import ../files/overlays.nix)
    (import ../pkgs/overlays.nix)
  ];
}