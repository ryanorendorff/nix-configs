{ pkgs, ... }:

let mpd_host = "localhost";
in pkgs.writeScript "tncmpc" ''
  #!/usr/bin/env bash
  ${pkgs.termite}/bin/termite -e "${pkgs.ncmpc}/bin/ncmpc -h ${mpd_host}" -t ncmpc
''
