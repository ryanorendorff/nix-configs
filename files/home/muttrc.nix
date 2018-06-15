{ prefix ? "", pkgs, ... }:

{
  "${prefix}.muttrc" = {
    source = pkgs.appConfigs.neomutt;
  };
}