{pkgs, ...}:

pkgs.writeScript "thtop" ''
  #!/usr/bin/env bash
  ${pkgs.termite}/bin/termite -e "${pkgs.htop}/bin/htop" -t htop
''