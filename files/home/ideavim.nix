{ prefix ? "", pkgs, ... }:

{
  "${prefix}.ideavimrc" = {
    source = pkgs.appConfigs.ideavim;
  };
}