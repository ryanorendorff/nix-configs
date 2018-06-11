{pkgs, ...}:

pkgs.writeScript "tmutt" ''
  #!/usr/bin/env bash
  ${pkgs.termite}/bin/termite -e ${pkgs.neomutt}/bin/neomutt -t mutt
''