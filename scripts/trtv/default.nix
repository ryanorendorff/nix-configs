{pkgs, config, ...}:

let
  vim = if pkgs.stdenv.isDarwin then pkgs.vim else config.programs.vim.package;
in ''
  #!/usr/bin/env bash
  ${pkgs.termite}/bin/termite -e "env BROWSER=${config.home.file."bin/chrome-personal".target} EDITOR=${vim}/bin/vim ${pkgs.rtv}/bin/rtv --enable-media" -t rtv
''