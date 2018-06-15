{ prefix ? "", pkgs, ... }:

{
  "${prefix}sync_projects" = {
    source = pkgs.mine.scripts.sync_projects;
    executable = true;
  };
}