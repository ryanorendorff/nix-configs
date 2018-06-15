{ prefix ? "", pkgs, ... }:

{
  "${prefix}todoist" = {
    source = pkgs.mine.scripts.todoist;
    executable = true;
  };
}