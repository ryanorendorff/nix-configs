{pkgs, config, ...}:

pkgs.writeScript "trtv" ''
  #!/usr/bin/env bash
  ${pkgs.termite}/bin/termite -e "env BROWSER=${pkgs.mine.scripts.chrome-personal} EDITOR=vim ${pkgs.rtv}/bin/rtv --enable-media" -t rtv
''