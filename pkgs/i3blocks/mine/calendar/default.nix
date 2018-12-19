{pkgs, ...}:

pkgs.writeScript "calendar" ''
    #!/usr/bin/env bash

    # <bitbar.title>My Next Event</bitbar.title>
    # <bitbar.version>v1.0</bitbar.version>
    # <bitbar.author>Tom Doggett</bitbar.author>
    # <bitbar.author.github>nocoolnametom</bitbar.author.github>
    # <bitbar.desc>Displays my next event.</bitbar.desc>
    # <bitbar.dependencies>bash, gcalcli, cut, head, sed</bitbar.dependencies>

    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8

    ${pkgs.gcalcli}/bin/gcalcli --nocolor --calendar "Calendar" \
       --calendar "nocoolnametom@gmail.com" --calendar "Family" \
       agenda "'`date +%Y%m%dT%H%M`'" "'`date +%Y%m%dT2359`'" \
     | cut -d " " -f 4- \
     | head -2 \
     | tail -1 \
     | ${pkgs.gnused}/bin/sed "s/^ *//g" \
     | ${pkgs.gnused}/bin/sed "s/    / /g" \
''
