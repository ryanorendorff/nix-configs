{ prefix ? "", pkgs, ... }:

{
  "${prefix}.npmrc" = {
    source = pkgs.appConfigs.npm;
  };
}