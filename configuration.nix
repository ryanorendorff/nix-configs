{ config, pkgs, ... }:

{
  imports = [
    ./nixos/configuration.nix
    # This file was generated by the installation and refers to specific hardware on the machine
    /etc/nixos/hardware-configuration.nix
    # ./nixos/virtualbox.nix
    ./nixos/vmware.nix
  ];
}
