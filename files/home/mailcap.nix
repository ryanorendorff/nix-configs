{ prefix ? "", pkgs, ... }:

{
  "${prefix}.mailcap" = {
    source = pkgs.appConfigs.mailcap;
  };
}