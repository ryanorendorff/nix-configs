{ prefix ? "", ... }:

{
  "${prefix}nixos/hardware-configuration.nix" = {
    text = "";
  };
}