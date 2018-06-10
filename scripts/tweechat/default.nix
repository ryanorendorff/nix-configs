{pkgs, ...}:

''
  #!/usr/bin/env bash
  ${pkgs.termite}/bin/termite -e ${pkgs.mine.weechat}/bin/weechat -t weechat
''