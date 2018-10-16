{ prefix ? "", pkgs, ... }:

{
  "${prefix}personal_repos" = {
    source = pkgs.mine.scripts.personal_repos;
    executable = true;
  };
}