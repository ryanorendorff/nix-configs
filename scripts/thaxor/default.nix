{ pkgs, ... }:

''
  #!/usr/bin/env bash
  ${pkgs.termite}/bin/termite -e "${pkgs.haxor-news}/bin/haxor-news" -t haxor
''