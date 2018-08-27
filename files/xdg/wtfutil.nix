{ prefix ? "", pkgs, ... }:

{
  "${prefix}wtf/config.yml" = {
    source = pkgs.appConfigs.wtfutil;
  };
}