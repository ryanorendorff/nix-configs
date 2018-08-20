{ prefix ? "", pkgs, ... }:

{
  "${prefix}google_music.5s.sh" = {
    source = pkgs.mine.bitbar.mine.google_music;
    executable = true;
  };
}