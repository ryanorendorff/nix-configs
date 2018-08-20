{ prefix ? "", pkgs, ... }:

{
  "${prefix}calendar.1m.sh" = {
    source = pkgs.mine.bitbar.mine.calendar;
    executable = true;
  };
}