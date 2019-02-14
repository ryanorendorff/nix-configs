{ pkgs, ... }:

pkgs.writeTextFile {
  name = "ap_handles.json";
  text = ''
    {
      "agent_platform": {
        "user": "readwrite",
        "password": "${import ../../../keys/private/ap_readwrite_db.nix}",
        "credential": "${toString (../../../keys/private/trulia_rsa)}",
        "database": "crm",
        "host": "stagedb.sv2.trulia.com"
      },
      "agent_platform_readonly": {
        "user": "readonly",
        "password": "${import ../../../keys/private/ap_readonly_db.nix}",
        "credential": "${toString (../../../keys/private/trulia_rsa)}",
        "database": "crm",
        "host": "stagedb.sv2.trulia.com"
      }
    }
  '';
}
