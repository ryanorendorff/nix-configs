{ pkgs, ... }:

pkgs.writeScript "google_drive" ''
  #!/usr/bin/env bash
  echo "$(${pkgs.insync}/bin/insync get_status)$([[ ! -z `${pkgs.insync}/bin/insync get_sync_progress | grep '[0-9]\+ files queued'` ]] && echo ': ')$(${pkgs.insync}/bin/insync get_sync_progress | grep '[0-9]\+ files queued')"
  if [ -n "$BLOCK_BUTTON" ]; then
    [[ "PAUSED" == $(${pkgs.insync}/bin/insync get_status) ]] && ${pkgs.insync}/bin/insync resume_syncing || ${pkgs.insync}/bin/insync pause_syncing
  fi
''
