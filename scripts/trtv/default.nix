{pkgs, config, ...}:

''
  #!/usr/bin/env bash
  ${pkgs.termite}/bin/termite -e "env BROWSER=${config.home.file."bin/chrome-personal".target} EDITOR=${pkgs.vim}/bin/nvim ${pkgs.rtv}/bin/rtv --enable-media" -t rtv
''