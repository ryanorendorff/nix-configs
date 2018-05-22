{pkgs,...}:

''
  #!/usr/bin/env bash
  ${pkgs.termite}/bin/termite -e ${pkgs.weechat}/bin/weechat -t weechat
''