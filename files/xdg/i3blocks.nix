{ prefix ? "", pkgs, ... }:

{
  "${prefix}i3blocks/config" = {
    source = pkgs.appConfigs.i3blocks;
  };
}