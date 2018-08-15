{ prefix ? "", pkgs, ... }:

{
  "${prefix}.npmrc.immutable" = {
    source = pkgs.appConfigs.npm;
  };
}