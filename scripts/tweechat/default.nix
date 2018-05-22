{pkgs, mine, ...}:

''
  #!/usr/bin/env bash
  ${pkgs.termite}/bin/termite -e ${mine.weechat-with-slack}/bin/weechat -t weechat
''