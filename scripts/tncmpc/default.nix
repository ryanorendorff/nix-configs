{pkgs, stdenv,...}:

let mpd_host = if stdenv.isDarwin then "localhost" else "tdoggett4.zillow.local";
in ''
  #!/usr/bin/env bash
  ${pkgs.termite}/bin/termite -e "${pkgs.ncmpc}/bin/ncmpc -h ${mpd_host}" -t ncmpc
''